/*nic.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created nic.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with nic.h
header file
*/

/*
*******************************************************
* Write to NIC Control Register
*******************************************************
*/

void write_rtl(unsigned char regaddr, unsigned char regdata)
{
	//write the regaddr into PORTB
	rtladdr = regaddr;
	tortl;
	//write data into PORTC
	rtldata = regdata;
	#asm
		nop
	#endasm
	//toggle write pin
	clr_iow_pin;
	#asm
		nop
		nop
		nop
	#endasm
	set_iow_pin;
	#asm
		nop
	#endasm
	//set data port back to input
	fromrtl;
	PORTC = 0xFF;
}

/*
*******************************************************
* Read From NIC Control Register
*******************************************************
*/

void read_rtl(unsigned char regaddr)
{
	fromrtl;
	PORTC = 0xFF;
	rtladdr = regaddr;
	clr_ior_pin;
	#asm
		nop
	#endasm
	#asm
		nop
		nop
		nop
	#endasm
	byte_read = PINC;
	set_ior_pin;
	#asm
		nop
	#endasm
}

/*
//**********************************************************
//* Initialize the RTL8019AS
//************************************************************
*/

void init_RTL8019AS()
{
	unsigned char i;
	fromrtl;	//PORTC data lines = input
	PORTC = 0xFF;
	DDRB = 0xFF;
	rtladdr = 0x00; //clear address lines
	DDRA = 0x00; 	//PORTA is an input
	//DDRA = 0xFF;
	DDRD = 0xE0;	//setup IOW, IOR, EEPROM,RXD,TXD,CTS
	PORTD = 0x1F; 	//enable pullups on input pins
	clr_EEDO;
	set_iow_pin;	//disable IOW
	set_ior_pin; 	//disable IOR
	set_rst_pin;	//put NIC in reset
	delay_ms(2);	//delay at least 1.6 ms
	clr_rst_pin;	//disable reset line
	
	read_rtl(RSTPORT);	//read contents of reset port
	write_rtl(RSTPORT,byte_read); //do soft reset
	delay_ms(20);	//give it time
	read_rtl(ISR);	//check for good soft reset
	
	if(!(byte_read & RST))
	{
		//for(i=0;i<sizeof(msg_initfail)-1;++i)
		//{
			//delay_ms1(1);
			//lcd_send_byte(1,msg_initfail[i]);
		//}
	}
	write_rtl(CR,0x21);	//stop the NIC,abort DMA,page 0
	delay_ms(2);		//make sure nothing is coming in or going out
	write_rtl(DCR,dcrval);	//0x58
	write_rtl(RBCR0,0x00);
	write_rtl(RBCR1,0x00);
	write_rtl(RCR,0x04);
	write_rtl(TPSR,txstart);
	write_rtl(TCR,0x02);
	write_rtl(PSTART,rxstart);
	write_rtl(BNRY,rxstart);
	write_rtl(PSTOP,rxstop);
	write_rtl(CR,0x61);
	delay_ms(2);
	write_rtl(CURR,rxstart);
	for(i=0;i<6;++i)
		write_rtl(PAR0+i,MYMAC[i]);
		
	write_rtl(CR,0x21);
	write_rtl(DCR,dcrval);
	write_rtl(CR,0x22);
	write_rtl(ISR,0xFF);
	write_rtl(IMR,imrval);
	write_rtl(TCR,tcrval);
	write_rtl(CR,0x22);
}