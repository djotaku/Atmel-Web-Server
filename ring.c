/*ring.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 13 Apr 2005
created ring.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with ring.h
header file
*/

/*
*****************************************************
* Get A Packet From the Ring
* This routine removes data packet from the receive buffer
* ring
*******************************************************
*/

void get_packet()
{
	unsigned int i;
	//execute a send packet command to retrieve the packet
	write_rtl(CR,0x1A);
	for(i=0;i<4;++i)
	{
		read_rtl(RDMAPORT);
		pageheader[i]=byte_read;
	}
	rxlen = make16(pageheader[enetpacketLenH],pageheader[enetpacketLenL]);
	
	for(i=0;i<rxlen;++i)
	{
		read_rtl(RDMAPORT);
		//dump any bytes that wil overrun the receive buffer  (which is probably > 1kb)
		if(i<700)
			packet[i]=byte_read;
	}
	//changed from * to & typeo 7 Apr 2005
	while(!(byte_read & RDC))
		read_rtl(ISR);
	write_rtl(ISR,0xFF);
	
	//process an ARP packet
	if(packet[enetpacketType0] == 0x08 && packet[enetpacketType1] == 0x06)
	{
		if(packet[arp_hwtype+1]==0x01 && packet[arp_prtype] == 0x08 && packet[arp_prtype+1] == 0x00 && packet[arp_hwlen] == 0x06 && packet[arp_prlen] == 0x04 && packet[arp_op+1] == 0x01 && MYIP[0] == packet[arp_tipaddr] && MYIP[1] == packet[arp_tipaddr+1] && MYIP[2] == packet[arp_tipaddr+2] && MYIP[3] == packet[arp_tipaddr+3])
			arp();
	}
	//process an IP packet
	else if(packet[enetpacketType0] == 0x08 && packet[enetpacketType1] == 0x00 && packet[ip_destaddr] == MYIP[0] && packet[ip_destaddr+1] == MYIP[1] && packet[ip_destaddr+2] == MYIP[2] && packet[ip_destaddr+3] == MYIP[3])
	{
		//do a checksum of the ipheader
		ic_chksum = make16(packet[ip_hdr_cksum],packet[ip_hdr_cksum+1]);
		packet[ip_hdr_cksum] = 0x00;
		packet[ip_hdr_cksum+1] = 0x00;
		hdr_chksum = 0;
		chksum16 = 0;
		hdrlen = (packet[ip_vers_len] & 0x0F) << 2;
		addr = &packet[ip_vers_len];
		cksum();
		chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
		
		if(chksum16 == ic_chksum)
		{
			packet[ip_hdr_cksum] = make8(ic_chksum,1);
			packet[ip_hdr_cksum+1] = make8(ic_chksum,0);
			//Find the IP packet length
			ip_packet_len = make16(packet[ip_pktlen],packet[ip_pktlen+1]);
			//response to packet here
			if(packet[ip_proto] == PROT_ICMP)
				icmp();
			else if(packet[ip_proto] == PROT_UDP)
				udp();
			else if(packet[ip_proto] == PROT_TCP)
				tcp();
		}
	}
}
