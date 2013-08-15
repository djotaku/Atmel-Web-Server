/*icmp.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created icmp.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with icmp.h
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
//#include icmp.h"

/*
********************************************************
* Perform ICMP Function
* This routine responds to a ping
********************************************************
*/

void icmp()
{
	//set echo reply
	packet[ICMP_type] = 0x00;
	packet[ICMP_code] = 0x00;
	
	//clear the ICMP checksum
	packet[ICMP_cksum] = 0x00;
	packet[ICMP_cksum+1] = 0x00;
	
	//setup the IP header
	setipaddrs();
	
	//calculate the ICMP checksum
	hdr_chksum = 0;
	hdrlen = (make16(packet[ip_pktlen],packet[ip_pktlen+1])) - \
	//((packet[ip_vers_len] & 0x0F) * 4);
	((packet[ip_vers_len] & 0x0F) << 2);
	addr = &packet[ICMP_type];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
	packet[ICMP_cksum] = make8(chksum16,1);
	packet[ICMP_cksum+1] = make8(chksum16,0);
	
	//send the ICMP packet along on its way
	echo_packet();
}