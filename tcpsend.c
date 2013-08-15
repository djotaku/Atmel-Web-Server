/*tcpsend.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created tcpsend.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with tcpsend.h
header file

we may want to eventually combine this with tcp.c
*/

/*
******************************************************
* Send TCP Packet
* This routine assembles and sends a complete TCP/IP packet
* 40 bytes of IP and TCP header data is assumed (no options)
******************************************************
*/

void send_tcp_packet()
{
	unsigned int i;
	//count IP and TCP header bytes  Total = 40 bytes
	if(tcpdatalen_out == 0)
	{
		tcpdatalen_out=14;
		for(i=0;i<14;i++)
			packet[TCP_options+i]=0;
		expected_ack=my_seqnum+1;
	}
	else
		expected_ack=my_seqnum+tcpdatalen_out;
	
	ip_packet_len = 40 + tcpdatalen_out;
	packet[ip_pktlen] = make8(ip_packet_len,1);
	packet[ip_pktlen + 1] = make8(ip_packet_len,0);
	packet[ip_proto] = PROT_TCP;
	setipaddrs();
	data_L = packet[TCP_srcport];
	packet[TCP_srcport] = packet[TCP_destport];
	packet[TCP_destport] = data_L;
	data_L = packet[TCP_srcport+1];
	packet[TCP_srcport+1] = packet[TCP_destport + 1];
	packet[TCP_destport+1] = data_L;
	assemble_ack();
	set_packet32(TCP_seqnum,my_seqnum);
	
	packet[TCP_hdrflags+1]=0x00;
	if(ackflag = 1)
		ACK_OUT;
	else
		NO_ACK;
	
	ackflag = 0;
	
	if(flags & finflag)
	{
		FIN_OUT;
		clr_finflag;
	}
	
	packet[TCP_cksum] = 0x00;
	packet[TCP_cksum + 1] = 0x00;
	
	hdr_chksum = 0;
	hdrlen = 0x08;
	addr = &packet[ip_srcaddr];
	cksum();
	hdr_chksum += packet[ip_proto];
	tcplen = ip_packet_len - ((packet[ip_vers_len]& 0x0F)<<2);
	hdr_chksum=hdr_chksum+tcplen;
	hdrlen = tcplen;
	addr = &packet[TCP_srcport];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000)>>16));
	packet[TCP_cksum] = make8(chksum16,1);
	packet[TCP_cksum + 1] = make8(chksum16,0);
	
	txlen = ip_packet_len + 14;
	if(txlen<60)
		txlen = 60;
	data_L = make8(txlen,0);
	data_H = make8(txlen,1);
	write_rtl(CR,0x22);
	read_rtl(CR);
	while(byte_read&0x04)
		read_rtl(CR);
	
	write_rtl(TPSR,txstart);
	write_rtl(RSAR0,0x00);
	write_rtl(RSAR1,0x40);
	write_rtl(ISR,0xFF);
	write_rtl(RBCR0,data_L);
	write_rtl(RBCR1,data_H);
	write_rtl(CR,0x12);
	
	for(i=0;i<txlen;++i)
		write_rtl(RDMAPORT,packet[enetpacketDest0+i]);
		
	byte_read = 0;
	while(!(byte_read & RDC))
		read_rtl(ISR);
	
	write_rtl(TBCR0,data_L);
	write_rtl(TBCR1,data_H);
	write_rtl(CR,0x24);
}

//for sending the html
unsigned int pack_html(unsigned char flash *req_page, unsigned int req_offset)
{
	unsigned char i;
	unsigned char flash *start;
	unsigned char flash *cursor;

	// place cursor at start of data to send
	start = req_page+req_offset;
	cursor = start;

	// send portion of data
	for(i=0; i<100; i++)
	{
		packet[TCP_data+i] = *cursor;
		// advance cursor
		++cursor;
		if(req_page != favicon)
		{
			// check if end of page
			if(*cursor == '\0')
			{
				packet[TCP_data+i+1] = "\0";
				break;
			}
		}
		else
		{
			// check if end of page
			if((cursor-req_page) > page_size)
			{
				packet[TCP_data+i+1] = "\0";
				break;
			}
		}
	}

	// return amount of data
	tcpdatalen_out = cursor-start;
	return tcpdatalen_out;
}