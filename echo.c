/*echo.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created echo.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with echo.h
header file
*/

/*
******************************************************
* Echo Packet Function
* This routine does not modify the incoming packet size and
* thus echoes the original packet structure
********************************************************
*/

void echo_packet()
{
	unsigned int i;
	write_rtl(CR,0x22);
	write_rtl(TPSR,txstart);
	write_rtl(RSAR0,0x00);
	write_rtl(RSAR1,0x40);
	write_rtl(ISR,0xFF);
	write_rtl(RBCR0,pageheader[enetpacketLenL]-4);
	write_rtl(RBCR1,pageheader[enetpacketLenH]);
	write_rtl(CR,0x12);
	
	txlen = make16(pageheader[enetpacketLenH],pageheader[enetpacketLenL])-4;
	for(i=0;i<txlen;++i)
		write_rtl(RDMAPORT,packet[enetpacketDest0+i]);
	
	byte_read = 0;
	while(!(byte_read&RDC))
		read_rtl(ISR);
		
	write_rtl(TBCR0,pageheader[enetpacketLenL]-4);
	write_rtl(TBCR1,pageheader[enetpacketLenH]);
	write_rtl(CR,0x24);
}
