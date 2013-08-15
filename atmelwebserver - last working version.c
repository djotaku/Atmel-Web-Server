/*Project:  AVR Web Server
by: Eric Mesa and Richard West
based upon version 0.93 beta 
by: Jeremy

Current working version 0.96

Version 0.96 - The Compliance Wars - 13 Apr 2005
The goal of version 0.96 is to shore up compliance
issues with the original code.  It is already 
functional with all broswers, but we want to 
allow error checking, better HTML parsing, and 
generally a heckuva lot more compliant versions
of the code.

1) Added HTTP errors if the wrong page is asked for
2) Fixed TCP_data variable because Jeremy had been
pointing into the options and padding area


Version 0.95 - The Modular Version - 13 Apr 2005
The goal of version 0.95 is to modularize the functions 
by moving them over to their own library and header files.  
This enables a code that is much easier to read as well
as easier to maintain.  This, and the subsquent optimization 
of the code, is our greatest change to the code

1) Moved arp-related functions over to their own library/header files
2) Moved icmp-related functions over to their own library/header files
3) Moved udp-related functions over to their own library/header files
4) Moved dhcp-related functions over to their own library/header files
5) Moved tcp-related functions over to their own library/header files
6) Moved ack-related functions over to their own library/header files
7) Moved tcp_send-related functions over to their own library/header files
8) Moved nic communication-related functions over to their own library/header files
9) Moved ring buffer related functions over to their own library/header files
10) Moved packet echoing related functions over to their own library/header files
11) Moved ring related functions over to their own library/header files
12) Moved IP address related functions over to their own library/header files
13) Moved Checksum related functions over to their own library/header files
14) Moved RTL8019AS initialization related functions over to their own library/header files

Also, changed HTTP to HTTP1.0 from 1.1 to allow the code to be retrieved multiple times.
Prior to this the server could only be connected to once per hard reset.


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
unsigned int page_size;                                                                                           
flash unsigned char *index = "HTTP/1.0 200 OK\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>index</title></head><body>index<br /><a href=\"about.html\">about</a></body></html>\r\n\r\n";
flash unsigned char *about = "HTTP/1.0 200 OK\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>about</title></head><body>about<br /><a href=\"index.html\">index</a></body></html>\r\n\r\n";
// need to add favicon content
flash unsigned char *favicon = "HTTP/1.0 200 OK\r\nServer: KickAss Server\r\nContent-type: image/x-icon\r\n\r\n";
flash unsigned char *error400 = "HTTP/1.0 400 Bad Request\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>error400</title></head><body>Error400: Opps, you broke it (Bad Request).</body></html>\r\n\r\n";
flash unsigned char *error404 = "HTTP/1.0 404 Not Found\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>error404</title></head><body>Error404: Opps, you broke it (Not Found).</body></html>\r\n\r\n";
flash unsigned char *error501 = "HTTP/1.0 501 Not Implemented\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>error501</title></head><body>Error501: Opps, you broke it (Not Implemented).</body></html>\r\n\r\n";

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
#define INDEX 0
unsigned int dex,pos = 0;
unsigned int rollback = 0;

//added for debugging
signed int counter = 0;


//end of pack html function
void send_tcp_packet(void);

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
#define TCP_options      0x36 
//option/data
#define TCP_data      0x42
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
//unsigned int i
unsigned int t,txlen,rxlen,chksum16,hdrlen,tcplen,tcpdatalen_in,dhcpoptlen;
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
	

//includes involving header and library files
#include "arp.h"
#include "icmp.h"
#include "udp.h"
#include "dhcp.h"
#include "tcp.h"
#include "ack.h"
#include "tcpsend.h"
#include "nic.h"
#include "ringbuff.h"
#include "echo.h"
#include "ring.h"
#include "ipad.h"

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

unsigned char flash *req_page;

void http_server()
{	
        if(http_state == 0)
	{
	        http_state = 1;
	        req_page = parse_http();
	}
	
	if(sendflag == 0 && pageendflag == 0)
	{
		/*if(rollback)
		{
			//start from beginning again
			counter=0;
		}*/
		sendflag=1;

		page_size = strlenf(req_page);
		counter += pack_html(req_page, counter);
                if (counter >= page_size)
                {
                        tcpdatalen_out+=12;//figure this out
                        pageendflag = 1;
                        set_finflag;
                }
		send_tcp_packet();
		rollback=0;
	}
	// the send operation has been completed
	else if(pageendflag == 1)
	{
		pageendflag = 0;
		counter = 0;
		rollback = 0;
		http_state = 0;
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
	#asm("sei")
	
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
