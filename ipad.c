/*ipad.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 13 Apr 2005
created ipad.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with ipad.h
header file
*/

/*
********************************************************
* SETIPADDRS
* This function builds the IP header
*********************************************************
*/

void setipaddrs()
{
	packet[enetpacketType0] = 0x08;
	packet[enetpacketType1] = 0x00;
	/* client[0] = packet[ip_srcaddr+1];
	client[1] = packet[ip_srcaddr+1];
	client[2] = packet[ip_srcaddr+2];
	client[3] = packet[ip_srcaddr+3];
	//move IP source address to destination address
	packet[ip_destaddr] = client[0];
	packet[ip_destaddr+1] = client[1];
	packet[ip_destaddr+2] = client[2];
	packet[ip_destaddr+3] = client[3];*/
	//move IP source address to destination address
	packet[ip_destaddr] = packet[ip_srcaddr];
	packet[ip_destaddr+1] = packet[ip_srcaddr+1];
	packet[ip_destaddr+2] = packet[ip_srcaddr+2];
	packet[ip_destaddr+3] = packet[ip_srcaddr+3];
	//make ethernet module IP address source address
	packet[ip_srcaddr] = MYIP[0];
	packet[ip_srcaddr+1] = MYIP[1];
	packet[ip_srcaddr+2] = MYIP[2];
	packet[ip_srcaddr+3] = MYIP[3];
	//move hardware source address to destination address
	packet[enetpacketDest0] = packet[enetpacketSrc0];
	packet[enetpacketDest1] = packet[enetpacketSrc1];
	packet[enetpacketDest2] = packet[enetpacketSrc2];
	packet[enetpacketDest3] = packet[enetpacketSrc3];
	packet[enetpacketDest4] = packet[enetpacketSrc4];
	packet[enetpacketDest5] = packet[enetpacketSrc5];
	//make ethernet module mac address the source address
	packet[enetpacketSrc0] = MYMAC[0];
	packet[enetpacketSrc1] = MYMAC[1];
	packet[enetpacketSrc2] = MYMAC[2];
	packet[enetpacketSrc3] = MYMAC[3];
	packet[enetpacketSrc4] = MYMAC[4];
	packet[enetpacketSrc5] = MYMAC[5];
	//set IP header length to 20 bytes
	packet[ip_vers_len] = 0x45;
	//calculate IP packet length done by the respective protocols
	//calculate the IP header checksum
	packet[ip_hdr_cksum] = 0x00;
	packet[ip_hdr_cksum+1] = 0x00;
	hdr_chksum = 0;
	hdrlen = (packet[ip_vers_len] & 0x0F) << 2;
	addr = &packet[ip_vers_len];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000)>>16));
	packet[ip_hdr_cksum] = make8(chksum16,1);
	packet[ip_hdr_cksum+1] = make8(chksum16,0);
}