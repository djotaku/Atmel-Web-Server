/*Project:  AVR Web Server
by: Eric Mesa and Richard West
based upon version 0.93 beta 
by: Jeremy

Current working version 0.95

Version 0.94.1 9 Apr 2005
1) Eliminated minor redundancies (eg x++ instead of x=x+1)

Version 0.94 9 Apr 2005
1) Fixed browser compatibility problems by correctly padding the html header
This involved adding 12 spaces at the front and a \r\n at the end

Version 0.93.1 6 April 2005
1) Fixed typoes in copying from PDF

Version 0.93 4 March 2004
1) Added Checksum for incoming TCP packets (fixed)
2) Added TCP data sending function (only sends 1 packet at a time Window functionality should be done)
3)Increased packet size from 96 - 300 (since we can have 576 max packet length)
4)Added HTTP functions and HTTP sample
5)Added DHCP functionality
6)Need to tweak the TCP_close() functionality
7) Note: The webbrowesers use the RST fucntion whenever it is closed.  Don't think will need the TCP_close()
*****TESTING*****
6) DHCP WORKING!
7) IMCP working!!
7) HTTP up!!
8) TCP resend lost data working (tested)
8) (fixed) didn't do the setting of packets properly only set the 1st byte must do all bytes
*/

//*******************************************
//*            PORT MAP
//*******************************************
//PORT C = rtldata - data bus RCTL8019 and AVR
// 0 SD0
// 1 SD1
// 2 SD2
// 3 SD3
// 4 SD4
// 5 SD5
// 6 SD6
// 7 SD7
// PORT B
// 0 SA0
// 1 SA1
// 2 SA2
// 3 SA3
// 4 SA4
// 5
// 6
// 7 make this the rst_pin
// PORT A
// temperature sensor port

//PORT D
//0 RXD
//1 TXD 
//2 INT0 --> for EEPROM only
// 3 EESK
//4 EEDI
//5 EEDO
//6 ior_pin
//7 iow_pin

#include<mega32.h>
#include<string.h>
#include<stdio.h>
#include<delay.h>
#include<stdlib.h>

#define ISO_G 0x47
#define ISO_E 0x45
#define ISO_T 0x54
#define ISO_slash 0x2f
#define ISO_c 0x63
#define ISO_g 0x67
#define ISO_i 0x69
#define ISO_space 0x20
#define ISO_nl 0x0a
#define ISO_cr 0x0d
#define ISO_a 0x61
#define ISO_t 0x74
#define ISO_hash 0x23
#define ISO_period 0x2e
//define the connection structure for a single TCP socket (multiple connections)
char flash *req_page[100];
unsigned int page_size;                                                                                           
//added extra \r\n after Content-type for compatibility with everyone other than IE
flash char flash *index[71] = {"            HTTP/1.1 200 OK\r\n","Server: My MEng Project\r\n","Content-type: text/html\r\n",
	"\r\n<html>\r\n",
	"<head>\r\n","<title>ECE MEng Project Cornell University 2003~4 Done by Jeremy</title>\r\n",
	"<meta http-equiv=","","Content-Type","","content=","","text/html; charset=iso-8859-1","",">\r\n",
	"</head>\r\n","<body bgcolor=","","#FFFFFF","",">\r\n",
	"<h1><strong><font colour=","","#0000FF", ""," face=","","Arial, Helvetica, sans-serif","",">WELCOME TO ATMEL WEBSERVER</font></strong></h1>\r\n"
	"<p>&nbsp;</p>\r\n",
	"<p><strong><font colour=","","#000FF","","face=","","Arial, Helvetica, sans-serif","",">This webserver is running entirely on a mega32 and using an EDTP packet wacker</font></strong></p>\r\n",
	"<p><strong><font colour=","","#000FF","","face=","","Arial, Helvetica, sans-serif","",">This project was done by Tzeming Tan, Jeremy supervised by Dr. Bruce R. Land.</font></strong></p>\r\n",
	"<p>Cornell University</p>",
	"<p>ATMEL embedded webserver</p>"
	"<p>TCP/IP is the communcatiosn protocol most widely used for accessing the internet\r\n",
	"today.  The objective of this project is to introduce this protocol to the ATMEL\r\n",
	"Mega 32 Microcontroller chip such that it can run as a simple webserver which\r\n",
	"can then be adapted for useful lab-based applications.</p>\r\n",
	"<p>Although the Mega 32 and the development board will only be able to run limited\r\n",
	"web functions, it is a relatively inexpensive device compared to high power\r\n",
	"web servers.  Therefore it can still have many applications for example, connecting\r\n",
	"the microcontroller to a thermometer which will display the current temperature on a browser.<br>\r\n",
	"The current temperature is now:", "<font color=#FF0000>","%","</font>"," degrees F",
	"<p>&nbsp;</p>\r\n",
	"<p>link to ECE 476 website <a href=","","http://instruct1.cit.cornell.edu/courses/ee476/","",">here</a>.<br>",
	"<p>&nbsp;</p>\r\n",
	"<p><br>\r\n</p>\r\n<p>&nbsp;</p>\r\n</body>\r\n</html>"};
unsigned int size_index = 71;
unsigned int http_state = 0;
unsigned int sendflag = 0;
unsigned int pageendflag = 0;
char temperature = 0;
char temp[5];
float voltage; //scaled input voltage
unsigned int Ain;

//*****************************
//*    FUNCTION PROTOTYPES
//*****************************
void http_server(void);
void tcp(void);
void tcp_close(void);
void assemble_ack(void);
void write_rtl(unsigned char regaddr, unsigned char regdata);
void read_rtl(unsigned char regaddr);
void get_packet(void);
void setipaddrs(void);
void cksum(void);
void echo_packet(void);
//x is the index number, y is the character number
void pack_html(unsigned int page, unsigned int x, unsigned int y);
//void pack_html(flash char flash*page[], unsigned int x, unsigned int y);
#define INDEX 0
unsigned int dex,pos = 0;
unsigned int rollback,counter = 0;
//end of pack html function
void send_tcp_packet(void);
void arp(void);
void icmp(void);
void udp(void);
void udp_send(void);
//DHCP FUCNTIONS
void dhcp(void);
void dhcp_setip(void);
//Temperature function
void gettemp(void);

//*******************************************
//*     IP ADDRESS DEFINITION
//* This is the Ethernet Module IP address
//* You may change this to any valid address
//*******************************************
unsigned char MYIP[4] = {192,168,2,255};
unsigned char client[4];
unsigned char serverid[4];
//*****************************************
//*    HARDWARE (MAC) ADDRESS DEFINITION
//* This is the Ethernet Module hardware address
//* You may change this to any valid address
//*****************************************
char MYMAC[6]={'J','e','s','t','e','r'};
//*****************************************
//*  Recieve Ring Buffer Header Layout
//* This is the 4-byte header that resides in front of the
//* data packet in the receive buffer
//******************************************
unsigned char pageheader[4];
#define enetpacketstatus 0x00
#define nextblock_ptr 	 0x01
#define enetpacketLenL 	 0x02
#define enetpacketLenH 	 0x03
//*******************************************
//*    Ethernet Header Layout
//*******************************************
unsigned char packet[700]; //700 bytes of packet space
#define enetpacketDest0 0x00 
//destination mac address
#define enetpacketDest1 0x01
#define enetpacketDest2 0x02
#define enetpacketDest3 0x03
#define enetpacketDest4 0x04
#define enetpacketDest5 0x05
#define enetpacketSrc0  0x06
//source mac address
#define enetpacketSrc1  0x07
#define enetpacketSrc2  0x08
#define enetpacketSrc3  0x09
#define enetpacketSrc4  0x0A
#define enetpacketSrc5  0x0B
#define enetpacketType0 0x0C
//type/length field
#define enetpacketType1 0x0D
#define enetpacketData  0x0E
//IP data area begins here
//******************************************
//* ARP Layout
//******************************************
#define arp_hwtype  0x0E
#define arp_prtype  0x10
#define arp_hwlen   0x12
#define arp_prlen   0x13
#define arp_op      0x14
#define arp_shaddr  0x16
//arp source mac address
#define arp_sipaddr 0x1C
//arp source IP address
#define arp_thaddr 0x20 
//arp target mac address
#define arp_tipaddr 0x26
//arp target ip address
//****************************************
//* IP Header Layout
//****************************************
#define ip_vers_len    0x0E 
//IP version and header length
#define ip_tos 	       0x0F
//IP type of service
#define ip_pktlen      0x10
//packet length
#define ip_id          0x12
//datagram ID
#define ip_frag_offset 0x14
//fragment offset
#define ip_ttl 	       0x16 
//time to live
#define ip_proto       0x17
//protocol (ICMP=1, TCP=6, UDP=11)
#define ip_hdr_cksum   0x18 
//header checksum
#define ip_srcaddr     0x1A
//IP address of source
#define ip_destaddr    0x1E
//IP aaddress of destination
#define ip_data        0x22
//IP data area
//************************************
//* TCP Header Layout
//************************************
#define TCP_srcport   0x22 
//TCP source port
#define TCP_destport  0x24
//TCP destination port
#define TCP_seqnum    0x26
//sequence number
#define TCP_acknum    0x2A
//acknowledgement number
#define TCP_hdrflags  0x2E
//4-bit header len(DATA OFFSET) and flags
#define TCP_window    0x30 
//window size
#define TCP_cksum     0x32
//TCP checksum
#define TCP_urgentptr 0x34
//urgent pointer
#define TCP_data      0x36 
//option/data
//*********************************************
//* TCP Flags
//* IN flags represent incoming bits
//* OUT flags represent outgoing bits
//* 576 octets(8xbit) max datalength
//*********************************************
#define FIN_IN (packet[TCP_hdrflags+1] & 0x01)
#define SYN_IN (packet[TCP_hdrflags+1] & 0x02)
#define RST_IN (packet[TCP_hdrflags+1] & 0x04)
#define PSH_IN (packet[TCP_hdrflags+1] & 0x08)
#define ACK_IN (packet[TCP_hdrflags+1] & 0x10)
#define URG_IN (packet[TCP_hdrflags+1] & 0x20)
//corrected typeo on FIN_OUT (7 Apr 2005) was missing | before the = (also SYN_OUT,RST_OUT,PSH_OUT,ACK_OUT,URG_OUT
#define FIN_OUT packet[TCP_hdrflags+1] |= 0x01
//00000001
#define NO_FIN packet[TCP_hdrflags+1] &= 0x62
//00111110
#define SYN_OUT packet[TCP_hdrflags+1] |= 0x02
//00000010
#define NO_SYN packet[TCP_hdrflags+1] &= 0x61
//00111101
#define RST_OUT packet[TCP_hdrflags+1] |= 0x04
//00000100
#define PSH_OUT packet[TCP_hdrflags+1] |= 0x08
//00001000
#define ACK_OUT packet[TCP_hdrflags+1] |= 0x10
//00010000
#define NO_ACK packet[TCP_hdrflags+1] &= 0x47
//00101111
#define URG_OUT packet[TCP_hdrflags+1] |= 0x20
//00100000
//*******************************************
//* Port Definitions
//* This address is used by TCP for HTTP server function
//* This can be changed to any valid port number
//* as long as you modify your code to recognize
//* the new port number
//*******************************************
#define MY_PORT_ADDRESS 0x50
//80 decimal for internet
//*******************************************
//*  IP Protocol Types
//*******************************************
#define PROT_ICMP 0x01
#define PROT_TCP  0x06
#define PROT_UDP  0x11
//*******************************************
//* ICMP Header
//*******************************************
#define ICMP_type    ip_data
#define ICMP_code    ICMP_type+1
#define ICMP_cksum   ICMP_code+1
#define ICMP_id      ICMP_chsum+2
#define ICMP_seqnum  ICMP_id+2
#define ICMP_data    ICMP_seqnum+2
//******************************************
//*  UDP Header and DHCP headers
//******************************************
#define UDP_srcport 	ip_data
#define UDP_destport 	UDP_srcport + 2
#define UDP_len 	UDP_destport + 2
#define UDP_cksum 	UDP_len + 2
#define UDP_data  	UDP_cksum + 2
#define DHCP_op 	UDP_cksum + 2
#define DHCP_htype 	DHCP_op + 1
#define DHCP_hlen 	DHCP_htype+1
#define DHCP_hops 	DHCP_hlen+1
#define DHCP_xid 	DHCP_hops + 1
#define DHCP_secs 	DHCP_xid + 4
#define DHCP_flags 	DHCP_secs + 2
#define DHCP_ciaddr 	DHCP_flags + 2
#define DHCP_yiaddr 	DHCP_ciaddr + 4
#define DHCP_siaddr 	DHCP_yiaddr + 4
#define DHCP_giaddr 	DHCP_siaddr + 4
#define DHCP_chaddr 	DHCP_giaddr+4
#define DHCP_sname 	DHCP_chaddr + 16
#define DHCP_file 	DHCP_sname + 64
#define DHCP_options 	DHCP_file + 128
//DHCP states
#define DHCP_DIS 0
#define DHCP_OFF 1
#define DHCP_ACK 2
unsigned int dhcpstate = DHCP_DIS;

//****************************************
//* REALTEK CONTROL REGISTER OFFSETS
//* All offsets in Page 0 unless otherwise specified
//****************************************
#define CR 		0x00
#define PSTART 		0x01
#define PAR0 		0x01
//Page 1
#define CR9346 		0x01
//Page 3
#define PSTOP 		0x02
#define BNRY 		0x03
#define TSR 		0x04
#define TPSR 		0x04
#define TBCR0 		0x05
#define NCR 		0x05
#define TBCR1 		0x06
#define ISR 		0x07
#define CURR 		0x07
//Page 1
#define RSAR0 		0x08
#define CRDA0 		0x08
#define RSAR1 		0x09
#define CRDAL 		0x09
#define RBCR0 		0x0A
#define RBCR1 		0x0B
#define RSR 		0x0C
#define RCR 		0x0C
#define TCR	 	0x0D
#define CNTR0 		0x0D
#define DCR 		0x0E
#define CNTR1 		0x0E
#define IMR 		0x0F
#define CNTR2 		0x0F
#define RDMAPORT 	0x10
#define RSTPORT  	0x18

//************************************************************
//* RTL8019AS INITIAL REGISTER VALUES
//************************************************************
#define rcrval 	0x04
#define tcrval 	0x00
#define dcrval 	0x58
//was 0x48
#define imrval 	0x11
//PRX and OVW interrupt enabled
#define txstart 0x40
#define rxstart 0x46
#define rxstop 	0x60

//*************************************************************
//* RTL8019AS DATA/ADDRESS PIN DEFINITION
//*************************************************************
#define rtladdr PORTB
#define rtldata PORTC
#define tortl 	DDRC = 0xFF
#define fromrtl DDRC = 0x00

//*************************************************************
//* RTL8019AS 9346 EEPROM PIN DEFINITIONS
//*************************************************************
#define EESK 0x08
//PORTD3 00001000
#define EEDI 0x10 
//PORTD4 00010000
#define EEDO 0x20
//PORTD5 00100000

//*************************************************************
//* RTL8019AS PIN DEFINITIONS
//**************************************************************
#define ior_pin 0x40
//PORTD6 01000000
#define iow_pin 0x80
//PORTD7 10000000
#define rst_pin 0x80
//PORTB7 10000000
#define INT0_pin 0x04 
//PORTD2 00000100

//*************************************************************
//* RTL8019AS ISR REGISTER DEFINITIONS
//*************************************************************
#define RST 0x80
//10000000
#define RDC 0x40
//01000000
#define OVW 0x10
//00010000
#define PRX 0x01
//00000001

//*************************************************************
//* AVR RAM Definitions
//*************************************************************
//unsigned char aux_data[400]; //tcp received data area (200 char)
unsigned char req_ip[4];
unsigned int DHCP_wait = 0;
int waitcount = 800;
unsigned char *addr,flags,last_line;
unsigned char byte_read,data_H,data_L;
unsigned char resend;
unsigned int i,t,txlen,rxlen,chksum16,hdrlen,tcplen,tcpdatalen_in,dhcpoptlen;
unsigned int tcpdatalen_out,ISN,portaddr,ip_packet_len;
unsigned long ic_chksum,hdr_chksum,my_seqnum,prev_seqnum,client_seqnum,incoming_ack,expected_ack;

//**********************************************************
//* Flags
//**********************************************************
#define synflag 	0x01
//00000001
#define finflag 	0x02
//00000010
#define synflag_bit 	flags & synflag
#define finflag_bit	flags & finflag
//either we are sending an ack or sending data
unsigned int ackflag = 0;
// for TCP close operations
unsigned int closeflag = 0;
#define iorwport 	PORTD
#define eeprom 		PORTD
#define resetport 	PORTB

//*******************************************************
//* RTL8019AS PIN MACROS
//*******************************************************
#define set_ior_pin 	iorwport |= ior_pin
#define clr_ior_pin 	iorwport &= ~ior_pin
#define set_iow_pin 	iorwport |= iow_pin
#define clr_iow_pin 	iorwport &= ~iow_pin
#define set_rst_pin 	resetport |= rst_pin
#define clr_rst_pin 	resetport &= ~rst_pin

#define clr_EEDO 	eeprom &= ~EEDO
#define set_EEDO 	eeprom |= EEDO
#define clr_synflag 	flags &= ~synflag
#define set_synflag 	flags |= synflag
#define clr_finflag 	flags &= ~finflag
#define set_finflag 	flags |= finflag

#define set_packet32(d,s) packet[d] = make8(s,3); \
	packet[d+1] = make8(s,2); \
	packet[d+2] = make8(s,1); \
	packet[d+3] = make8(s,0); 

//converts decimal into words (8bit0
#define make8(var,offset) (var >> (offset*8)) & 0xFF

//joins two 8bit binary into a 16bit binary and converts it to decimal
#define make16(varhigh,varlow) ((varhigh & 0xFF)*0x100) + (varlow & 0xFF)
                                            

//joins 4 8 bit numbers to form a 32bit number
#define make32(var1,var2,var3,var4) ((unsigned long)var1<<24)+((unsigned long)var2<<16)+ ((unsigned long)var3<<8)+((unsigned long)var4)
	
//*******************************************************
//* timer interrupt
//*******************************************************
interrupt[TIM0_COMP] void t0_cmp(void)
{
	waitcount--;
	if(waitcount<0)
	{
		waitcount = 9000;
	}
}

//******************************************************
//* Application Code
//* Your application code goes here.
//* This particular code echoes the incomeing Telnet data to the LCD
//******************************************************
void http_server()
{
	/* Check for GET */
	if(http_state = 0 && ( packet[TCP_data] != ISO_G || packet[TCP_data+1] != ISO_E || packet[TCP_data+2] != ISO_T || packet[TCP_data+3] != ISO_space))
	{
		//if it not a get get we close the connection
		tcp_close();
	}
	else
	{
		http_state = 1;
		//get the sample
			//The sleep statement lowers digital noise
			//and starts the A/D conversion
			#asm
				sleep
		#endasm
		gettemp();
		//send the http
		//check which file client wants
		//set the dataptr to teh file
		if(sendflag == 0 && pageendflag == 0)
		{
			if(rollback)
			{
				//start from beginning again
				dex=0;
				pos=0;
			}
			sendflag=1;
			pack_html(INDEX,dex,pos);
			counter += tcpdatalen_out;
			if(pageendflag == 1)
				set_finflag;
			send_tcp_packet();
			rollback=0;
		}
		// the send operation has been completed
		else if(pageendflag == 1)
		{
			pageendflag = 0;
			dex = 0;
			pos = 0;
			counter = 0;
			rollback = 0;
			http_state = 0;
		}
	}
}

//********************************************************
//* Get Temperature
//*******************************************************
void gettemp()
{
	voltage = (float)Ain;
	voltage = (voltage/256)*2.6; //(fraction of full scale)*Aref
	voltage = voltage/0.02;
	ftoa(voltage,3,temp);
}
interrupt [ADC_INT] void adc_done(void)
{
	Ain = ADCH;
}

//*******************************************************
//* Perform ARP Response
//* This routine supplies a requesting computer with the
//* Ethernet module's MAC (hardware) address
//*******************************************************
void arp()
{
	//start the NIC
	write_rtl(CR,0x22);
	
	//load beginning page for transmit buffer
	write_rtl(TPSR,txstart);
	
	//set start address for remote DMA operation
	write_rtl(RSAR0,0x00);
	write_rtl(RSAR1,0x40);
	
	//clear the interrupts
	write_rtl(ISR,0xFF);
	
	//load data byte count for remote DMA
	write_rtl(RBCR0,0x3C);
	write_rtl(RBCR1,0x00);
	
	//do remote write operation
	write_rtl(CR,0x12);
	
	//write destination MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,packet[enetpacketSrc0+i]);
		
	//write source MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,MYMAC[i]);
		
	//write typelen hwtype prtype hwlen prlen op:
	addr = &packet[enetpacketType0];
	packet[arp_op+1] = 0x02;
	for(i=0;i<10;++i)
		write_rtl(RDMAPORT,*addr++);
	
	//write ethernet module MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,MYMAC[i]);
	
	//write ethernet module IP address
	for(i=0;i<4;++i)
		write_rtl(RDMAPORT,MYIP[i]);
	
	//write remote MAC address
	for(i=0;i<6;++i)
		write_rtl(RDMAPORT,packet[enetpacketSrc0+i]);
		
	//write remote IP address
	for(i=0;i<4;++i)
		write_rtl(RDMAPORT,packet[arp_sipaddr+i]);
		
	//write some pad characeters to fill out the packet to 
	//the minimum length
	for(i=0;i<0x12;++i)
		write_rtl(RDMAPORT,0x00);
		
	//make sure the DMA operation has successfully completed
	byte_read=0;
	while(!(byte_read & RDC))
		read_rtl(ISR);
	
	//load number of bytes to be transmitted
	write_rtl(TBCR0,0x3C);
	write_rtl(TBCR1,0x00);
	
	//send the contents of the transmit buffer onto the network
	write_rtl(CR,0x24);
}

//********************************************************
//* Perform ICMP Function
//* This routine responds to a ping
//********************************************************
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
	((packet[ip_vers_len] & 0x0F) * 4);
	addr = &packet[ICMP_type];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
	packet[ICMP_cksum] = make8(chksum16,1);
	packet[ICMP_cksum+1] = make8(chksum16,0);
	
	//send the ICMP packet along on its way
	echo_packet();
}

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
	ip_packet_len = 20+make16(packet[UDP_len],packet[UDP_len+1]);
	
	packet[ip_pktlen] = make8(ip_packet_len,1);
	packet[ip_pktlen+1] = make8(ip_packet_len,0);
	packet[ip_proto] = PROT_UDP;
	
	//calculate the IP header checksum
	packet[ip_hdr_cksum] = 0x00;
	packet[ip_hdr_cksum+1] = 0x00;
	hdr_chksum = 0;
	chksum16 = 0;
	hdrlen = (packet[ip_vers_len] & 0x0F)*4;
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
	//rich and I stopped debugging here (aka, we stopped reading)	
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

//******************************************************
//* DHCP for obtaining IP from router port 67~68 using UDP
//******************************************************
void dhcp()
{
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
 //p43
//*****************************************************
//* TCP Function
//* This function uses TCP protocol to interface with the browsser
//* using well known port 80.  The application function is called with
//* ever incoming character.
//******************************************************
void tcp()
{
	//assemble the destination port address (my) from from the incoming packet
	portaddr = make16(packet[TCP_destport],packet[TCP_destport+1]);
	//calculate the length of teh data coming in with the packet
	//incoming tcp header length
	tcplen = ip_packet_len - ((packet[ip_vers_len] & 0x0F) * 4);
	//incoming data length =
	tcpdatalen_in = (make16(packet[ip_pktlen],packet[ip_pktlen+1])) - \
	((packet[ip_vers_len] & 0x0F) * 4)-(((packet[TCP_hdrflags] & 0xF0) >> 4) * 4);
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
				dex = 0;
				pos = 0;
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
				//many missing lines to add 7 Apr 2005
				packet[TCP_srcport]=packet[TCP_destport];
				packet[TCP_destport]=data_L;
				
				data_L=packet[TCP_srcport+1];
				//end of mising lines
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
				((packet[ip_vers_len]&0x0F)*4);
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

/*------------TCP CLOSE CONNECTION FUNCTION ----*/
void tcp_close()
{
	set_finflag;
	tcpdatalen_out=0;
	send_tcp_packet();
	closeflag=closeflag+1;
}

//*****************************************************
//* Assemble the Acknowledgement
//* This function assembles the acknowledgement to send to
//* the client by adding the received data count to the 
//* client's incoming sequence number
//******************************************************
void assemble_ack()
{
	client_seqnum=make32(packet[TCP_seqnum],packet[TCP_seqnum+1], packet[TCP_seqnum+2], packet[TCP_seqnum+3]);
	client_seqnum += tcpdatalen_in;
	set_packet32(TCP_acknum,client_seqnum);
}

//******************************************************
//* Send TCP Packet
//* This routine assembles and sends a complete TCP/IP packet
//* 40 bytes of IP and TCP header data is assumed (no options)
//******************************************************
void send_tcp_packet()
{
	//count IP and TCP header bytes  Total = 40 bytes
	if(tcpdatalen_out == 0)
	{
		tcpdatalen_out=14;
		for(i=0;i<14;i++)
			packet[TCP_data+i]=0;
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
	tcplen = ip_packet_len - ((packet[ip_vers_len]& 0x0F)*4);
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
void pack_html(unsigned int page, unsigned int x, unsigned int y)
{
	if(page == INDEX)
	{
		page_size = size_index;
		//get the required page
		for(i=0;i<size_index;i++)
			req_page[i]=index[i];
	}
	tcpdatalen_out = 0;
	i=0;
	t=0;
	while(x<page_size)
	{
		while(*(req_page[x]+y)!=0x00 && i<500)
		{
			strncpyf(&packet[TCP_data+i],req_page[x]+y,1);
			y++;
			if(packet[TCP_data+i] == 0x27)
			{
				packet[TCP_data+i] = 0x22;
				x++;
				y = 0;
			}
			if(packet[TCP_data+i] == 0x25)
			{
				//sprintf(temp,"%d",temperature);
				//if there is enough space to send the temperature
				if((i+5)<500)
				{
					while(t<5)
					{
						packet[TCP_data+i] = temp[t];
						temp[t] = 0;
						i++;
						t++;
						tcpdatalen_out = tcpdatalen_out+1;
					}
					i--;
					x++;
					y=0;
					tcpdatalen_out = tcpdatalen_out-1;
				}
				else
				{
					i=500;//exit the loop
					tcpdatalen_out=tcpdatalen_out-1;
				}
			}
			if(rollback && counter>=rollback)
				rollback=rollback+1;
			else
			{
				i++;
				tcpdatalen_out++;
			}
		}
		if(i<500)
		{
			x++;
			dex = x;
			y = 0;
		}
		//max size of packet reached
		else
		{
			//save for sending next packet
			dex = x;
			pos = y;
			//get out of loop
			x = page_size+1;
		}
	}
	if(dex >= page_size)
		pageendflag = 1;
}

//*******************************************************
//* WRite to NIC Control Register
//*******************************************************
void write_rtl(unsigned char regaddr, unsigned char regdata)
{
	//write the regaddr into PORTB
	rtladdr = regaddr;
	tortl;
	//write data into PORTC
	rtldata = regdata;
	#asm
		nop
	#endasm
	//toggle write pin
	clr_iow_pin;
	#asm
		nop
		nop
		nop
	#endasm
	set_iow_pin;
	#asm
		nop
	#endasm
	//set data port back to input
	fromrtl;
	PORTC = 0xFF;
}

//*******************************************************
//* Read From NIC Control Register
//*******************************************************
void read_rtl(unsigned char regaddr)
{
	fromrtl;
	PORTC = 0xFF;
	rtladdr = regaddr;
	clr_ior_pin;
	#asm
		nop
	#endasm
	#asm
		nop
		nop
		nop
	#endasm
	byte_read = PINC;
	set_ior_pin;
	#asm
		nop
	#endasm
}

//******************************************************
//* Handle Receive Ring Buffer OVerrun
//* No packets are recovered
//*******************************************************
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

//******************************************************
//* Echo Packet Function
//* This routine does not modify the incoming packet size and
//* thus echoes the original packet structure
//********************************************************
void echo_packet()
{
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

//*****************************************************
//* Get A Packet From the Ring
//* This routine removes data packet from teh receive buffer
//* ring
//*******************************************************
void get_packet()
{
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
		hdrlen = (packet[ip_vers_len] & 0x0F) * 4;
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

//********************************************************
//* SETIPADDRS
//* This function builds the IP header
//*********************************************************
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
	hdrlen = (packet[ip_vers_len] & 0x0F) * 4;
	addr = &packet[ip_vers_len];
	cksum();
	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000)>>16));
	packet[ip_hdr_cksum] = make8(chksum16,1);
	packet[ip_hdr_cksum+1] = make8(chksum16,0);
}

//**********************************************************
//*  CHECKSUM CALCULATION ROUTINE
//* just add 16 bits to hdrchksum until you reach the end of hdrlen
//*********************************************************
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

//**********************************************************
//* Initialize the RTL8019AS
//************************************************************
void init_RTL8019AS()
{
	fromrtl;	//PORTC data lines = input
	PORTC = 0xFF;
	DDRB = 0xFF;
	rtladdr = 0x00; //clear address lines
	DDRA = 0x00; 	//PORTA is an input
	//DDRA = 0xFF;
	DDRD = 0xE0;	//setup IOW, IOR, EEPROM,RXD,TXD,CTS
	PORTD = 0x1F; 	//enable pullups on input pins
	clr_EEDO;
	set_iow_pin;	//disable IOW
	set_ior_pin; 	//disable IOR
	set_rst_pin;	//put NIC in reset
	delay_ms(2);	//delay at least 1.6 ms
	clr_rst_pin;	//disable reset line
	
	read_rtl(RSTPORT);	//read contents of reset port
	write_rtl(RSTPORT,byte_read); //do soft reset
	delay_ms(20);	//give it time
	read_rtl(ISR);	//check for good soft reset
	
	if(!(byte_read & RST))
	{
		//for(i=0;i<sizeof(msg_initfail)-1;++i)
		//{
			//delay_ms1(1);
			//lcd_send_byte(1,msg_initfail[i]);
		//}
	}
	write_rtl(CR,0x21);	//stop the NIC,abort DMA,page 0
	delay_ms(2);		//make sure nothing is coming in or going out
	write_rtl(DCR,dcrval);	//0x58
	write_rtl(RBCR0,0x00);
	write_rtl(RBCR1,0x00);
	write_rtl(RCR,0x04);
	write_rtl(TPSR,txstart);
	write_rtl(TCR,0x02);
	write_rtl(PSTART,rxstart);
	write_rtl(BNRY,rxstart);
	write_rtl(PSTOP,rxstop);
	write_rtl(CR,0x61);
	delay_ms(2);
	write_rtl(CURR,rxstart);
	for(i=0;i<6;++i)
		write_rtl(PAR0+i,MYMAC[i]);
		
	write_rtl(CR,0x21);
	write_rtl(DCR,dcrval);
	write_rtl(CR,0x22);
	write_rtl(ISR,0xFF);
	write_rtl(IMR,imrval);
	write_rtl(TCR,tcrval);
	write_rtl(CR,0x22);
}

//**********************************************************
//* Main
//**********************************************************
void main(void)
{
	init_RTL8019AS();
	//setup timer 0
	TIMSK = 2;
	OCR0 = 200;
	TCCR0 = 0b00001011;
	ADMUX = 0b11100000; //internal 2.56 voltage ref with ext cap at AREF pin
	
	//enable ADC and set prescaler to 1/64*16MHz = 125,000
	//and set int enable
	ADCSR = 0x80 + 0x07 + 0x08;
	MCUCR = 0b10010000; //enable sleep and choose ADC mode
	#asm
		sei
	#endasm
	
	clr_synflag;
	clr_finflag;
	delay_ms(5000); //wait for boot up (5 seconds)
	
	//ob-mstain an ip address
	dhcp();
	
	//************************************************
	//* Look for a packet in the receive buffer ring
	//************************************************
	while(1)
	{
		//start the NIC
		write_rtl(CR,0x22);
		write_rtl(ISR,0x7F);
		
		//wait for a good packet
		read_rtl(ISR);
		while(!(byte_read & 1))
		{
			//PORTA.0 = 1;
			//resend previous data
			if(waitcount == 0)
			{
				if(DHCP_wait == 1)
				{
					dhcpstate = DHCP_DIS;
					dhcp();
				}
				if(DHCP_wait==2)
				{
					dhcpstate = DHCP_OFF;
					dhcp();
				}
			}
			read_rtl(ISR);
		}
		//PORTA.0 = 0;
		
		//read the interrupt status register
		read_rtl(ISR);
		
		//if the receive buffer has been overrun
		if(byte_read & OVW)
			overrun();
		
		//if the receive buffer holds a good packet
		if(byte_read & PRX)
		get_packet();
		//make sure the receive buffer ring is empty
		//if BNRY = CURR, the buffer is empty
		read_rtl(BNRY);
		data_L = byte_read;
		write_rtl(CR,0x62);
		read_rtl(CURR);
		data_H = byte_read;
		
		write_rtl(CR,0x22);
		//buffer is not empty ..get next packet
		if(data_L!=data_H)
			get_packet();
			
		//reset the interrupt bits
		write_rtl(ISR,0xFF);
	}
}
