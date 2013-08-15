/*ringbuff.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 13 Apr 2005
created ringbuff.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with ringbuff.h
header file
*/

/*
******************************************************
* Handle Receive Ring Buffer Overrun
* No packets are recovered
*******************************************************
*/

void overrun()
{
	read_rtl(CR);
	data_L = byte_read;
	write_rtl(CR,0x21);
	delay_ms(2);
	write_rtl(RBCR0,0x00);
	write_rtl(RBCR1,0x00);
	if(!(data_L&0x04))
		resend = 0;
	else if(data_L & 0x04)
	{
		read_rtl(ISR);
		data_L = byte_read;
		if((data_L&0x02) || (data_L & 0x08))
			resend = 0;
		else
			resend = 1;
	}
	
	write_rtl(TCR,0x02);
	write_rtl(CR,0x22);
	write_rtl(BNRY,rxstart);
	write_rtl(CR,0x62);
	write_rtl(CURR,rxstart);
	write_rtl(CR,0x22);
	write_rtl(ISR,0x10);
	write_rtl(TCR,tcrval);
}