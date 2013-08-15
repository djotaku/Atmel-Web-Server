/*udp.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created udp.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with udp.h
header file
*/

//****************************************************
//* UDP Function (To be used with DHCP)
//* UDP_srcport = 0, destination is either 67 or 68 IP is
//* 0000000 and 255.255.255.255.255
//****************************************************
void udp()
{
	//use port 68 DHCP
	if(packet[UDP_destport] == 0x00 && packet[UDP_destport+1] == 0x44)
	{
		ic_chksum = make16(packet[UDP_cksum],packet[UDP_cksum+1]);
		//calculate the UDP checksum
		packet[UDP_cksum] = 0x00;
		packet[UDP_cksum+1] = 0x00;
		
		hdr_chksum = 0;
		hdrlen = 0x08;
		addr = &packet[ip_srcaddr];
		cksum();
		hdr_chksum = hdr_chksum + packet[ip_proto];
		hdrlen = 0x02;
		addr = &packet[UDP_len];
		cksum();
		hdrlen = make16(packet[UDP_len],packet[UDP_len+1]);
		addr = &packet[UDP_srcport];
		cksum();
		chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
		//perform checksum
		if(chksum16 == ic_chksum)
			dhcp();
	}
}
void udp_send()
{
	unsigned int i;
	ip_packet_len = 20+make16(packet[UDP_len],packet[UDP_len+1]);
	
	packet[ip_pktlen] = make8(ip_packet_len,1);
	packet[ip_pktlen+1] = make8(ip_packet_len,0);
	packet[ip_proto] = PROT_UDP;
	
	//calculate the IP header checksum
	packet[ip_hdr_cksum] = 0x00;
	packet[ip_hdr_cksum+1] = 0x00;
	hdr_chksum = 0;
	chksum16 = 0;
	hdrlen = (packet[ip_vers_len] & 0x0F)<<2;
	addr = &packet[ip_vers_len];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
	packet[ip_hdr_cksum] = make8(chksum16,1);
	packet[ip_hdr_cksum+1] = make8(chksum16,0);
	
	//set the source port to 68 (client)
	packet[UDP_srcport] = 0x00;
	packet[UDP_srcport+1] = 0x44;
	
	//set the destination port to 67 (server)
	packet[UDP_destport] = 0x00;
	packet[UDP_destport+1] = 0x43;
	
	//calculate the UDP checksum
	packet[UDP_cksum] = 0x00;
	packet[UDP_cksum+1] = 0x00;
	
	hdr_chksum = 0;
	hdrlen = 0x08;
	addr = &packet[ip_srcaddr];
	cksum();
	hdr_chksum = hdr_chksum + packet[ip_proto];
	hdrlen = 0x02;
	addr = &packet[UDP_len];
	cksum();
	hdrlen = make16(packet[UDP_len],packet[UDP_len+1]);
	addr = &packet[UDP_srcport];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
		
	packet[UDP_cksum] = make8(chksum16,1);
	packet[UDP_cksum+1] = make8(chksum16,0);
	
	txlen = ip_packet_len + 14;
	//transmit length
	if(txlen < 60)
		txlen = 60;
	data_L = make8(txlen,0);
	data_H = make8(txlen,1);
	write_rtl(CR,0x22);
	read_rtl(CR);
	while(byte_read & 0x04)
		read_rtl(CR);
	write_rtl(TPSR,txstart);
	write_rtl(RSAR0,0x00);
	write_rtl(RSAR1,0x40);
	write_rtl(ISR,0xFF);
	write_rtl(RBCR0, data_L);
	write_rtl(RBCR1, data_H);
	write_rtl(CR,0x12);
	//the actual send operation
	for(i=0;i<txlen;++i)         
		write_rtl(RDMAPORT,packet[enetpacketDest0+i]);
	byte_read = 0;
	while(!(byte_read & RDC))
		read_rtl(ISR);
	write_rtl(TBCR0, data_L);
	write_rtl(TBCR1, data_H);
	write_rtl(CR,0x24);
}
void dhcp_setip()
{
	//build the IP header
	//destination ip = 255.255.255.255
	packet[ip_destaddr] = 0xFF;
	packet[ip_destaddr + 1] = 0xFF;
	packet[ip_destaddr + 2] = 0xFF;
	packet[ip_destaddr + 3] = 0xFF;
	//source IP = 0.0.0.0
	packet[ip_srcaddr] =  	  0;
	packet[ip_srcaddr + 1] =  0;
	packet[ip_srcaddr + 2] =  0;
	packet[ip_srcaddr + 3] =  0;
	//you don't know the destination MAC
	packet[enetpacketDest0] = 255;
	packet[enetpacketDest1] = 255;
	packet[enetpacketDest2] = 255;
	packet[enetpacketDest3] = 255;
	packet[enetpacketDest4] = 255;
	packet[enetpacketDest5] = 255;
	//make ethernet module mac address the source address
	packet[enetpacketSrc0] = MYMAC[0];
	packet[enetpacketSrc1] = MYMAC[1];
	packet[enetpacketSrc2] = MYMAC[2];
	packet[enetpacketSrc3] = MYMAC[3];
	packet[enetpacketSrc4] = MYMAC[4];
	packet[enetpacketSrc5] = MYMAC[5];
	//calculate IP packet length done by the respective protocols
	packet[enetpacketType0] = 0x08;
	packet[enetpacketType1] = 0x00;
	//set IP header length to 20 bytes
	packet[ip_vers_len] = 0x45;
	//1st step in getting an IP address
}
