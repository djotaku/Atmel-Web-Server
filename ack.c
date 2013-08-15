/*ack.c library source file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created ack.c
simply an implementation
of what Jeremy had written
without any extra optimizations
outside of what we had fixed
as of atmelwebserver.c ver 0.94.1
*********************************

goes along with ack.h
header file
*/

/*
*****************************************************
* Assemble the Acknowledgement
* This function assembles the acknowledgement to send to
* the client by adding the received data count to the 
* client's incoming sequence number
******************************************************
*/

void assemble_ack()
{
	client_seqnum=make32(packet[TCP_seqnum],packet[TCP_seqnum+1], packet[TCP_seqnum+2], packet[TCP_seqnum+3]);
	client_seqnum += tcpdatalen_in;
	set_packet32(TCP_acknum,client_seqnum);
}