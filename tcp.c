/*tcp.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created tcp.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with tcp.h
header file
*/

/*
*****************************************************
* TCP Function
* This function uses TCP protocol to interface with the browsser
* using well known port 80.  The application function is called with
* ever incoming character.
******************************************************
*/

void tcp()
{
	//assemble the destination port address (my) from from the incoming packet
	portaddr = make16(packet[TCP_destport],packet[TCP_destport+1]);
	//calculate the length of teh data coming in with the packet
	//incoming tcp header length
	tcplen = ip_packet_len - ((packet[ip_vers_len] & 0x0F) << 2);
	//incoming data length =
	tcpdatalen_in = (make16(packet[ip_pktlen],packet[ip_pktlen+1])) - \
	((packet[ip_vers_len] & 0x0F) << 2)-(((packet[TCP_hdrflags] & 0xF0) >> 4) << 2);
	//convert the entire packet into a checksum
	//checksum of entire datagram
	ic_chksum = make16(packet[TCP_cksum],packet[TCP_cksum+1]);
	packet[TCP_cksum] = 0x00;
	packet[TCP_cksum+1] = 0x00;
	hdr_chksum = 0;
	hdrlen = 0x08;
	addr = &packet[ip_srcaddr];
	cksum();
	hdr_chksum += packet[ip_proto];
	hdr_chksum += tcplen;
	hdrlen = tcplen;
	addr = &packet[TCP_srcport];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >>16));
	if((chksum16 == ic_chksum)&&(portaddr==MY_PORT_ADDRESS))
	{
		//The webserver can only connect to one client at a time
		{
			/*------3 Way handshake--*/
			//this code segment processs the incoming SYN from the client
			//and sends back the initial sequence number (ISN) and acknowledges
			//the incoming SYN packet (step 1 and 2 of 3 way handshake)
			if(SYN_IN && portaddr == MY_PORT_ADDRESS)
			{
				counter=0;
								
				tcpdatalen_in=0x01;
				tcpdatalen_out = 0;
				set_synflag;
				client[0] = packet[ip_srcaddr];
				client[1] = packet[ip_srcaddr+1];
				client[2] = packet[ip_srcaddr+2];
				client[3] = packet[ip_srcaddr + 3];
				//bulid IP header switch the dest and src IPs 
				setipaddrs();
				//set the header field to 24 bytes(MSS options)
				//packet[TCP_hdrflags] = (0x6<<4)&0xF0
				//set the ports
				data_L = packet[TCP_srcport];
				
				packet[TCP_srcport]=packet[TCP_destport];
				packet[TCP_destport]=data_L;
				
				data_L=packet[TCP_srcport+1];
				
				packet[TCP_srcport+1] = packet[TCP_destport+1];
				packet[TCP_destport+1] = data_L;
				//ack = SEQ_IN + 1
				assemble_ack();
				//if the seqnum overflows (>16 bits)
				if(++ISN == 0x0000 || ++ISN == 0xFFFF)
					my_seqnum=0x1234FFFF;
				//expected ackknowledgement
				expected_ack=my_seqnum+1;
				set_packet32(TCP_seqnum,my_seqnum);
				packet[TCP_hdrflags+1] = 0x00;
				SYN_OUT;
				ACK_OUT;
				
				packet[TCP_cksum] = 0x00;
				packet[TCP_cksum+1] = 0x00;
				
				hdr_chksum = 0;
				hdrlen = 0x08;
				addr = &packet[ip_srcaddr];
				cksum();
				hdr_chksum = hdr_chksum + packet[ip_proto];
				tcplen = make16(packet[ip_pktlen],packet[ip_pktlen+1]) - \
				((packet[ip_vers_len]&0x0F)<<2);
				hdr_chksum = hdr_chksum + tcplen;
				hdrlen = tcplen;
				addr = &packet[TCP_srcport];
				cksum();
				chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
				//write the checksum into the packet
				packet[TCP_cksum] = make8(chksum16,1);
				packet[TCP_cksum+1] = make8(chksum16,0);
				//send the packet with the same data it came with
				echo_packet();
			}
		}
		//if we are waiting for an ack or waiting for data from the client we are connected to 
		if((client[0]== packet[ip_srcaddr])&&(client[1]==packet[ip_srcaddr+1])&&(client[2]==packet[ip_srcaddr+2])&&(client[3]==packet[ip_srcaddr+3]))
		{
			//if an ack is received
			if(ACK_IN)
			{
				//assemble the acknowledgement number from the incoming packet
				incoming_ack = make32(packet[TCP_acknum],packet[TCP_acknum+1],packet[TCP_acknum+2],packet[TCP_acknum+3]);
				if(incoming_ack==expected_ack)
				{
					my_seqnum=incoming_ack;
					//if it is the result of a close operations
					//if the client is the one who initiated the close operation
					if(closeflag==2)
						closeflag=0;
					else if(closeflag==1)
						closeflag=2;
					if(synflag_bit)
					{
							clr_synflag;
							//next step is to wait for a "get" request
					}
					if(tcpdatalen_in)
					{
						//if the packet is more than we can handle, we just take the 1st 200 bytes of data
						//and then ack the 200 bytres so that the client can resend the excluded data
						if(tcpdatalen_in > 400)
							tcpdatalen_in=400;
						ackflag=1;
						http_server();
					}
					else
					{
						if(sendflag == 1)
						{
							sendflag = 0;
							ackflag = 1;
							//send next batch of data
							http_server();
						}
					}
				}
				else if(incoming_ack<expected_ack)
				{
					my_seqnum=expected_ack - (expected_ack - incoming_ack);
					sendflag=0;
					ackflag=1;
					pageendflag=0;
					rollback=1;
					counter = counter - (expected_ack-incoming_ack);
					//resend data
					http_server();
				}
			}
			if(FIN_IN)
			{
				ackflag=1;
				send_tcp_packet();
				if(closeflag==0)
				{
					closeflag=1;
				   	tcp_close();
				}
				else if(closeflag == 2)
					closeflag=0;
			}
		}
	}
}

//------------TCP CLOSE CONNECTION FUNCTION ----
void tcp_close()
{
	set_finflag;
	tcpdatalen_out=0;
	send_tcp_packet();
	closeflag++;
}

/*
**********************************************************
*  CHECKSUM CALCULATION ROUTINE
* just add 16 bits to hdrchksum until you reach the end of hdrlen
*********************************************************
*/
void cksum()
{
	while(hdrlen>1)
	{
		//top 8 bits pointed to
		data_H =*addr++;
		//next 8 bits pointed to
		data_L =*addr++;
		//converting the 2 bits together into a 16bit number
		chksum16=make16(data_H,data_L);
		//adding the 16bit number to itself (where is the 1s complement?!?)
		hdr_chksum += chksum16;
		//move along the header
		hdrlen -= 2;
	}
	//when hdrlen = 1 (ie only 8 bits left)
	if(hdrlen>0)
	{
		data_H =*addr;
		data_L =0x00;
		chksum16 = make16(data_H,data_L);
		hdr_chksum= hdr_chksum+chksum16;
	}
}