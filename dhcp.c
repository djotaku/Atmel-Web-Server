/*dhcp.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created dhcp.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with dchp.h
header file
*/

/*
******************************************************
* DHCP for obtaining IP from router port 67~68 using UDP
******************************************************
*/

void dhcp()
{
	unsigned char i;
	if(dhcpstate == DHCP_DIS)
	{
		//listen to broadcast
		for(i=0;i<4;i++)
			MYIP[i] = 255;
		packet[DHCP_op] = 1;
		packet[DHCP_htype] = 1;
		packet[DHCP_hlen] = 6;
		packet[DHCP_hops] = 0;
		packet[DHCP_xid] = make8(0x31257A1D,3);
		packet[DHCP_xid+1] = make8(0x31257A1D,2);
		packet[DHCP_xid+2] = make8(0x31257A1D,1);
		packet[DHCP_xid+3] = make8(0x31257A1D,0);
		for(i=DHCP_secs;i<DHCP_chaddr;i++)
			packet[i]=0;
		for(i=0;i<6;i++)
			packet[DHCP_chaddr+i] = MYMAC[i];
		for(i=0;i<10;i++)
			packet[DHCP_chaddr+6+i] = 0;
		for(i=0;i<192;i++)
			packet[DHCP_sname+i]=0;
		//magic cookie
		packet[DHCP_options] = 99;
		packet[DHCP_options+1] = 130;
		packet[DHCP_options+2] = 83;
		packet[DHCP_options+3] = 99;
		//message type
		packet[DHCP_options+4] = 53;
		packet[DHCP_options+5] = 1;
		//DHCP_DISCOVER
		packet[DHCP_options+6] = 1;
		//Client Identifier
		packet[DHCP_options+7] = 61;
		packet[DHCP_options+8] = 7;
		packet[DHCP_options+9] = 1;
		for(i=0;i<6;i++)
			packet[DHCP_options+10+i] = MYMAC[i];
		//END OPTIONS
		packet[DHCP_options+16] = 255;
		//lenght of UDP datagram = 8bytes; length of DHCP data = 236 bytes + options
		dhcpoptlen = 17;
		packet[UDP_len] = make8(244+dhcpoptlen,1);
		packet[UDP_len+1] = make8(244+dhcpoptlen,0);
		dhcp_setip();
		udp_send();
		for(i=0;i<4;i++)
			MYIP[i] = 255;
		DHCP_wait = 1;
		//wait for DHCP offer
		dhcpstate = DHCP_OFF;
	}
	//if we have an offer from the server
	if(dhcpstate == DHCP_OFF) // && packet[ip_srcaddr] && packet[ip_srcaddr +1] && packet[ip_srcaddr + 2] && packet[ip_srcaddr+3])
	{
		//check transaction id adn message type
		if((DHCP_wait == 2) || ((make32(packet[DHCP_xid], packet[DHCP_xid+1], packet[DHCP_xid+2],packet[DHCP_xid+3]) == 0x31257A1D) && (packet[DHCP_options+4] == 53) && (packet[DHCP_options+5] == 1) && (packet[DHCP_options+6] ==2)))
		{
			if(DHCP_wait == 1)
			for(i=0;i<4;i++)
			{
				req_ip[i] = packet[DHCP_yiaddr+i];
				serverid[i]= packet[ip_srcaddr+i];
			}
			//stop resending discover
			DHCP_wait = 2;
			// listen to broadcast
			for(i=0;i<4;i++)
				MYIP[i] = 255;
			//assemble DHCP_req
			packet[DHCP_op] = 1;
			packet[DHCP_htype] = 1;
			packet[DHCP_hlen] = 6;
			packet[DHCP_hops] = 0;
			packet[DHCP_xid] = make8(0x31257A1D,3);
			packet[DHCP_xid+1] = make8(0x31257A1D,2);
			packet[DHCP_xid+2] = make8(0x31257A1D,1);
			//fixed typeo, this was +1 and should be +3, fixed 7 Apr 2005
			packet[DHCP_xid+3] = make8(0x31257A1D,0);
			for(i=DHCP_secs;i<DHCP_yiaddr;i++)
				packet[i]=0;
			for(i=DHCP_siaddr;i<DHCP_chaddr;i++)
			           packet[i]=0;
			for(i=0;i<6;i++)
				packet[DHCP_chaddr+i] = MYMAC[i];
			for(i=0;i<10;i++)
				packet[DHCP_chaddr+6+i] = 0;
			for(i=0;i<192;i++)
				packet[DHCP_sname+i]=0;
			//magic cookie
			packet[DHCP_options] = 99;
			packet[DHCP_options+1] = 130;
			packet[DHCP_options+2] = 83;
			packet[DHCP_options+3] = 99;
			//message type
			packet[DHCP_options+4] = 53;
			packet[DHCP_options+5] = 1;
			//DHCP_REQUEST
			packet[DHCP_options+6] =  3;
			//Client Identifier
			packet[DHCP_options+7] = 61;
			packet[DHCP_options+8] = 7;
			packet[DHCP_options+9] = 1;
			for(i=0;i<6;i++)
				packet[DHCP_options+10+i] = MYMAC[i];
			//Requested IP address
			packet[DHCP_options+16]=50;
			packet[DHCP_options+17]=4;
			for(i=0;i<4;i++)
				packet[DHCP_options+18+i] = req_ip[i];
			for(i=0;i<4;i++)
				packet[DHCP_yiaddr+i]=0;
			//server ID
			packet[DHCP_options+22] = 54;
			packet[DHCP_options+23] = 4;
			for(i=0;i<4;i++)
				packet[DHCP_options+24+i] = serverid[i];
			//END OPTIONS
			packet[DHCP_options + 28] = 255;
			//length of UDP datagram = 8bytes; length of DHCP data = 235 bytes + options
			dhcpoptlen = 29;
			packet[UDP_len] = make8(244+dhcpoptlen,1);
			packet[UDP_len+1] = make8(244+dhcpoptlen,0);
			//make a DHCP request
			dhcp_setip();
			udp_send();
			//wait for DHCP ACK
			dhcpstate = DHCP_ACK;
		}
	}
	if((dhcpstate == DHCP_ACK) && (packet[ip_srcaddr] == serverid[0]) && (packet[ip_srcaddr+1] == serverid[1]) && (packet[ip_srcaddr+2] == serverid[2]) && (packet[ip_srcaddr + 3] == serverid[3]))
	{
		//check if message type is an ack
		if((make32(packet[DHCP_xid],packet[DHCP_xid+1],packet[DHCP_xid+2],packet[DHCP_xid+3]) == 0x31257A1D)&&(packet[DHCP_options+4]==53)&&(packet[DHCP_options+5] == 1)&&(packet[DHCP_options+6]==5))
		{
			DHCP_wait = 0;
			//take the IP address
			for(i=0;i<4;i++)
				MYIP[i] = packet[DHCP_yiaddr+i];
		}
	}
}
