/*arp.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created arp.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with arp.h
header file
*/

/*
*******************************************************
* Perform ARP Response
* This routine supplies a requesting computer with the
* Ethernet module's MAC (hardware) address
*******************************************************
*/

//it's not standard C
//but this compiler is silly
//you include the .c file
//in the .h file instead
//of the other way around
//#include arp.h"

void arp()
{
	unsigned char i;

	//start the NIC
	write_rtl(CR,0x22);
	
	//load beginning page for transmit buffer
	write_rtl(TPSR,txstart);
	
	//set start address for remote DMA operation
	write_rtl(RSAR0,0x00);
	write_rtl(RSAR1,0x40);
	
	//clear the interrupts
	write_rtl(ISR,0xFF);
	
	//load data byte count for remote DMA
	write_rtl(RBCR0,0x3C);
	write_rtl(RBCR1,0x00);
	
	//do remote write operation
	write_rtl(CR,0x12);
	
	//write destination MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,packet[enetpacketSrc0+i]);
		
	//write source MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,MYMAC[i]);
		
	//write typelen hwtype prtype hwlen prlen op:
	addr = &packet[enetpacketType0];
	packet[arp_op+1] = 0x02;
	for(i=0;i<10;++i)
		write_rtl(RDMAPORT,*addr++);
	
	//write ethernet module MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,MYMAC[i]);
	
	//write ethernet module IP address
	for(i=0;i<4;++i)
		write_rtl(RDMAPORT,MYIP[i]);
	
	//write remote MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,packet[enetpacketSrc0+i]);
		
	//write remote IP address
	for(i=0;i<4;++i)
		write_rtl(RDMAPORT,packet[arp_sipaddr+i]);
		
	//write some pad characeters to fill out the packet to 
	//the minimum length
	for(i=0;i<0x12;++i)
		write_rtl(RDMAPORT,0x00);
		
	//make sure the DMA operation has successfully completed
	byte_read=0;
	while(!(byte_read & RDC))
		read_rtl(ISR);
	
	//load number of bytes to be transmitted
	write_rtl(TBCR0,0x3C);
	write_rtl(TBCR1,0x00);
	
	//send the contents of the transmit buffer onto the network
	write_rtl(CR,0x24);
}
