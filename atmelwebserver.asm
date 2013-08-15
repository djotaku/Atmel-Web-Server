;CodeVisionAVR C Compiler V1.23.8d Standard
;(C) Copyright 1998-2003 HP InfoTech s.r.l.
;http://www.hpinfotech.ro
;e-mail:office@hpinfotech.ro

;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 16.000000 MHz
;Memory model        : Small
;Optimize for        : Size
;(s)printf features  : int
;(s)scanf features   : int, width
;External SRAM size  : 0
;Data Stack size     : 512
;Promote char to int : No
;char is unsigned    : Yes
;8 bit enums         : No
;Enhanced core instructions    : On
;Automatic register allocation : On
;Use AVR Studio Terminal I/O   : No

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x80
	.EQU __sm_mask=0x30
	.EQU __sm_powerdown=0x20

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	CLR  R30
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@2,@0+@1
	.ENDM

	.MACRO __GETWRMN
	LDS  R@2,@0+@1
	LDS  R@3,@0+@1+1
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOV  R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOV  R30,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "atmelwebserver.vec"
	.INCLUDE "atmelwebserver.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	LDI  R31,0x10
	OUT  WDTCR,R31

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
	SBIW R30,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R24,Z+
	LPM  R25,Z+
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x260
;       1 /*Project:  AVR Web Server
;       2 by: Eric Mesa and Richard West
;       3 based upon version 0.93 beta 
;       4 by: Jeremy                                                             
;       5            
;       6 **********************************************************************
;       7 * DESCRIPTION
;       8 **********************************************************************
;       9 This project is a webserver running on an Atmel Mega32.  It supports
;      10 ping, dhcp, 
;      11 
;      12 **********************************************************************
;      13 * CHANGELOG
;      14 ***********************************************************************
;      15 Current working version 0.96
;      16 
;      17 Version 0.96 - The Compliance Wars - 13 Apr 2005
;      18 The goal of version 0.96 is to shore up compliance
;      19 issues with the original code.  It is already 
;      20 functional with all broswers, but we want to 
;      21 allow error checking, better HTML parsing, and 
;      22 generally a heckuva lot more compliant versions
;      23 of the code.
;      24 
;      25 1) Added HTTP errors if the wrong page is asked for
;      26 2) Fixed TCP_data variable because Jeremy had been
;      27 pointing into the options and padding area
;      28 3) Added favicon.ico to be compliant with requests for
;      29 page icons - lack of the icon had prevented it from following links
;      30 (at least in Firefox)
;      31 **********************************************************************
;      32 
;      33 **********************************************************************
;      34 Version 0.95 - The Modular Version - 13 Apr 2005
;      35 The goal of version 0.95 is to modularize the functions 
;      36 by moving them over to their own library and header files.  
;      37 This enables a code that is much easier to read as well
;      38 as easier to maintain.  This, and the subsquent optimization 
;      39 of the code, is our greatest change to the code
;      40 
;      41 1) Moved arp-related functions over to their own library/header files
;      42 2) Moved icmp-related functions over to their own library/header files
;      43 3) Moved udp-related functions over to their own library/header files
;      44 4) Moved dhcp-related functions over to their own library/header files
;      45 5) Moved tcp-related functions over to their own library/header files
;      46 6) Moved ack-related functions over to their own library/header files
;      47 7) Moved tcp_send-related functions over to their own library/header 
;      48 files
;      49 8) Moved nic communication-related functions over to their own 
;      50 library/header files
;      51 9) Moved ring buffer related functions over to their own library/header f
;      52 iles
;      53 10) Moved packet echoing related functions over to their own library/
;      54 header files
;      55 11) Moved ring related functions over to their own library/header files
;      56 12) Moved IP address related functions over to their own library/header 
;      57 files
;      58 13) Moved Checksum related functions over to their own library/header 
;      59 files
;      60 14) Moved RTL8019AS initialization related functions over to their own 
;      61 library/header files
;      62 
;      63 Also, changed HTTP to HTTP1.0 from 1.1 to allow the code to be 
;      64 retrieved multiple times. Prior to this the server could only be 
;      65 connected to once per hard reset.
;      66 **********************************************************************
;      67 
;      68 **********************************************************************
;      69 Version 0.94.1 9 Apr 2005
;      70 1) Eliminated minor redundancies (eg x++ instead of x=x+1)
;      71 
;      72 
;      73 Version 0.94 9 Apr 2005
;      74 1) Fixed browser compatibility problems by correctly padding the html 
;      75 header.  This involved adding 12 spaces at the front and a \r\n at the
;      76  end
;      77 **********************************************************************
;      78 
;      79 **********************************************************************
;      80 Version 0.93.1 6 April 2005
;      81 1) Fixed typoes in copying from PDF
;      82 
;      83 
;      84 Version 0.93 4 March 2004
;      85 1) Added Checksum for incoming TCP packets (fixed)
;      86 2) Added TCP data sending function (only sends 1 packet at a time Window 
;      87 functionality should be done)
;      88 3)Increased packet size from 96 - 300 (since we can have 576 max 
;      89 packet length)
;      90 4)Added HTTP functions and HTTP sample
;      91 5)Added DHCP functionality
;      92 6)Need to tweak the TCP_close() functionality
;      93 7) Note: The webbrowesers use the RST fucntion whenever it is closed.  
;      94 Don't think will need the TCP_close()
;      95 *****TESTING*****
;      96 6) DHCP WORKING!
;      97 7) IMCP working!!
;      98 7) HTTP up!!
;      99 8) TCP resend lost data working (tested)
;     100 8) (fixed) didn't do the setting of packets properly only set the 1st 
;     101 byte must do all bytes
;     102 **********************************************************************
;     103 */
;     104 
;     105 //**********************************************************************
;     106 //*
;     107 //*  END OF CHANGELOG, BEGIN CODE
;     108 //*
;     109 //**********************************************************************
;     110 
;     111 //*******************************************
;     112 //*            PORT MAP
;     113 //*******************************************
;     114 //PORT C = rtldata - data bus RCTL8019 and AVR
;     115 // 0 SD0
;     116 // 1 SD1
;     117 // 2 SD2
;     118 // 3 SD3
;     119 // 4 SD4
;     120 // 5 SD5
;     121 // 6 SD6
;     122 // 7 SD7
;     123 // PORT B
;     124 // 0 SA0
;     125 // 1 SA1
;     126 // 2 SA2
;     127 // 3 SA3
;     128 // 4 SA4
;     129 // 5
;     130 // 6
;     131 // 7 make this the rst_pin
;     132 // PORT A
;     133 // temperature sensor port
;     134 
;     135 //PORT D
;     136 //0 RXD
;     137 //1 TXD 
;     138 //2 INT0 --> for EEPROM only
;     139 // 3 EESK
;     140 //4 EEDI
;     141 //5 EEDO
;     142 //6 ior_pin
;     143 //7 iow_pin
;     144 
;     145 #include<mega32.h>
;     146 #include<string.h>
;     147 #include<stdio.h>
;     148 #include<delay.h>
;     149 #include<stdlib.h>
;     150 
;     151 #define ISO_G 0x47
;     152 #define ISO_E 0x45
;     153 #define ISO_T 0x54
;     154 #define ISO_slash 0x2f
;     155 #define ISO_c 0x63
;     156 #define ISO_g 0x67
;     157 #define ISO_i 0x69
;     158 #define ISO_space 0x20
;     159 #define ISO_nl 0x0a
;     160 #define ISO_cr 0x0d
;     161 #define ISO_a 0x61
;     162 #define ISO_t 0x74
;     163 #define ISO_hash 0x23
;     164 #define ISO_period 0x2e
;     165 
;     166 //define the connection structure for a single TCP socket (multiple connections)
;     167 unsigned int page_size;                                                                                           
;     168 
;     169 //**********************************************************************
;     170 //* Stored Web Pages
;     171 //**********************************************************************
;     172 
;     173 flash unsigned char *index = "HTTP/1.0 200 OK\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>index</title><link rel=\"shortcut icon\" href=\"/favicon.ico\" type=\"image/x-icon\" ></head><body><h1>Atmel Mega32 Webserver</h1><br /><a href=\"about.html\">by Eric Mesa and Richard West</a></h1><br>based on source code by Jeremy Tan<br><h2>Sound Bite</h2><br>Our project is a fully web-standards compliant webserver running on an Atmel Mega32.<h2>Summary</h2>Using code from graduate student Jeremy Tzeming Tan, we improved upon his webserver source code by making it more fully compliant with Internet Standards.  Additionally, we modularized his code for easer maintenance, documentation, and implementation.<a href=\"index2.html\">next</a></body></html>\r\n\r\n";
_index:
	.BYTE 0x2
;     174 flash unsigned char *index2 = "HTTP/1.0 200 OK\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>index2</title><link rel=\"shortcut icon\" href=\"/favicon.ico\" type=\"image/x-icon\" ></head><body>By splitting up the code, instead of keeping all 2000 lines in one file, someone who wishes to maintain a specific function wouldn't have to hunt for it throughout the file.  Documentation of each of the files is made easier by splitting them up because a lot more documentation can exist at the toip of each of the files.  FInally, we have , therefore, built up a library of Internet protocols.  Someone else may take our library files and implement only those protocols which are important to that specific project instead of having to implement a full-blown webserver.</body></html>\r\n\r\n";
_index2:
	.BYTE 0x2
;     175 
;     176 flash unsigned char *about = "HTTP/1.0 200 OK\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>about</title><link rel=\"shortcut icon\" href=\"/favicon.ico\" type=\"image/x-icon\" ></head><body>Eric and Richard, also known as the Kings of Atmel, have taken some time out of their busy schedule to work on this little project.<br /><a href=\"index.html\">index</a></body></html>\r\n\r\n";
_about:
	.BYTE 0x2
;     177 // favicon is parsed and sent correctly, but it always appears as a white icon.
;     178 // it is a legitimate ico file since none of the browsers complain when it is received
;     179 flash unsigned char favicon[256+71-10] = {'H','T','T','P','/','1','.','0',' ','2','0','0',' ','O','K','\r','\n','S','e','r','v','e','r',':',' ','K','i','c','k','A','s','s',' ','S','e','r','v','e','r','\r','\n','C','o','n','t','e','n','t','-','t','y','p','e',':',' ','i','m','a','g','e','/','x','-','i','c','o','n','\r','\n','\r','\n',

	.CSEG
;     180 0x00,0x00,0x01,0x00,0x01,0x00,0x10,0x10,0x02,0x00,0x01,0x00,0x01,0x00,0xb0,0x00,
;     181 0x00,0x00,0x16,0x00,0x00,0x00,0x28,0x00,0x00,0x00,0x10,0x00,0x00,0x00,0x20,0x00,
;     182 0x00,0x00,0x01,0x00,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     183 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x6b,0x3C,
;     184 0x6A,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     185 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     186 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     187 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     188 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     189 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     190 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     191 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     192 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     193 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     194 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
;     195 0x00,0x00,0x00,0x00,0x00,0x00};
;     196 
;     197 flash unsigned char *error400 = "HTTP/1.0 400 Bad Request\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>error400</title></head><body>Error400: Opps, you broke it (Bad Request).</body></html>\r\n\r\n";

	.DSEG
_error400:
	.BYTE 0x2
;     198 flash unsigned char *error404 = "HTTP/1.0 404 Not Found\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>error404</title></head><body>Error404: Opps, you broke it (Not Found).</body></html>\r\n\r\n";
_error404:
	.BYTE 0x2
;     199 flash unsigned char *error501 = "HTTP/1.0 501 Not Implemented\r\nServer: KickAss Server\r\nContent-type: text/html\r\n\r\n<html><head><meta HTTP-EQUIV=\"content-type\" CONTENT=\"text/html; charset=iso-8859-1\"><title>error501</title></head><body>Error501: Opps, you broke it (Not Implemented).</body></html>\r\n\r\n";
_error501:
	.BYTE 0x2
;     200 
;     201 //**********************************************************************
;     202 //* END STORED WEB PAGES
;     203 //**********************************************************************
;     204 
;     205 unsigned int http_state = 0;
;     206 unsigned int sendflag = 0;
;     207 unsigned int pageendflag = 0;
;     208 
;     209 //*****************************
;     210 //*    FUNCTION PROTOTYPES
;     211 //*****************************
;     212 void http_server(void);
;     213 void tcp(void);
;     214 void tcp_close(void);
;     215 void assemble_ack(void);
;     216 void write_rtl(unsigned char regaddr, unsigned char regdata);
;     217 void read_rtl(unsigned char regaddr);
;     218 void get_packet(void);
;     219 void setipaddrs(void);
;     220 void cksum(void);
;     221 void echo_packet(void);
;     222 #define INDEX 0
;     223 unsigned int rollback = 0;
;     224 signed int counter = 0;
_counter:
	.BYTE 0x2
;     225 
;     226 
;     227 //end of pack html function
;     228 void send_tcp_packet(void);
;     229 
;     230 void udp(void);
;     231 void udp_send(void);
;     232 //DHCP FUCNTIONS
;     233 void dhcp(void);
;     234 void dhcp_setip(void);
;     235 
;     236 //*******************************************
;     237 //*     IP ADDRESS DEFINITION
;     238 //* This is the Ethernet Module IP address
;     239 //* You may change this to any valid address
;     240 //*******************************************
;     241 unsigned char MYIP[4] = {192,168,2,255};
_MYIP:
	.BYTE 0x4
;     242 unsigned char client[4];
_client:
	.BYTE 0x4
;     243 unsigned char serverid[4];
_serverid:
	.BYTE 0x4
;     244 //*****************************************
;     245 //*    HARDWARE (MAC) ADDRESS DEFINITION
;     246 //* This is the Ethernet Module hardware address
;     247 //* You may change this to any valid address
;     248 //*****************************************
;     249 char MYMAC[6]={'J','e','s','t','e','r'};
_MYMAC:
	.BYTE 0x6
;     250 //*****************************************
;     251 //*  Recieve Ring Buffer Header Layout
;     252 //* This is the 4-byte header that resides in front of the
;     253 //* data packet in the receive buffer
;     254 //******************************************
;     255 unsigned char pageheader[4];
_pageheader:
	.BYTE 0x4
;     256 #define enetpacketstatus 0x00
;     257 #define nextblock_ptr 	 0x01
;     258 #define enetpacketLenL 	 0x02
;     259 #define enetpacketLenH 	 0x03
;     260 //*******************************************
;     261 //*    Ethernet Header Layout
;     262 //*******************************************
;     263 unsigned char packet[700]; //700 bytes of packet space
_packet:
	.BYTE 0x2BC
;     264 #define enetpacketDest0 0x00 
;     265 //destination mac address
;     266 #define enetpacketDest1 0x01
;     267 #define enetpacketDest2 0x02
;     268 #define enetpacketDest3 0x03
;     269 #define enetpacketDest4 0x04
;     270 #define enetpacketDest5 0x05
;     271 #define enetpacketSrc0  0x06
;     272 //source mac address
;     273 #define enetpacketSrc1  0x07
;     274 #define enetpacketSrc2  0x08
;     275 #define enetpacketSrc3  0x09
;     276 #define enetpacketSrc4  0x0A
;     277 #define enetpacketSrc5  0x0B
;     278 #define enetpacketType0 0x0C
;     279 //type/length field
;     280 #define enetpacketType1 0x0D
;     281 #define enetpacketData  0x0E
;     282 //IP data area begins here
;     283 //******************************************
;     284 //* ARP Layout
;     285 //******************************************
;     286 #define arp_hwtype  0x0E
;     287 #define arp_prtype  0x10
;     288 #define arp_hwlen   0x12
;     289 #define arp_prlen   0x13
;     290 #define arp_op      0x14
;     291 #define arp_shaddr  0x16
;     292 //arp source mac address
;     293 #define arp_sipaddr 0x1C
;     294 //arp source IP address
;     295 #define arp_thaddr 0x20 
;     296 //arp target mac address
;     297 #define arp_tipaddr 0x26
;     298 //arp target ip address
;     299 //****************************************
;     300 //* IP Header Layout
;     301 //****************************************
;     302 #define ip_vers_len    0x0E 
;     303 //IP version and header length
;     304 #define ip_tos 	       0x0F
;     305 //IP type of service
;     306 #define ip_pktlen      0x10
;     307 //packet length
;     308 #define ip_id          0x12
;     309 //datagram ID
;     310 #define ip_frag_offset 0x14
;     311 //fragment offset
;     312 #define ip_ttl 	       0x16 
;     313 //time to live
;     314 #define ip_proto       0x17
;     315 //protocol (ICMP=1, TCP=6, UDP=11)
;     316 #define ip_hdr_cksum   0x18 
;     317 //header checksum
;     318 #define ip_srcaddr     0x1A
;     319 //IP address of source
;     320 #define ip_destaddr    0x1E
;     321 //IP aaddress of destination
;     322 #define ip_data        0x22
;     323 //IP data area
;     324 //************************************
;     325 //* TCP Header Layout
;     326 //************************************
;     327 #define TCP_srcport   0x22 
;     328 //TCP source port
;     329 #define TCP_destport  0x24
;     330 //TCP destination port
;     331 #define TCP_seqnum    0x26
;     332 //sequence number
;     333 #define TCP_acknum    0x2A
;     334 //acknowledgement number
;     335 #define TCP_hdrflags  0x2E
;     336 //4-bit header len(DATA OFFSET) and flags
;     337 #define TCP_window    0x30 
;     338 //window size
;     339 #define TCP_cksum     0x32
;     340 //TCP checksum
;     341 #define TCP_urgentptr 0x34
;     342 //urgent pointer
;     343 #define TCP_options      0x36 
;     344 //option/data
;     345 #define TCP_data      0x42
;     346 //*********************************************
;     347 //* TCP Flags
;     348 //* IN flags represent incoming bits
;     349 //* OUT flags represent outgoing bits
;     350 //* 576 octets(8xbit) max datalength
;     351 //*********************************************
;     352 #define FIN_IN (packet[TCP_hdrflags+1] & 0x01)
;     353 #define SYN_IN (packet[TCP_hdrflags+1] & 0x02)
;     354 #define RST_IN (packet[TCP_hdrflags+1] & 0x04)
;     355 #define PSH_IN (packet[TCP_hdrflags+1] & 0x08)
;     356 #define ACK_IN (packet[TCP_hdrflags+1] & 0x10)
;     357 #define URG_IN (packet[TCP_hdrflags+1] & 0x20)
;     358 #define FIN_OUT packet[TCP_hdrflags+1] |= 0x01
;     359 //00000001
;     360 #define NO_FIN packet[TCP_hdrflags+1] &= 0x62
;     361 //00111110
;     362 #define SYN_OUT packet[TCP_hdrflags+1] |= 0x02
;     363 //00000010
;     364 #define NO_SYN packet[TCP_hdrflags+1] &= 0x61
;     365 //00111101
;     366 #define RST_OUT packet[TCP_hdrflags+1] |= 0x04
;     367 //00000100
;     368 #define PSH_OUT packet[TCP_hdrflags+1] |= 0x08
;     369 //00001000
;     370 #define ACK_OUT packet[TCP_hdrflags+1] |= 0x10
;     371 //00010000
;     372 #define NO_ACK packet[TCP_hdrflags+1] &= 0x47
;     373 //00101111
;     374 #define URG_OUT packet[TCP_hdrflags+1] |= 0x20
;     375 //00100000
;     376 //*******************************************
;     377 //* Port Definitions
;     378 //* This address is used by TCP for HTTP server function
;     379 //* This can be changed to any valid port number
;     380 //* as long as you modify your code to recognize
;     381 //* the new port number
;     382 //*******************************************
;     383 #define MY_PORT_ADDRESS 0x50
;     384 //80 decimal for internet
;     385 //*******************************************
;     386 //*  IP Protocol Types
;     387 //*******************************************
;     388 #define PROT_ICMP 0x01
;     389 #define PROT_TCP  0x06
;     390 #define PROT_UDP  0x11
;     391 //*******************************************
;     392 //* ICMP Header
;     393 //*******************************************
;     394 #define ICMP_type    ip_data
;     395 #define ICMP_code    ICMP_type+1
;     396 #define ICMP_cksum   ICMP_code+1
;     397 #define ICMP_id      ICMP_chsum+2
;     398 #define ICMP_seqnum  ICMP_id+2
;     399 #define ICMP_data    ICMP_seqnum+2
;     400 //******************************************
;     401 //*  UDP Header and DHCP headers
;     402 //******************************************
;     403 #define UDP_srcport 	ip_data
;     404 #define UDP_destport 	UDP_srcport + 2
;     405 #define UDP_len 	UDP_destport + 2
;     406 #define UDP_cksum 	UDP_len + 2
;     407 #define UDP_data  	UDP_cksum + 2
;     408 #define DHCP_op 	UDP_cksum + 2
;     409 #define DHCP_htype 	DHCP_op + 1
;     410 #define DHCP_hlen 	DHCP_htype+1
;     411 #define DHCP_hops 	DHCP_hlen+1
;     412 #define DHCP_xid 	DHCP_hops + 1
;     413 #define DHCP_secs 	DHCP_xid + 4
;     414 #define DHCP_flags 	DHCP_secs + 2
;     415 #define DHCP_ciaddr 	DHCP_flags + 2
;     416 #define DHCP_yiaddr 	DHCP_ciaddr + 4
;     417 #define DHCP_siaddr 	DHCP_yiaddr + 4
;     418 #define DHCP_giaddr 	DHCP_siaddr + 4
;     419 #define DHCP_chaddr 	DHCP_giaddr+4
;     420 #define DHCP_sname 	DHCP_chaddr + 16
;     421 #define DHCP_file 	DHCP_sname + 64
;     422 #define DHCP_options 	DHCP_file + 128
;     423 //DHCP states
;     424 #define DHCP_DIS 0
;     425 #define DHCP_OFF 1
;     426 #define DHCP_ACK 2
;     427 unsigned int dhcpstate = DHCP_DIS;
_dhcpstate:
	.BYTE 0x2
;     428 
;     429 //****************************************
;     430 //* REALTEK CONTROL REGISTER OFFSETS
;     431 //* All offsets in Page 0 unless otherwise specified
;     432 //****************************************
;     433 #define CR 		0x00
;     434 #define PSTART 		0x01
;     435 #define PAR0 		0x01
;     436 //Page 1
;     437 #define CR9346 		0x01
;     438 //Page 3
;     439 #define PSTOP 		0x02
;     440 #define BNRY 		0x03
;     441 #define TSR 		0x04
;     442 #define TPSR 		0x04
;     443 #define TBCR0 		0x05
;     444 #define NCR 		0x05
;     445 #define TBCR1 		0x06
;     446 #define ISR 		0x07
;     447 #define CURR 		0x07
;     448 //Page 1
;     449 #define RSAR0 		0x08
;     450 #define CRDA0 		0x08
;     451 #define RSAR1 		0x09
;     452 #define CRDAL 		0x09
;     453 #define RBCR0 		0x0A
;     454 #define RBCR1 		0x0B
;     455 #define RSR 		0x0C
;     456 #define RCR 		0x0C
;     457 #define TCR	 	0x0D
;     458 #define CNTR0 		0x0D
;     459 #define DCR 		0x0E
;     460 #define CNTR1 		0x0E
;     461 #define IMR 		0x0F
;     462 #define CNTR2 		0x0F
;     463 #define RDMAPORT 	0x10
;     464 #define RSTPORT  	0x18
;     465 
;     466 //************************************************************
;     467 //* RTL8019AS INITIAL REGISTER VALUES
;     468 //************************************************************
;     469 #define rcrval 	0x04
;     470 #define tcrval 	0x00
;     471 #define dcrval 	0x58
;     472 //was 0x48
;     473 #define imrval 	0x11
;     474 //PRX and OVW interrupt enabled
;     475 #define txstart 0x40
;     476 #define rxstart 0x46
;     477 #define rxstop 	0x60
;     478 
;     479 //*************************************************************
;     480 //* RTL8019AS DATA/ADDRESS PIN DEFINITION
;     481 //*************************************************************
;     482 #define rtladdr PORTB
;     483 #define rtldata PORTC
;     484 #define tortl 	DDRC = 0xFF
;     485 #define fromrtl DDRC = 0x00
;     486 
;     487 //*************************************************************
;     488 //* RTL8019AS 9346 EEPROM PIN DEFINITIONS
;     489 //*************************************************************
;     490 #define EESK 0x08
;     491 //PORTD3 00001000
;     492 #define EEDI 0x10 
;     493 //PORTD4 00010000
;     494 #define EEDO 0x20
;     495 //PORTD5 00100000
;     496 
;     497 //*************************************************************
;     498 //* RTL8019AS PIN DEFINITIONS
;     499 //**************************************************************
;     500 #define ior_pin 0x40
;     501 //PORTD6 01000000
;     502 #define iow_pin 0x80
;     503 //PORTD7 10000000
;     504 #define rst_pin 0x80
;     505 //PORTB7 10000000
;     506 #define INT0_pin 0x04 
;     507 //PORTD2 00000100
;     508 
;     509 //*************************************************************
;     510 //* RTL8019AS ISR REGISTER DEFINITIONS
;     511 //*************************************************************
;     512 #define RST 0x80
;     513 //10000000
;     514 #define RDC 0x40
;     515 //01000000
;     516 #define OVW 0x10
;     517 //00010000
;     518 #define PRX 0x01
;     519 //00000001
;     520 
;     521 //*************************************************************
;     522 //* AVR RAM Definitions
;     523 //*************************************************************
;     524 //unsigned char aux_data[400]; //tcp received data area (200 char)
;     525 unsigned char req_ip[4];
_req_ip:
	.BYTE 0x4
;     526 unsigned int DHCP_wait = 0;
_DHCP_wait:
	.BYTE 0x2
;     527 int waitcount = 800;
_waitcount:
	.BYTE 0x2
;     528 unsigned char *addr,flags;
_addr:
	.BYTE 0x2
;     529 unsigned char byte_read,data_H,data_L;
_byte_read:
	.BYTE 0x1
_data_H:
	.BYTE 0x1
_data_L:
	.BYTE 0x1
;     530 unsigned char resend;
_resend:
	.BYTE 0x1
;     531 unsigned int txlen,rxlen,chksum16,hdrlen,tcplen,tcpdatalen_in,dhcpoptlen;
_txlen:
	.BYTE 0x2
_rxlen:
	.BYTE 0x2
_chksum16:
	.BYTE 0x2
_hdrlen:
	.BYTE 0x2
_tcplen:
	.BYTE 0x2
_tcpdatalen_in:
	.BYTE 0x2
_dhcpoptlen:
	.BYTE 0x2
;     532 unsigned int tcpdatalen_out,ISN,portaddr,ip_packet_len;
_tcpdatalen_out:
	.BYTE 0x2
_ISN:
	.BYTE 0x2
_portaddr:
	.BYTE 0x2
_ip_packet_len:
	.BYTE 0x2
;     533 unsigned long ic_chksum,hdr_chksum,my_seqnum,client_seqnum,incoming_ack,expected_ack;
_ic_chksum:
	.BYTE 0x4
_hdr_chksum:
	.BYTE 0x4
_my_seqnum:
	.BYTE 0x4
_client_seqnum:
	.BYTE 0x4
_incoming_ack:
	.BYTE 0x4
_expected_ack:
	.BYTE 0x4
;     534 
;     535 //**********************************************************
;     536 //* Flags
;     537 //**********************************************************
;     538 #define synflag 	0x01
;     539 //00000001
;     540 #define finflag 	0x02
;     541 //00000010
;     542 #define synflag_bit 	flags & synflag
;     543 #define finflag_bit	flags & finflag
;     544 //either we are sending an ack or sending data
;     545 unsigned int ackflag = 0;
_ackflag:
	.BYTE 0x2
;     546 // for TCP close operations
;     547 unsigned int closeflag = 0;
_closeflag:
	.BYTE 0x2
;     548 #define iorwport 	PORTD
;     549 #define eeprom 		PORTD
;     550 #define resetport 	PORTB
;     551 
;     552 //*******************************************************
;     553 //* RTL8019AS PIN MACROS
;     554 //*******************************************************
;     555 #define set_ior_pin 	iorwport |= ior_pin
;     556 #define clr_ior_pin 	iorwport &= ~ior_pin
;     557 #define set_iow_pin 	iorwport |= iow_pin
;     558 #define clr_iow_pin 	iorwport &= ~iow_pin
;     559 #define set_rst_pin 	resetport |= rst_pin
;     560 #define clr_rst_pin 	resetport &= ~rst_pin
;     561 
;     562 #define clr_EEDO 	eeprom &= ~EEDO
;     563 #define set_EEDO 	eeprom |= EEDO
;     564 #define clr_synflag 	flags &= ~synflag
;     565 #define set_synflag 	flags |= synflag
;     566 #define clr_finflag 	flags &= ~finflag
;     567 #define set_finflag 	flags |= finflag
;     568 
;     569 #define set_packet32(d,s) packet[d] = make8(s,3); \
;     570 	packet[d+1] = make8(s,2); \
;     571 	packet[d+2] = make8(s,1); \
;     572 	packet[d+3] = make8(s,0); 
;     573 
;     574 //converts decimal into words (8bit0
;     575 #define make8(var,offset) (var >> (offset*8)) & 0xFF
;     576 
;     577 //joins two 8bit binary into a 16bit binary and converts it to decimal
;     578 #define make16(varhigh,varlow) ((varhigh & 0xFF)*0x100) + (varlow & 0xFF)
;     579                                             
;     580 
;     581 //joins 4 8 bit numbers to form a 32bit number
;     582 #define make32(var1,var2,var3,var4) ((unsigned long)var1<<24)+((unsigned long)var2<<16)+ ((unsigned long)var3<<8)+((unsigned long)var4)
;     583 	
;     584 
;     585 //includes involving header and library files
;     586 #include "arp.h"
;     587 /*arp.c library source file
;     588 created by Eric Mesa
;     589 
;     590 *********************************
;     591 ver 0.1 10 Apr 2005
;     592 created arp.c
;     593 simply an implementation
;     594 of what Jeremy had written
;     595 without any extra optimizations
;     596 outside of what we had fixed
;     597 as of atmelwebserver.c ver 0.94.1
;     598 *********************************
;     599 
;     600 goes along with arp.h
;     601 header file
;     602 */
;     603 
;     604 /*
;     605 *******************************************************
;     606 * Perform ARP Response
;     607 * This routine supplies a requesting computer with the
;     608 * Ethernet module's MAC (hardware) address
;     609 *******************************************************
;     610 */
;     611 
;     612 //it's not standard C
;     613 //but this compiler is silly
;     614 //you include the .c file
;     615 //in the .h file instead
;     616 //of the other way around
;     617 //#include arp.h"
;     618 
;     619 void arp()
;     620 {

	.CSEG
_arp:
;     621 	unsigned char i;
;     622 
;     623 	//start the NIC
;     624 	write_rtl(CR,0x22);
	CALL SUBOPT_0x0
;	i -> R16
;     625 	
;     626 	//load beginning page for transmit buffer
;     627 	write_rtl(TPSR,txstart);
;     628 	
;     629 	//set start address for remote DMA operation
;     630 	write_rtl(RSAR0,0x00);
;     631 	write_rtl(RSAR1,0x40);
;     632 	
;     633 	//clear the interrupts
;     634 	write_rtl(ISR,0xFF);
;     635 	
;     636 	//load data byte count for remote DMA
;     637 	write_rtl(RBCR0,0x3C);
	CALL SUBOPT_0x1
;     638 	write_rtl(RBCR1,0x00);
	CALL SUBOPT_0x2
;     639 	
;     640 	//do remote write operation
;     641 	write_rtl(CR,0x12);
	CALL SUBOPT_0x3
;     642 	
;     643 	//write destination MAC address
;     644 	for(i=0;i<6;++i)
	LDI  R16,LOW(0)
_0x4E:
	CPI  R16,6
	BRSH _0x4F
;     645 		write_rtl(RDMAPORT,packet[enetpacketSrc0+i]);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	SUBI R16,-LOW(1)
	RJMP _0x4E
_0x4F:
;     646 		
;     647 	//write source MAC address
;     648 	for(i=0;i<6;++i)
	LDI  R16,LOW(0)
_0x51:
	CPI  R16,6
	BRSH _0x52
;     649 		write_rtl(RDMAPORT,MYMAC[i]);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	SUBI R16,-LOW(1)
	RJMP _0x51
_0x52:
;     650 		
;     651 	//write typelen hwtype prtype hwlen prlen op:
;     652 	addr = &packet[enetpacketType0];
	__POINTW1MN _packet,12
	STS  _addr,R30
	STS  _addr+1,R31
;     653 	packet[arp_op+1] = 0x02;
	LDI  R30,LOW(2)
	__PUTB1MN _packet,21
;     654 	for(i=0;i<10;++i)
	LDI  R16,LOW(0)
_0x54:
	CPI  R16,10
	BRSH _0x55
;     655 		write_rtl(RDMAPORT,*addr++);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL SUBOPT_0x7
	ST   -Y,R30
	CALL _write_rtl
	SUBI R16,-LOW(1)
	RJMP _0x54
_0x55:
;     656 	
;     657 	//write ethernet module MAC address
;     658 	for(i=0;i<6;++i)
	LDI  R16,LOW(0)
_0x57:
	CPI  R16,6
	BRSH _0x58
;     659 		write_rtl(RDMAPORT,MYMAC[i]);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x6
	SUBI R16,-LOW(1)
	RJMP _0x57
_0x58:
;     660 	
;     661 	//write ethernet module IP address
;     662 	for(i=0;i<4;++i)
	LDI  R16,LOW(0)
_0x5A:
	CPI  R16,4
	BRSH _0x5B
;     663 		write_rtl(RDMAPORT,MYIP[i]);
	CALL SUBOPT_0x4
	CLR  R31
	SUBI R30,LOW(-_MYIP)
	SBCI R31,HIGH(-_MYIP)
	CALL SUBOPT_0x8
	SUBI R16,-LOW(1)
	RJMP _0x5A
_0x5B:
;     664 	
;     665 	//write remote MAC address
;     666 	for(i=0;i<6;++i)
	LDI  R16,LOW(0)
_0x5D:
	CPI  R16,6
	BRSH _0x5E
;     667 		write_rtl(RDMAPORT,packet[enetpacketSrc0+i]);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	SUBI R16,-LOW(1)
	RJMP _0x5D
_0x5E:
;     668 		
;     669 	//write remote IP address
;     670 	for(i=0;i<4;++i)
	LDI  R16,LOW(0)
_0x60:
	CPI  R16,4
	BRSH _0x61
;     671 		write_rtl(RDMAPORT,packet[arp_sipaddr+i]);
	CALL SUBOPT_0x4
	SUBI R30,-LOW(28)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	CALL SUBOPT_0x8
	SUBI R16,-LOW(1)
	RJMP _0x60
_0x61:
;     672 		
;     673 	//write some pad characeters to fill out the packet to 
;     674 	//the minimum length
;     675 	for(i=0;i<0x12;++i)
	LDI  R16,LOW(0)
_0x63:
	CPI  R16,18
	BRSH _0x64
;     676 		write_rtl(RDMAPORT,0x00);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x9
	SUBI R16,-LOW(1)
	RJMP _0x63
_0x64:
;     677 		
;     678 	//make sure the DMA operation has successfully completed
;     679 	byte_read=0;
	CLR  R30
	STS  _byte_read,R30
;     680 	while(!(byte_read & RDC))
_0x65:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x40)
	BRNE _0x67
;     681 		read_rtl(ISR);
	CALL SUBOPT_0xA
	RJMP _0x65
_0x67:
;     682 	
;     683 	//load number of bytes to be transmitted
;     684 	write_rtl(TBCR0,0x3C);
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL SUBOPT_0x1
;     685 	write_rtl(TBCR1,0x00);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x9
;     686 	
;     687 	//send the contents of the transmit buffer onto the network
;     688 	write_rtl(CR,0x24);
	CALL SUBOPT_0xB
;     689 }
	RJMP _0x1A9
;     690 #include "icmp.h"
;     691 /*icmp.c library source file
;     692 created by Eric Mesa
;     693 
;     694 *********************************
;     695 ver 0.1 10 Apr 2005
;     696 created icmp.c
;     697 simply an implementation
;     698 of what Jeremy had written
;     699 without any extra optimizations
;     700 outside of what we had fixed
;     701 as of atmelwebserver.c ver 0.94.1
;     702 *********************************
;     703 
;     704 goes along with icmp.h
;     705 header file
;     706 */
;     707 
;     708 /*
;     709 *******************************************************
;     710 * Perform ARP Response
;     711 * This routine supplies a requesting computer with the
;     712 * Ethernet module's MAC (hardware) address
;     713 *******************************************************
;     714 */
;     715 
;     716 //it's not standard C
;     717 //but this compiler is silly
;     718 //you include the .c file
;     719 //in the .h file instead
;     720 //of the other way around
;     721 //#include icmp.h"
;     722 
;     723 /*
;     724 ********************************************************
;     725 * Perform ICMP Function
;     726 * This routine responds to a ping
;     727 ********************************************************
;     728 */
;     729 
;     730 void icmp()
;     731 {
_icmp:
;     732 	//set echo reply
;     733 	packet[ICMP_type] = 0x00;
	CLR  R30
	__PUTB1MN _packet,34
;     734 	packet[ICMP_code] = 0x00;
	__PUTB1MN _packet,35
;     735 	
;     736 	//clear the ICMP checksum
;     737 	packet[ICMP_cksum] = 0x00;
	__PUTB1MN _packet,36
;     738 	packet[ICMP_cksum+1] = 0x00;
	__PUTB1MN _packet,37
;     739 	
;     740 	//setup the IP header
;     741 	setipaddrs();
	CALL _setipaddrs
;     742 	
;     743 	//calculate the ICMP checksum
;     744 	hdr_chksum = 0;
	CLR  R30
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R30
	STS  _hdr_chksum+2,R30
	STS  _hdr_chksum+3,R30
;     745 	hdrlen = (make16(packet[ip_pktlen],packet[ip_pktlen+1])) - \
;     746 	//((packet[ip_vers_len] & 0x0F) * 4);
;     747 	((packet[ip_vers_len] & 0x0F) << 2);
	__GETB1MN _packet,16
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,17
	POP  R26
	POP  R27
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETB1MN _packet,14
	ANDI R30,LOW(0xF)
	LSL  R30
	LSL  R30
	POP  R26
	POP  R27
	CLR  R31
	SUB  R26,R30
	SBC  R27,R31
	STS  _hdrlen,R26
	STS  _hdrlen+1,R27
;     748 	addr = &packet[ICMP_type];
	__POINTW1MN _packet,34
	CALL SUBOPT_0xD
;     749 	cksum();
;     750 	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
;     751 	packet[ICMP_cksum] = make8(chksum16,1);
	CALL SUBOPT_0xE
	__PUTB1MN _packet,36
;     752 	packet[ICMP_cksum+1] = make8(chksum16,0);
	LDS  R30,_chksum16
	LDS  R31,_chksum16+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,37
;     753 	
;     754 	//send the ICMP packet along on its way
;     755 	echo_packet();
	CALL _echo_packet
;     756 }
	RET
;     757 #include "udp.h"
;     758 /*udp.c library source file
;     759 created by Eric Mesa
;     760 
;     761 *********************************
;     762 ver 0.1 10 Apr 2005
;     763 created udp.c
;     764 simply an implementation
;     765 of what Jeremy had written
;     766 without any extra optimizations
;     767 outside of what we had fixed
;     768 as of atmelwebserver.c ver 0.94.1
;     769 *********************************
;     770 
;     771 goes along with udp.h
;     772 header file
;     773 */
;     774 
;     775 //****************************************************
;     776 //* UDP Function (To be used with DHCP)
;     777 //* UDP_srcport = 0, destination is either 67 or 68 IP is
;     778 //* 0000000 and 255.255.255.255.255
;     779 //****************************************************
;     780 void udp()
;     781 {
_udp:
;     782 	//use port 68 DHCP
;     783 	if(packet[UDP_destport] == 0x00 && packet[UDP_destport+1] == 0x44)
	__GETB1MN _packet,36
	CPI  R30,0
	BRNE _0x6F
	__GETB1MN _packet,37
	CPI  R30,LOW(0x44)
	BREQ _0x70
_0x6F:
	RJMP _0x6E
_0x70:
;     784 	{
;     785 		ic_chksum = make16(packet[UDP_cksum],packet[UDP_cksum+1]);
	__GETB1MN _packet,40
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,41
	POP  R26
	POP  R27
	CALL SUBOPT_0xF
;     786 		//calculate the UDP checksum
;     787 		packet[UDP_cksum] = 0x00;
	__PUTB1MN _packet,40
;     788 		packet[UDP_cksum+1] = 0x00;
	CLR  R30
	__PUTB1MN _packet,41
;     789 		
;     790 		hdr_chksum = 0;
	CALL SUBOPT_0x10
;     791 		hdrlen = 0x08;
;     792 		addr = &packet[ip_srcaddr];
	__POINTW1MN _packet,26
	STS  _addr,R30
	STS  _addr+1,R31
;     793 		cksum();
	RCALL _cksum
;     794 		hdr_chksum = hdr_chksum + packet[ip_proto];
	__GETB1MN _packet,23
	CALL SUBOPT_0x11
;     795 		hdrlen = 0x02;
;     796 		addr = &packet[UDP_len];
	__POINTW1MN _packet,38
	STS  _addr,R30
	STS  _addr+1,R31
;     797 		cksum();
	RCALL _cksum
;     798 		hdrlen = make16(packet[UDP_len],packet[UDP_len+1]);
	__GETB1MN _packet,38
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,39
	POP  R26
	POP  R27
	CALL SUBOPT_0x12
;     799 		addr = &packet[UDP_srcport];
	__POINTW1MN _packet,34
	CALL SUBOPT_0xD
;     800 		cksum();
;     801 		chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
;     802 		//perform checksum
;     803 		if(chksum16 == ic_chksum)
	CALL SUBOPT_0x13
	BRNE _0x71
;     804 			dhcp();
	RCALL _dhcp
;     805 	}
_0x71:
;     806 }
_0x6E:
	RET
;     807 void udp_send()
;     808 {
_udp_send:
;     809 	unsigned int i;
;     810 	ip_packet_len = 20+make16(packet[UDP_len],packet[UDP_len+1]);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETB1MN _packet,38
	CALL SUBOPT_0xC
	ADIW R30,20
	PUSH R31
	PUSH R30
	__GETB1MN _packet,39
	POP  R26
	POP  R27
	CALL SUBOPT_0x14
;     811 	
;     812 	packet[ip_pktlen] = make8(ip_packet_len,1);
	CALL SUBOPT_0x15
	__PUTB1MN _packet,16
;     813 	packet[ip_pktlen+1] = make8(ip_packet_len,0);
	LDS  R30,_ip_packet_len
	LDS  R31,_ip_packet_len+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,17
;     814 	packet[ip_proto] = PROT_UDP;
	LDI  R30,LOW(17)
	__PUTB1MN _packet,23
;     815 	
;     816 	//calculate the IP header checksum
;     817 	packet[ip_hdr_cksum] = 0x00;
	CLR  R30
	__PUTB1MN _packet,24
;     818 	packet[ip_hdr_cksum+1] = 0x00;
	__PUTB1MN _packet,25
;     819 	hdr_chksum = 0;
	CLR  R30
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R30
	STS  _hdr_chksum+2,R30
	STS  _hdr_chksum+3,R30
;     820 	chksum16 = 0;
	CLR  R30
	STS  _chksum16,R30
	STS  _chksum16+1,R30
;     821 	hdrlen = (packet[ip_vers_len] & 0x0F)<<2;
	__GETB1MN _packet,14
	CALL SUBOPT_0x16
;     822 	addr = &packet[ip_vers_len];
	__POINTW1MN _packet,14
	CALL SUBOPT_0xD
;     823 	cksum();
;     824 	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
;     825 	packet[ip_hdr_cksum] = make8(chksum16,1);
	CALL SUBOPT_0xE
	__PUTB1MN _packet,24
;     826 	packet[ip_hdr_cksum+1] = make8(chksum16,0);
	LDS  R30,_chksum16
	LDS  R31,_chksum16+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,25
;     827 	
;     828 	//set the source port to 68 (client)
;     829 	packet[UDP_srcport] = 0x00;
	CLR  R30
	__PUTB1MN _packet,34
;     830 	packet[UDP_srcport+1] = 0x44;
	LDI  R30,LOW(68)
	__PUTB1MN _packet,35
;     831 	
;     832 	//set the destination port to 67 (server)
;     833 	packet[UDP_destport] = 0x00;
	CLR  R30
	__PUTB1MN _packet,36
;     834 	packet[UDP_destport+1] = 0x43;
	LDI  R30,LOW(67)
	__PUTB1MN _packet,37
;     835 	
;     836 	//calculate the UDP checksum
;     837 	packet[UDP_cksum] = 0x00;
	CLR  R30
	__PUTB1MN _packet,40
;     838 	packet[UDP_cksum+1] = 0x00;
	__PUTB1MN _packet,41
;     839 	
;     840 	hdr_chksum = 0;
	CALL SUBOPT_0x10
;     841 	hdrlen = 0x08;
;     842 	addr = &packet[ip_srcaddr];
	__POINTW1MN _packet,26
	STS  _addr,R30
	STS  _addr+1,R31
;     843 	cksum();
	RCALL _cksum
;     844 	hdr_chksum = hdr_chksum + packet[ip_proto];
	__GETB1MN _packet,23
	CALL SUBOPT_0x11
;     845 	hdrlen = 0x02;
;     846 	addr = &packet[UDP_len];
	__POINTW1MN _packet,38
	STS  _addr,R30
	STS  _addr+1,R31
;     847 	cksum();
	RCALL _cksum
;     848 	hdrlen = make16(packet[UDP_len],packet[UDP_len+1]);
	__GETB1MN _packet,38
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,39
	POP  R26
	POP  R27
	CALL SUBOPT_0x12
;     849 	addr = &packet[UDP_srcport];
	__POINTW1MN _packet,34
	CALL SUBOPT_0xD
;     850 	cksum();
;     851 	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
;     852 		
;     853 	packet[UDP_cksum] = make8(chksum16,1);
	CALL SUBOPT_0xE
	__PUTB1MN _packet,40
;     854 	packet[UDP_cksum+1] = make8(chksum16,0);
	LDS  R30,_chksum16
	LDS  R31,_chksum16+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,41
;     855 	
;     856 	txlen = ip_packet_len + 14;
	CALL SUBOPT_0x17
;     857 	//transmit length
;     858 	if(txlen < 60)
	BRSH _0x73
;     859 		txlen = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	STS  _txlen,R30
	STS  _txlen+1,R31
;     860 	data_L = make8(txlen,0);
_0x73:
	CALL SUBOPT_0x18
;     861 	data_H = make8(txlen,1);
;     862 	write_rtl(CR,0x22);
;     863 	read_rtl(CR);
;     864 	while(byte_read & 0x04)
_0x74:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x4)
	BREQ _0x76
;     865 		read_rtl(CR);
	CALL SUBOPT_0x19
	RJMP _0x74
_0x76:
;     866 	write_rtl(TPSR,txstart);
	CALL SUBOPT_0x1A
;     867 	write_rtl(RSAR0,0x00);
;     868 	write_rtl(RSAR1,0x40);
	CALL SUBOPT_0x1B
;     869 	write_rtl(ISR,0xFF);
;     870 	write_rtl(RBCR0, data_L);
;     871 	write_rtl(RBCR1, data_H);
;     872 	write_rtl(CR,0x12);
;     873 	//the actual send operation
;     874 	for(i=0;i<txlen;++i)         
	__GETWRN 16,17,0
_0x78:
	LDS  R30,_txlen
	LDS  R31,_txlen+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x79
;     875 		write_rtl(RDMAPORT,packet[enetpacketDest0+i]);
	CALL SUBOPT_0x1C
	__ADDWRN 16,17,1
	RJMP _0x78
_0x79:
;     876 	byte_read = 0;
	CLR  R30
	STS  _byte_read,R30
;     877 	while(!(byte_read & RDC))
_0x7A:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x40)
	BRNE _0x7C
;     878 		read_rtl(ISR);
	CALL SUBOPT_0xA
	RJMP _0x7A
_0x7C:
;     879 	write_rtl(TBCR0, data_L);
	CALL SUBOPT_0x1D
;     880 	write_rtl(TBCR1, data_H);
;     881 	write_rtl(CR,0x24);
;     882 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;     883 void dhcp_setip()
;     884 {
_dhcp_setip:
;     885 	//build the IP header
;     886 	//destination ip = 255.255.255.255
;     887 	packet[ip_destaddr] = 0xFF;
	LDI  R30,LOW(255)
	__PUTB1MN _packet,30
;     888 	packet[ip_destaddr + 1] = 0xFF;
	__PUTB1MN _packet,31
;     889 	packet[ip_destaddr + 2] = 0xFF;
	__PUTB1MN _packet,32
;     890 	packet[ip_destaddr + 3] = 0xFF;
	__PUTB1MN _packet,33
;     891 	//source IP = 0.0.0.0
;     892 	packet[ip_srcaddr] =  	  0;
	CLR  R30
	__PUTB1MN _packet,26
;     893 	packet[ip_srcaddr + 1] =  0;
	__PUTB1MN _packet,27
;     894 	packet[ip_srcaddr + 2] =  0;
	__PUTB1MN _packet,28
;     895 	packet[ip_srcaddr + 3] =  0;
	__PUTB1MN _packet,29
;     896 	//you don't know the destination MAC
;     897 	packet[enetpacketDest0] = 255;
	LDI  R30,LOW(255)
	STS  _packet,R30
;     898 	packet[enetpacketDest1] = 255;
	__PUTB1MN _packet,1
;     899 	packet[enetpacketDest2] = 255;
	__PUTB1MN _packet,2
;     900 	packet[enetpacketDest3] = 255;
	__PUTB1MN _packet,3
;     901 	packet[enetpacketDest4] = 255;
	__PUTB1MN _packet,4
;     902 	packet[enetpacketDest5] = 255;
	__PUTB1MN _packet,5
;     903 	//make ethernet module mac address the source address
;     904 	packet[enetpacketSrc0] = MYMAC[0];
	LDS  R30,_MYMAC
	__PUTB1MN _packet,6
;     905 	packet[enetpacketSrc1] = MYMAC[1];
	__GETB1MN _MYMAC,1
	__PUTB1MN _packet,7
;     906 	packet[enetpacketSrc2] = MYMAC[2];
	__GETB1MN _MYMAC,2
	__PUTB1MN _packet,8
;     907 	packet[enetpacketSrc3] = MYMAC[3];
	__GETB1MN _MYMAC,3
	__PUTB1MN _packet,9
;     908 	packet[enetpacketSrc4] = MYMAC[4];
	__GETB1MN _MYMAC,4
	__PUTB1MN _packet,10
;     909 	packet[enetpacketSrc5] = MYMAC[5];
	__GETB1MN _MYMAC,5
	__PUTB1MN _packet,11
;     910 	//calculate IP packet length done by the respective protocols
;     911 	packet[enetpacketType0] = 0x08;
	LDI  R30,LOW(8)
	__PUTB1MN _packet,12
;     912 	packet[enetpacketType1] = 0x00;
	CLR  R30
	__PUTB1MN _packet,13
;     913 	//set IP header length to 20 bytes
;     914 	packet[ip_vers_len] = 0x45;
	LDI  R30,LOW(69)
	__PUTB1MN _packet,14
;     915 	//1st step in getting an IP address
;     916 }
	RET
;     917 #include "dhcp.h"
;     918 /*dhcp.c library source file
;     919 created by Eric Mesa
;     920 
;     921 *********************************
;     922 ver 0.1 10 Apr 2005
;     923 created dhcp.c
;     924 simply an implementation
;     925 of what Jeremy had written
;     926 without any extra optimizations
;     927 outside of what we had fixed
;     928 as of atmelwebserver.c ver 0.94.1
;     929 *********************************
;     930 
;     931 goes along with dchp.h
;     932 header file
;     933 */
;     934 
;     935 /*
;     936 ******************************************************
;     937 * DHCP for obtaining IP from router port 67~68 using UDP
;     938 ******************************************************
;     939 */
;     940 
;     941 void dhcp()
;     942 {
_dhcp:
;     943 	unsigned char i;
;     944 	if(dhcpstate == DHCP_DIS)
	ST   -Y,R16
;	i -> R16
	LDS  R30,_dhcpstate
	LDS  R31,_dhcpstate+1
	SBIW R30,0
	BREQ PC+3
	JMP _0x80
;     945 	{
;     946 		//listen to broadcast
;     947 		for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0x82:
	CPI  R16,4
	BRSH _0x83
;     948 			MYIP[i] = 255;
	CALL SUBOPT_0x1E
	SUBI R16,-1
	RJMP _0x82
_0x83:
;     949 		packet[DHCP_op] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _packet,42
;     950 		packet[DHCP_htype] = 1;
	__PUTB1MN _packet,43
;     951 		packet[DHCP_hlen] = 6;
	LDI  R30,LOW(6)
	__PUTB1MN _packet,44
;     952 		packet[DHCP_hops] = 0;
	CLR  R30
	__PUTB1MN _packet,45
;     953 		packet[DHCP_xid] = make8(0x31257A1D,3);
	LDI  R30,LOW(49)
	__PUTB1MN _packet,46
;     954 		packet[DHCP_xid+1] = make8(0x31257A1D,2);
	LDI  R30,LOW(37)
	__PUTB1MN _packet,47
;     955 		packet[DHCP_xid+2] = make8(0x31257A1D,1);
	LDI  R30,LOW(122)
	__PUTB1MN _packet,48
;     956 		packet[DHCP_xid+3] = make8(0x31257A1D,0);
	LDI  R30,LOW(29)
	__PUTB1MN _packet,49
;     957 		for(i=DHCP_secs;i<DHCP_chaddr;i++)
	LDI  R16,LOW(50)
_0x85:
	CPI  R16,70
	BRSH _0x86
;     958 			packet[i]=0;
	CALL SUBOPT_0x1F
	SUBI R16,-1
	RJMP _0x85
_0x86:
;     959 		for(i=0;i<6;i++)
	LDI  R16,LOW(0)
_0x88:
	CPI  R16,6
	BRSH _0x89
;     960 			packet[DHCP_chaddr+i] = MYMAC[i];
	CALL SUBOPT_0x20
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0x88
_0x89:
;     961 		for(i=0;i<10;i++)
	LDI  R16,LOW(0)
_0x8B:
	CPI  R16,10
	BRSH _0x8C
;     962 			packet[DHCP_chaddr+6+i] = 0;
	CALL SUBOPT_0x22
	SUBI R16,-1
	RJMP _0x8B
_0x8C:
;     963 		for(i=0;i<192;i++)
	LDI  R16,LOW(0)
_0x8E:
	CPI  R16,192
	BRSH _0x8F
;     964 			packet[DHCP_sname+i]=0;
	CALL SUBOPT_0x23
	SUBI R16,-1
	RJMP _0x8E
_0x8F:
;     965 		//magic cookie
;     966 		packet[DHCP_options] = 99;
	LDI  R30,LOW(99)
	__PUTB1MN _packet,278
;     967 		packet[DHCP_options+1] = 130;
	LDI  R30,LOW(130)
	__PUTB1MN _packet,279
;     968 		packet[DHCP_options+2] = 83;
	LDI  R30,LOW(83)
	__PUTB1MN _packet,280
;     969 		packet[DHCP_options+3] = 99;
	LDI  R30,LOW(99)
	__PUTB1MN _packet,281
;     970 		//message type
;     971 		packet[DHCP_options+4] = 53;
	LDI  R30,LOW(53)
	__PUTB1MN _packet,282
;     972 		packet[DHCP_options+5] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _packet,283
;     973 		//DHCP_DISCOVER
;     974 		packet[DHCP_options+6] = 1;
	__PUTB1MN _packet,284
;     975 		//Client Identifier
;     976 		packet[DHCP_options+7] = 61;
	LDI  R30,LOW(61)
	__PUTB1MN _packet,285
;     977 		packet[DHCP_options+8] = 7;
	LDI  R30,LOW(7)
	__PUTB1MN _packet,286
;     978 		packet[DHCP_options+9] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _packet,287
;     979 		for(i=0;i<6;i++)
	LDI  R16,LOW(0)
_0x91:
	CPI  R16,6
	BRSH _0x92
;     980 			packet[DHCP_options+10+i] = MYMAC[i];
	CALL SUBOPT_0x24
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0x91
_0x92:
;     981 		//END OPTIONS
;     982 		packet[DHCP_options+16] = 255;
	LDI  R30,LOW(255)
	__PUTB1MN _packet,294
;     983 		//lenght of UDP datagram = 8bytes; length of DHCP data = 236 bytes + options
;     984 		dhcpoptlen = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x25
;     985 		packet[UDP_len] = make8(244+dhcpoptlen,1);
	__PUTB1MN _packet,38
;     986 		packet[UDP_len+1] = make8(244+dhcpoptlen,0);
	CALL SUBOPT_0x26
	__PUTB1MN _packet,39
;     987 		dhcp_setip();
	CALL _dhcp_setip
;     988 		udp_send();
	CALL _udp_send
;     989 		for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0x94:
	CPI  R16,4
	BRSH _0x95
;     990 			MYIP[i] = 255;
	CALL SUBOPT_0x1E
	SUBI R16,-1
	RJMP _0x94
_0x95:
;     991 		DHCP_wait = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _DHCP_wait,R30
	STS  _DHCP_wait+1,R31
;     992 		//wait for DHCP offer
;     993 		dhcpstate = DHCP_OFF;
	STS  _dhcpstate,R30
	STS  _dhcpstate+1,R31
;     994 	}
;     995 	//if we have an offer from the server
;     996 	if(dhcpstate == DHCP_OFF) // && packet[ip_srcaddr] && packet[ip_srcaddr +1] && packet[ip_srcaddr + 2] && packet[ip_srcaddr+3])
_0x80:
	LDS  R26,_dhcpstate
	LDS  R27,_dhcpstate+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BREQ PC+3
	JMP _0x96
;     997 	{
;     998 		//check transaction id adn message type
;     999 		if((DHCP_wait == 2) || ((make32(packet[DHCP_xid], packet[DHCP_xid+1], packet[DHCP_xid+2],packet[DHCP_xid+3]) == 0x31257A1D) && (packet[DHCP_options+4] == 53) && (packet[DHCP_options+5] == 1) && (packet[DHCP_options+6] ==2)))
	LDS  R26,_DHCP_wait
	LDS  R27,_DHCP_wait+1
	CPI  R26,LOW(0x2)
	LDI  R30,HIGH(0x2)
	CPC  R27,R30
	BRNE PC+3
	JMP _0x98
	__GETB1MN _packet,46
	CALL SUBOPT_0x27
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,47
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,48
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,49
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	__CPD2N 0x31257A1D
	BRNE _0x99
	__GETB1MN _packet,282
	CPI  R30,LOW(0x35)
	BRNE _0x99
	__GETB1MN _packet,283
	CPI  R30,LOW(0x1)
	BRNE _0x99
	__GETB1MN _packet,284
	CPI  R30,LOW(0x2)
	BREQ _0x98
_0x99:
	RJMP _0x97
_0x98:
;    1000 		{
;    1001 			if(DHCP_wait == 1)
	LDS  R26,_DHCP_wait
	LDS  R27,_DHCP_wait+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BRNE _0x9C
;    1002 			for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0x9E:
	CPI  R16,4
	BRSH _0x9F
;    1003 			{
;    1004 				req_ip[i] = packet[DHCP_yiaddr+i];
	CALL SUBOPT_0x29
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2A
	LD   R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;    1005 				serverid[i]= packet[ip_srcaddr+i];
	CALL SUBOPT_0x2B
	PUSH R31
	PUSH R30
	MOV  R30,R16
	SUBI R30,-LOW(26)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	LD   R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;    1006 			}
	SUBI R16,-1
	RJMP _0x9E
_0x9F:
;    1007 			//stop resending discover
;    1008 			DHCP_wait = 2;
_0x9C:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _DHCP_wait,R30
	STS  _DHCP_wait+1,R31
;    1009 			// listen to broadcast
;    1010 			for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0xA1:
	CPI  R16,4
	BRSH _0xA2
;    1011 				MYIP[i] = 255;
	CALL SUBOPT_0x1E
	SUBI R16,-1
	RJMP _0xA1
_0xA2:
;    1012 			//assemble DHCP_req
;    1013 			packet[DHCP_op] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _packet,42
;    1014 			packet[DHCP_htype] = 1;
	__PUTB1MN _packet,43
;    1015 			packet[DHCP_hlen] = 6;
	LDI  R30,LOW(6)
	__PUTB1MN _packet,44
;    1016 			packet[DHCP_hops] = 0;
	CLR  R30
	__PUTB1MN _packet,45
;    1017 			packet[DHCP_xid] = make8(0x31257A1D,3);
	LDI  R30,LOW(49)
	__PUTB1MN _packet,46
;    1018 			packet[DHCP_xid+1] = make8(0x31257A1D,2);
	LDI  R30,LOW(37)
	__PUTB1MN _packet,47
;    1019 			packet[DHCP_xid+2] = make8(0x31257A1D,1);
	LDI  R30,LOW(122)
	__PUTB1MN _packet,48
;    1020 			//fixed typeo, this was +1 and should be +3, fixed 7 Apr 2005
;    1021 			packet[DHCP_xid+3] = make8(0x31257A1D,0);
	LDI  R30,LOW(29)
	__PUTB1MN _packet,49
;    1022 			for(i=DHCP_secs;i<DHCP_yiaddr;i++)
	LDI  R16,LOW(50)
_0xA4:
	CPI  R16,58
	BRSH _0xA5
;    1023 				packet[i]=0;
	CALL SUBOPT_0x1F
	SUBI R16,-1
	RJMP _0xA4
_0xA5:
;    1024 			for(i=DHCP_siaddr;i<DHCP_chaddr;i++)
	LDI  R16,LOW(62)
_0xA7:
	CPI  R16,70
	BRSH _0xA8
;    1025 			           packet[i]=0;
	CALL SUBOPT_0x1F
	SUBI R16,-1
	RJMP _0xA7
_0xA8:
;    1026 			for(i=0;i<6;i++)
	LDI  R16,LOW(0)
_0xAA:
	CPI  R16,6
	BRSH _0xAB
;    1027 				packet[DHCP_chaddr+i] = MYMAC[i];
	CALL SUBOPT_0x20
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0xAA
_0xAB:
;    1028 			for(i=0;i<10;i++)
	LDI  R16,LOW(0)
_0xAD:
	CPI  R16,10
	BRSH _0xAE
;    1029 				packet[DHCP_chaddr+6+i] = 0;
	CALL SUBOPT_0x22
	SUBI R16,-1
	RJMP _0xAD
_0xAE:
;    1030 			for(i=0;i<192;i++)
	LDI  R16,LOW(0)
_0xB0:
	CPI  R16,192
	BRSH _0xB1
;    1031 				packet[DHCP_sname+i]=0;
	CALL SUBOPT_0x23
	SUBI R16,-1
	RJMP _0xB0
_0xB1:
;    1032 			//magic cookie
;    1033 			packet[DHCP_options] = 99;
	LDI  R30,LOW(99)
	__PUTB1MN _packet,278
;    1034 			packet[DHCP_options+1] = 130;
	LDI  R30,LOW(130)
	__PUTB1MN _packet,279
;    1035 			packet[DHCP_options+2] = 83;
	LDI  R30,LOW(83)
	__PUTB1MN _packet,280
;    1036 			packet[DHCP_options+3] = 99;
	LDI  R30,LOW(99)
	__PUTB1MN _packet,281
;    1037 			//message type
;    1038 			packet[DHCP_options+4] = 53;
	LDI  R30,LOW(53)
	__PUTB1MN _packet,282
;    1039 			packet[DHCP_options+5] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _packet,283
;    1040 			//DHCP_REQUEST
;    1041 			packet[DHCP_options+6] =  3;
	LDI  R30,LOW(3)
	__PUTB1MN _packet,284
;    1042 			//Client Identifier
;    1043 			packet[DHCP_options+7] = 61;
	LDI  R30,LOW(61)
	__PUTB1MN _packet,285
;    1044 			packet[DHCP_options+8] = 7;
	LDI  R30,LOW(7)
	__PUTB1MN _packet,286
;    1045 			packet[DHCP_options+9] = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _packet,287
;    1046 			for(i=0;i<6;i++)
	LDI  R16,LOW(0)
_0xB3:
	CPI  R16,6
	BRSH _0xB4
;    1047 				packet[DHCP_options+10+i] = MYMAC[i];
	CALL SUBOPT_0x24
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0xB3
_0xB4:
;    1048 			//Requested IP address
;    1049 			packet[DHCP_options+16]=50;
	LDI  R30,LOW(50)
	__PUTB1MN _packet,294
;    1050 			packet[DHCP_options+17]=4;
	LDI  R30,LOW(4)
	__PUTB1MN _packet,295
;    1051 			for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0xB6:
	CPI  R16,4
	BRSH _0xB7
;    1052 				packet[DHCP_options+18+i] = req_ip[i];
	MOV  R30,R16
	LDI  R26,LOW(296)
	LDI  R27,HIGH(296)
	CALL SUBOPT_0x2C
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	LD   R30,Z
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0xB6
_0xB7:
;    1053 			for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0xB9:
	CPI  R16,4
	BRSH _0xBA
;    1054 				packet[DHCP_yiaddr+i]=0;
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2D
	SUBI R16,-1
	RJMP _0xB9
_0xBA:
;    1055 			//server ID
;    1056 			packet[DHCP_options+22] = 54;
	LDI  R30,LOW(54)
	__PUTB1MN _packet,300
;    1057 			packet[DHCP_options+23] = 4;
	LDI  R30,LOW(4)
	__PUTB1MN _packet,301
;    1058 			for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0xBC:
	CPI  R16,4
	BRSH _0xBD
;    1059 				packet[DHCP_options+24+i] = serverid[i];
	MOV  R30,R16
	LDI  R26,LOW(302)
	LDI  R27,HIGH(302)
	CALL SUBOPT_0x2C
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2B
	LD   R30,Z
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0xBC
_0xBD:
;    1060 			//END OPTIONS
;    1061 			packet[DHCP_options + 28] = 255;
	LDI  R30,LOW(255)
	__PUTB1MN _packet,306
;    1062 			//length of UDP datagram = 8bytes; length of DHCP data = 235 bytes + options
;    1063 			dhcpoptlen = 29;
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL SUBOPT_0x25
;    1064 			packet[UDP_len] = make8(244+dhcpoptlen,1);
	__PUTB1MN _packet,38
;    1065 			packet[UDP_len+1] = make8(244+dhcpoptlen,0);
	CALL SUBOPT_0x26
	__PUTB1MN _packet,39
;    1066 			//make a DHCP request
;    1067 			dhcp_setip();
	CALL _dhcp_setip
;    1068 			udp_send();
	CALL _udp_send
;    1069 			//wait for DHCP ACK
;    1070 			dhcpstate = DHCP_ACK;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _dhcpstate,R30
	STS  _dhcpstate+1,R31
;    1071 		}
;    1072 	}
_0x97:
;    1073 	if((dhcpstate == DHCP_ACK) && (packet[ip_srcaddr] == serverid[0]) && (packet[ip_srcaddr+1] == serverid[1]) && (packet[ip_srcaddr+2] == serverid[2]) && (packet[ip_srcaddr + 3] == serverid[3]))
_0x96:
	LDS  R26,_dhcpstate
	LDS  R27,_dhcpstate+1
	CPI  R26,LOW(0x2)
	LDI  R30,HIGH(0x2)
	CPC  R27,R30
	BRNE _0xBF
	__GETB2MN _packet,26
	LDS  R30,_serverid
	CP   R30,R26
	BRNE _0xBF
	__GETB1MN _packet,27
	PUSH R30
	__GETB1MN _serverid,1
	POP  R26
	CP   R30,R26
	BRNE _0xBF
	__GETB1MN _packet,28
	PUSH R30
	__GETB1MN _serverid,2
	POP  R26
	CP   R30,R26
	BRNE _0xBF
	__GETB1MN _packet,29
	PUSH R30
	__GETB1MN _serverid,3
	POP  R26
	CP   R30,R26
	BREQ _0xC0
_0xBF:
	RJMP _0xBE
_0xC0:
;    1074 	{
;    1075 		//check if message type is an ack
;    1076 		if((make32(packet[DHCP_xid],packet[DHCP_xid+1],packet[DHCP_xid+2],packet[DHCP_xid+3]) == 0x31257A1D)&&(packet[DHCP_options+4]==53)&&(packet[DHCP_options+5] == 1)&&(packet[DHCP_options+6]==5))
	__GETB1MN _packet,46
	CALL SUBOPT_0x27
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,47
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,48
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,49
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD21
	__CPD2N 0x31257A1D
	BRNE _0xC2
	__GETB1MN _packet,282
	CPI  R30,LOW(0x35)
	BRNE _0xC2
	__GETB1MN _packet,283
	CPI  R30,LOW(0x1)
	BRNE _0xC2
	__GETB1MN _packet,284
	CPI  R30,LOW(0x5)
	BREQ _0xC3
_0xC2:
	RJMP _0xC1
_0xC3:
;    1077 		{
;    1078 			DHCP_wait = 0;
	CLR  R30
	STS  _DHCP_wait,R30
	STS  _DHCP_wait+1,R30
;    1079 			//take the IP address
;    1080 			for(i=0;i<4;i++)
	LDI  R16,LOW(0)
_0xC5:
	CPI  R16,4
	BRSH _0xC6
;    1081 				MYIP[i] = packet[DHCP_yiaddr+i];
	MOV  R30,R16
	CLR  R31
	SUBI R30,LOW(-_MYIP)
	SBCI R31,HIGH(-_MYIP)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2A
	LD   R30,Z
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R16,-1
	RJMP _0xC5
_0xC6:
;    1082 		}
;    1083 	}
_0xC1:
;    1084 }
_0xBE:
_0x1A9:
	LD   R16,Y+
	RET
;    1085 #include "tcp.h"
;    1086 /*tcp.c library source file
;    1087 created by Eric Mesa
;    1088 
;    1089 *********************************
;    1090 ver 0.1 10 Apr 2005
;    1091 created tcp.c
;    1092 simply an implementation
;    1093 of what Jeremy had written
;    1094 without any extra optimizations
;    1095 outside of what we had fixed
;    1096 as of atmelwebserver.c ver 0.94.1
;    1097 *********************************
;    1098 
;    1099 goes along with tcp.h
;    1100 header file
;    1101 */
;    1102 
;    1103 /*
;    1104 *****************************************************
;    1105 * TCP Function
;    1106 * This function uses TCP protocol to interface with the browsser
;    1107 * using well known port 80.  The application function is called with
;    1108 * ever incoming character.
;    1109 ******************************************************
;    1110 */
;    1111 
;    1112 void tcp()
;    1113 {
_tcp:
;    1114 	//assemble the destination port address (my) from from the incoming packet
;    1115 	portaddr = make16(packet[TCP_destport],packet[TCP_destport+1]);
	__GETB1MN _packet,36
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,37
	POP  R26
	POP  R27
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	STS  _portaddr,R30
	STS  _portaddr+1,R31
;    1116 	//calculate the length of teh data coming in with the packet
;    1117 	//incoming tcp header length
;    1118 	tcplen = ip_packet_len - ((packet[ip_vers_len] & 0x0F) << 2);
	__GETB1MN _packet,14
	CALL SUBOPT_0x2E
;    1119 	//incoming data length =
;    1120 	tcpdatalen_in = (make16(packet[ip_pktlen],packet[ip_pktlen+1])) - \
;    1121 	((packet[ip_vers_len] & 0x0F) << 2)-(((packet[TCP_hdrflags] & 0xF0) >> 4) << 2);
	__GETB1MN _packet,16
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,17
	POP  R26
	POP  R27
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETB1MN _packet,14
	ANDI R30,LOW(0xF)
	LSL  R30
	LSL  R30
	POP  R26
	POP  R27
	CLR  R31
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	PUSH R31
	PUSH R30
	__GETB1MN _packet,46
	ANDI R30,LOW(0xF0)
	SWAP R30
	ANDI R30,0xF
	LSL  R30
	LSL  R30
	POP  R26
	POP  R27
	CLR  R31
	SUB  R26,R30
	SBC  R27,R31
	STS  _tcpdatalen_in,R26
	STS  _tcpdatalen_in+1,R27
;    1122 	//convert the entire packet into a checksum
;    1123 	//checksum of entire datagram
;    1124 	ic_chksum = make16(packet[TCP_cksum],packet[TCP_cksum+1]);
	__GETB1MN _packet,50
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,51
	POP  R26
	POP  R27
	CALL SUBOPT_0xF
;    1125 	packet[TCP_cksum] = 0x00;
	__PUTB1MN _packet,50
;    1126 	packet[TCP_cksum+1] = 0x00;
	CLR  R30
	__PUTB1MN _packet,51
;    1127 	hdr_chksum = 0;
	CALL SUBOPT_0x10
;    1128 	hdrlen = 0x08;
;    1129 	addr = &packet[ip_srcaddr];
	__POINTW1MN _packet,26
	STS  _addr,R30
	STS  _addr+1,R31
;    1130 	cksum();
	RCALL _cksum
;    1131 	hdr_chksum += packet[ip_proto];
	__GETB1MN _packet,23
	CALL SUBOPT_0x2F
;    1132 	hdr_chksum += tcplen;
	CALL SUBOPT_0x30
;    1133 	hdrlen = tcplen;
;    1134 	addr = &packet[TCP_srcport];
	__POINTW1MN _packet,34
	CALL SUBOPT_0xD
;    1135 	cksum();
;    1136 	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >>16));
;    1137 	if((chksum16 == ic_chksum)&&(portaddr==MY_PORT_ADDRESS))
	CALL SUBOPT_0x13
	BRNE _0xCC
	LDS  R26,_portaddr
	LDS  R27,_portaddr+1
	CPI  R26,LOW(0x50)
	LDI  R30,HIGH(0x50)
	CPC  R27,R30
	BREQ _0xCD
_0xCC:
	RJMP _0xCB
_0xCD:
;    1138 	{
;    1139 		//The webserver can only connect to one client at a time
;    1140 		{
;    1141 			/*------3 Way handshake--*/
;    1142 			//this code segment processs the incoming SYN from the client
;    1143 			//and sends back the initial sequence number (ISN) and acknowledges
;    1144 			//the incoming SYN packet (step 1 and 2 of 3 way handshake)
;    1145 			if(SYN_IN && portaddr == MY_PORT_ADDRESS)
	__GETB1MN _packet,47
	ANDI R30,LOW(0x2)
	BREQ _0xCF
	LDS  R26,_portaddr
	LDS  R27,_portaddr+1
	CPI  R26,LOW(0x50)
	LDI  R30,HIGH(0x50)
	CPC  R27,R30
	BREQ _0xD0
_0xCF:
	RJMP _0xCE
_0xD0:
;    1146 			{
;    1147 				counter=0;
	CLR  R30
	STS  _counter,R30
	STS  _counter+1,R30
;    1148 								
;    1149 				tcpdatalen_in=0x01;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _tcpdatalen_in,R30
	STS  _tcpdatalen_in+1,R31
;    1150 				tcpdatalen_out = 0;
	CLR  R30
	STS  _tcpdatalen_out,R30
	STS  _tcpdatalen_out+1,R30
;    1151 				set_synflag;
	MOV  R30,R14
	ORI  R30,1
	MOV  R14,R30
;    1152 				client[0] = packet[ip_srcaddr];
	__GETB1MN _packet,26
	STS  _client,R30
;    1153 				client[1] = packet[ip_srcaddr+1];
	__GETB1MN _packet,27
	__PUTB1MN _client,1
;    1154 				client[2] = packet[ip_srcaddr+2];
	__GETB1MN _packet,28
	__PUTB1MN _client,2
;    1155 				client[3] = packet[ip_srcaddr + 3];
	__GETB1MN _packet,29
	__PUTB1MN _client,3
;    1156 				//bulid IP header switch the dest and src IPs 
;    1157 				setipaddrs();
	CALL _setipaddrs
;    1158 				//set the header field to 24 bytes(MSS options)
;    1159 				//packet[TCP_hdrflags] = (0x6<<4)&0xF0
;    1160 				//set the ports
;    1161 				data_L = packet[TCP_srcport];
	__GETB1MN _packet,34
	STS  _data_L,R30
;    1162 				
;    1163 				packet[TCP_srcport]=packet[TCP_destport];
	__GETB1MN _packet,36
	__PUTB1MN _packet,34
;    1164 				packet[TCP_destport]=data_L;
	__POINTW2MN _packet,36
	LDS  R30,_data_L
	ST   X,R30
;    1165 				
;    1166 				data_L=packet[TCP_srcport+1];
	__GETB1MN _packet,35
	STS  _data_L,R30
;    1167 				
;    1168 				packet[TCP_srcport+1] = packet[TCP_destport+1];
	__GETB1MN _packet,37
	__PUTB1MN _packet,35
;    1169 				packet[TCP_destport+1] = data_L;
	__POINTW2MN _packet,37
	CALL SUBOPT_0x31
;    1170 				//ack = SEQ_IN + 1
;    1171 				assemble_ack();
;    1172 				//if the seqnum overflows (>16 bits)
;    1173 				if(++ISN == 0x0000 || ++ISN == 0xFFFF)
	CALL SUBOPT_0x32
	CALL __CPW02
	BREQ _0xD2
	CALL SUBOPT_0x32
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRNE _0xD1
_0xD2:
;    1174 					my_seqnum=0x1234FFFF;
	__GETD1N 0x1234FFFF
	STS  _my_seqnum,R30
	STS  _my_seqnum+1,R31
	STS  _my_seqnum+2,R22
	STS  _my_seqnum+3,R23
;    1175 				//expected ackknowledgement
;    1176 				expected_ack=my_seqnum+1;
_0xD1:
	LDS  R30,_my_seqnum
	LDS  R31,_my_seqnum+1
	LDS  R22,_my_seqnum+2
	LDS  R23,_my_seqnum+3
	__ADDD1N 1
	STS  _expected_ack,R30
	STS  _expected_ack+1,R31
	STS  _expected_ack+2,R22
	STS  _expected_ack+3,R23
;    1177 				set_packet32(TCP_seqnum,my_seqnum);
	LDS  R30,_my_seqnum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,38
	CALL SUBOPT_0x33
	__PUTB1MN _packet,39
	CALL SUBOPT_0x34
	__PUTB1MN _packet,40
	LDS  R30,_my_seqnum
	LDS  R31,_my_seqnum+1
	LDS  R22,_my_seqnum+2
	LDS  R23,_my_seqnum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,41
;    1178 				packet[TCP_hdrflags+1] = 0x00;
	CLR  R30
	__PUTB1MN _packet,47
;    1179 				SYN_OUT;
	__POINTW1MN _packet,47
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,2
	POP  R26
	POP  R27
	ST   X,R30
;    1180 				ACK_OUT;
	__POINTW1MN _packet,47
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x10
	POP  R26
	POP  R27
	ST   X,R30
;    1181 				
;    1182 				packet[TCP_cksum] = 0x00;
	CLR  R30
	__PUTB1MN _packet,50
;    1183 				packet[TCP_cksum+1] = 0x00;
	__PUTB1MN _packet,51
;    1184 				
;    1185 				hdr_chksum = 0;
	CALL SUBOPT_0x10
;    1186 				hdrlen = 0x08;
;    1187 				addr = &packet[ip_srcaddr];
	__POINTW1MN _packet,26
	STS  _addr,R30
	STS  _addr+1,R31
;    1188 				cksum();
	RCALL _cksum
;    1189 				hdr_chksum = hdr_chksum + packet[ip_proto];
	__GETB1MN _packet,23
	CALL SUBOPT_0x2F
;    1190 				tcplen = make16(packet[ip_pktlen],packet[ip_pktlen+1]) - \
;    1191 				((packet[ip_vers_len]&0x0F)<<2);
	__GETB1MN _packet,16
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,17
	POP  R26
	POP  R27
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETB1MN _packet,14
	ANDI R30,LOW(0xF)
	LSL  R30
	LSL  R30
	POP  R26
	POP  R27
	CLR  R31
	SUB  R26,R30
	SBC  R27,R31
	STS  _tcplen,R26
	STS  _tcplen+1,R27
;    1192 				hdr_chksum = hdr_chksum + tcplen;
	CALL SUBOPT_0x30
;    1193 				hdrlen = tcplen;
;    1194 				addr = &packet[TCP_srcport];
	__POINTW1MN _packet,34
	CALL SUBOPT_0xD
;    1195 				cksum();
;    1196 				chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
;    1197 				//write the checksum into the packet
;    1198 				packet[TCP_cksum] = make8(chksum16,1);
	CALL SUBOPT_0xE
	__PUTB1MN _packet,50
;    1199 				packet[TCP_cksum+1] = make8(chksum16,0);
	LDS  R30,_chksum16
	LDS  R31,_chksum16+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,51
;    1200 				//send the packet with the same data it came with
;    1201 				echo_packet();
	CALL _echo_packet
;    1202 			}
;    1203 		}
_0xCE:
;    1204 		//if we are waiting for an ack or waiting for data from the client we are connected to 
;    1205 		if((client[0]== packet[ip_srcaddr])&&(client[1]==packet[ip_srcaddr+1])&&(client[2]==packet[ip_srcaddr+2])&&(client[3]==packet[ip_srcaddr+3]))
	__GETB1MN _packet,26
	LDS  R26,_client
	CP   R30,R26
	BRNE _0xD5
	__GETB1MN _client,1
	PUSH R30
	__GETB1MN _packet,27
	POP  R26
	CP   R30,R26
	BRNE _0xD5
	__GETB1MN _client,2
	PUSH R30
	__GETB1MN _packet,28
	POP  R26
	CP   R30,R26
	BRNE _0xD5
	__GETB1MN _client,3
	PUSH R30
	__GETB1MN _packet,29
	POP  R26
	CP   R30,R26
	BREQ _0xD6
_0xD5:
	RJMP _0xD4
_0xD6:
;    1206 		{
;    1207 			//if an ack is received
;    1208 			if(ACK_IN)
	__GETB1MN _packet,47
	ANDI R30,LOW(0x10)
	BRNE PC+3
	JMP _0xD7
;    1209 			{
;    1210 				//assemble the acknowledgement number from the incoming packet
;    1211 				incoming_ack = make32(packet[TCP_acknum],packet[TCP_acknum+1],packet[TCP_acknum+2],packet[TCP_acknum+3]);
	__GETB1MN _packet,42
	CALL SUBOPT_0x27
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,43
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,44
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,45
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	STS  _incoming_ack,R30
	STS  _incoming_ack+1,R31
	STS  _incoming_ack+2,R22
	STS  _incoming_ack+3,R23
;    1212 				if(incoming_ack==expected_ack)
	LDS  R30,_expected_ack
	LDS  R31,_expected_ack+1
	LDS  R22,_expected_ack+2
	LDS  R23,_expected_ack+3
	LDS  R26,_incoming_ack
	LDS  R27,_incoming_ack+1
	LDS  R24,_incoming_ack+2
	LDS  R25,_incoming_ack+3
	CALL __CPD12
	BREQ PC+3
	JMP _0xD8
;    1213 				{
;    1214 					my_seqnum=incoming_ack;
	LDS  R30,_incoming_ack
	LDS  R31,_incoming_ack+1
	LDS  R22,_incoming_ack+2
	LDS  R23,_incoming_ack+3
	STS  _my_seqnum,R30
	STS  _my_seqnum+1,R31
	STS  _my_seqnum+2,R22
	STS  _my_seqnum+3,R23
;    1215 					//if it is the result of a close operations
;    1216 					//if the client is the one who initiated the close operation
;    1217 					if(closeflag==2)
	LDS  R26,_closeflag
	LDS  R27,_closeflag+1
	CPI  R26,LOW(0x2)
	LDI  R30,HIGH(0x2)
	CPC  R27,R30
	BRNE _0xD9
;    1218 						closeflag=0;
	CLR  R30
	STS  _closeflag,R30
	STS  _closeflag+1,R30
;    1219 					else if(closeflag==1)
	RJMP _0xDA
_0xD9:
	LDS  R26,_closeflag
	LDS  R27,_closeflag+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BRNE _0xDB
;    1220 						closeflag=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _closeflag,R30
	STS  _closeflag+1,R31
;    1221 					if(synflag_bit)
_0xDB:
_0xDA:
	SBRS R14,0
	RJMP _0xDC
;    1222 					{
;    1223 							clr_synflag;
	CALL SUBOPT_0x35
;    1224 							//next step is to wait for a "get" request
;    1225 					}
;    1226 					if(tcpdatalen_in)
_0xDC:
	LDS  R30,_tcpdatalen_in
	LDS  R31,_tcpdatalen_in+1
	SBIW R30,0
	BREQ _0xDD
;    1227 					{
;    1228 						//if the packet is more than we can handle, we just take the 1st 200 bytes of data
;    1229 						//and then ack the 200 bytres so that the client can resend the excluded data
;    1230 						if(tcpdatalen_in > 400)
	LDS  R26,_tcpdatalen_in
	LDS  R27,_tcpdatalen_in+1
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xDE
;    1231 							tcpdatalen_in=400;
	STS  _tcpdatalen_in,R30
	STS  _tcpdatalen_in+1,R31
;    1232 						ackflag=1;
_0xDE:
	CALL SUBOPT_0x36
;    1233 						http_server();
;    1234 					}
;    1235 					else
	RJMP _0xDF
_0xDD:
;    1236 					{
;    1237 						if(sendflag == 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0xE0
;    1238 						{
;    1239 							sendflag = 0;
	CLR  R8
	CLR  R9
;    1240 							ackflag = 1;
	CALL SUBOPT_0x36
;    1241 							//send next batch of data
;    1242 							http_server();
;    1243 						}
;    1244 					}
_0xE0:
_0xDF:
;    1245 				}
;    1246 				else if(incoming_ack<expected_ack)
	RJMP _0xE1
_0xD8:
	LDS  R30,_expected_ack
	LDS  R31,_expected_ack+1
	LDS  R22,_expected_ack+2
	LDS  R23,_expected_ack+3
	LDS  R26,_incoming_ack
	LDS  R27,_incoming_ack+1
	LDS  R24,_incoming_ack+2
	LDS  R25,_incoming_ack+3
	CALL __CPD21
	BRSH _0xE2
;    1247 				{
;    1248 					my_seqnum=expected_ack - (expected_ack - incoming_ack);
	CALL SUBOPT_0x37
	LDS  R26,_expected_ack
	LDS  R27,_expected_ack+1
	LDS  R24,_expected_ack+2
	LDS  R25,_expected_ack+3
	CALL __SWAPD12
	CALL __SUBD12
	STS  _my_seqnum,R30
	STS  _my_seqnum+1,R31
	STS  _my_seqnum+2,R22
	STS  _my_seqnum+3,R23
;    1249 					sendflag=0;
	CLR  R8
	CLR  R9
;    1250 					ackflag=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ackflag,R30
	STS  _ackflag+1,R31
;    1251 					pageendflag=0;
	CLR  R10
	CLR  R11
;    1252 					rollback=1;
	__PUTW1R 12,13
;    1253 					counter = counter - (expected_ack-incoming_ack);
	CALL SUBOPT_0x37
	LDS  R26,_counter
	LDS  R27,_counter+1
	CALL __CWD2
	CALL __SWAPD12
	CALL __SUBD12
	STS  _counter,R30
	STS  _counter+1,R31
;    1254 					//resend data
;    1255 					http_server();
	CALL _http_server
;    1256 				}
;    1257 			}
_0xE2:
_0xE1:
;    1258 			if(FIN_IN)
_0xD7:
	__GETB1MN _packet,47
	ANDI R30,LOW(0x1)
	BREQ _0xE3
;    1259 			{
;    1260 				ackflag=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ackflag,R30
	STS  _ackflag+1,R31
;    1261 				send_tcp_packet();
	RCALL _send_tcp_packet
;    1262 				if(closeflag==0)
	LDS  R30,_closeflag
	LDS  R31,_closeflag+1
	SBIW R30,0
	BRNE _0xE4
;    1263 				{
;    1264 					closeflag=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _closeflag,R30
	STS  _closeflag+1,R31
;    1265 				   	tcp_close();
	RCALL _tcp_close
;    1266 				}
;    1267 				else if(closeflag == 2)
	RJMP _0xE5
_0xE4:
	LDS  R26,_closeflag
	LDS  R27,_closeflag+1
	CPI  R26,LOW(0x2)
	LDI  R30,HIGH(0x2)
	CPC  R27,R30
	BRNE _0xE6
;    1268 					closeflag=0;
	CLR  R30
	STS  _closeflag,R30
	STS  _closeflag+1,R30
;    1269 			}
_0xE6:
_0xE5:
;    1270 		}
_0xE3:
;    1271 	}
_0xD4:
;    1272 }
_0xCB:
	RET
;    1273 
;    1274 //------------TCP CLOSE CONNECTION FUNCTION ----
;    1275 void tcp_close()
;    1276 {
_tcp_close:
;    1277 	set_finflag;
	CALL SUBOPT_0x38
;    1278 	tcpdatalen_out=0;
	CLR  R30
	STS  _tcpdatalen_out,R30
	STS  _tcpdatalen_out+1,R30
;    1279 	send_tcp_packet();
	RCALL _send_tcp_packet
;    1280 	closeflag++;
	LDS  R30,_closeflag
	LDS  R31,_closeflag+1
	ADIW R30,1
	STS  _closeflag,R30
	STS  _closeflag+1,R31
;    1281 }
	RET
;    1282 
;    1283 /*
;    1284 **********************************************************
;    1285 *  CHECKSUM CALCULATION ROUTINE
;    1286 * just add 16 bits to hdrchksum until you reach the end of hdrlen
;    1287 *********************************************************
;    1288 */
;    1289 void cksum()
;    1290 {
_cksum:
;    1291 	while(hdrlen>1)
_0xE9:
	LDS  R26,_hdrlen
	LDS  R27,_hdrlen+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xEB
;    1292 	{
;    1293 		//top 8 bits pointed to
;    1294 		data_H =*addr++;
	CALL SUBOPT_0x7
	STS  _data_H,R30
;    1295 		//next 8 bits pointed to
;    1296 		data_L =*addr++;
	CALL SUBOPT_0x7
	CALL SUBOPT_0x39
;    1297 		//converting the 2 bits together into a 16bit number
;    1298 		chksum16=make16(data_H,data_L);
;    1299 		//adding the 16bit number to itself (where is the 1s complement?!?)
;    1300 		hdr_chksum += chksum16;
;    1301 		//move along the header
;    1302 		hdrlen -= 2;
	LDS  R30,_hdrlen
	LDS  R31,_hdrlen+1
	SBIW R30,2
	STS  _hdrlen,R30
	STS  _hdrlen+1,R31
;    1303 	}
	RJMP _0xE9
_0xEB:
;    1304 	//when hdrlen = 1 (ie only 8 bits left)
;    1305 	if(hdrlen>0)
	LDS  R26,_hdrlen
	LDS  R27,_hdrlen+1
	CALL __CPW02
	BRSH _0xEC
;    1306 	{
;    1307 		data_H =*addr;
	LDS  R26,_addr
	LDS  R27,_addr+1
	LD   R30,X
	STS  _data_H,R30
;    1308 		data_L =0x00;
	CLR  R30
	CALL SUBOPT_0x39
;    1309 		chksum16 = make16(data_H,data_L);
;    1310 		hdr_chksum= hdr_chksum+chksum16;
;    1311 	}
;    1312 }
_0xEC:
	RET
;    1313 #include "ack.h"
;    1314 /*ack.c library source file
;    1315 created by Eric Mesa
;    1316 
;    1317 *********************************
;    1318 ver 0.1 10 Apr 2005
;    1319 created ack.c
;    1320 simply an implementation
;    1321 of what Jeremy had written
;    1322 without any extra optimizations
;    1323 outside of what we had fixed
;    1324 as of atmelwebserver.c ver 0.94.1
;    1325 *********************************
;    1326 
;    1327 goes along with ack.h
;    1328 header file
;    1329 */
;    1330 
;    1331 /*
;    1332 *****************************************************
;    1333 * Assemble the Acknowledgement
;    1334 * This function assembles the acknowledgement to send to
;    1335 * the client by adding the received data count to the 
;    1336 * client's incoming sequence number
;    1337 ******************************************************
;    1338 */
;    1339 
;    1340 void assemble_ack()
;    1341 {
_assemble_ack:
;    1342 	client_seqnum=make32(packet[TCP_seqnum],packet[TCP_seqnum+1], packet[TCP_seqnum+2], packet[TCP_seqnum+3]);
	__GETB1MN _packet,38
	CALL SUBOPT_0x27
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,39
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __LSLD16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,40
	CALL SUBOPT_0x28
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETB1MN _packet,41
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	STS  _client_seqnum,R30
	STS  _client_seqnum+1,R31
	STS  _client_seqnum+2,R22
	STS  _client_seqnum+3,R23
;    1343 	client_seqnum += tcpdatalen_in;
	LDS  R30,_tcpdatalen_in
	LDS  R31,_tcpdatalen_in+1
	LDS  R26,_client_seqnum
	LDS  R27,_client_seqnum+1
	LDS  R24,_client_seqnum+2
	LDS  R25,_client_seqnum+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _client_seqnum,R30
	STS  _client_seqnum+1,R31
	STS  _client_seqnum+2,R22
	STS  _client_seqnum+3,R23
;    1344 	set_packet32(TCP_acknum,client_seqnum);
	LDS  R30,_client_seqnum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,42
	LDS  R30,_client_seqnum
	LDS  R31,_client_seqnum+1
	LDS  R22,_client_seqnum+2
	LDS  R23,_client_seqnum+3
	CALL __LSRD16
	__ANDD1N 0xFF
	__PUTB1MN _packet,43
	LDS  R30,_client_seqnum
	LDS  R31,_client_seqnum+1
	MOV  R30,R31
	__ANDD1N 0xFF
	__PUTB1MN _packet,44
	LDS  R30,_client_seqnum
	LDS  R31,_client_seqnum+1
	LDS  R22,_client_seqnum+2
	LDS  R23,_client_seqnum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,45
;    1345 }
	RET
;    1346 #include "tcpsend.h"
;    1347 /*tcpsend.c library source file
;    1348 created by Eric Mesa
;    1349 
;    1350 *********************************
;    1351 ver 0.1 10 Apr 2005
;    1352 created tcpsend.c
;    1353 simply an implementation
;    1354 of what Jeremy had written
;    1355 without any extra optimizations
;    1356 outside of what we had fixed
;    1357 as of atmelwebserver.c ver 0.94.1
;    1358 *********************************
;    1359 
;    1360 goes along with tcpsend.h
;    1361 header file
;    1362 
;    1363 we may want to eventually combine this with tcp.c
;    1364 */
;    1365 
;    1366 /*
;    1367 ******************************************************
;    1368 * Send TCP Packet
;    1369 * This routine assembles and sends a complete TCP/IP packet
;    1370 * 40 bytes of IP and TCP header data is assumed (no options)
;    1371 ******************************************************
;    1372 */
;    1373 
;    1374 void send_tcp_packet()
;    1375 {
_send_tcp_packet:
;    1376 	unsigned int i;
;    1377 	//count IP and TCP header bytes  Total = 40 bytes
;    1378 	if(tcpdatalen_out == 0)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDS  R30,_tcpdatalen_out
	LDS  R31,_tcpdatalen_out+1
	SBIW R30,0
	BRNE _0xF2
;    1379 	{
;    1380 		tcpdatalen_out=14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	STS  _tcpdatalen_out,R30
	STS  _tcpdatalen_out+1,R31
;    1381 		for(i=0;i<14;i++)
	__GETWRN 16,17,0
_0xF4:
	__CPWRN 16,17,14
	BRSH _0xF5
;    1382 			packet[TCP_options+i]=0;
	__GETW1R 16,17
	ADIW R30,54
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	CALL SUBOPT_0x2D
	__ADDWRN 16,17,1
	RJMP _0xF4
_0xF5:
;    1383 		expected_ack=my_seqnum+1;
	LDS  R30,_my_seqnum
	LDS  R31,_my_seqnum+1
	LDS  R22,_my_seqnum+2
	LDS  R23,_my_seqnum+3
	__ADDD1N 1
	RJMP _0x1AA
;    1384 	}
;    1385 	else
_0xF2:
;    1386 		expected_ack=my_seqnum+tcpdatalen_out;
	LDS  R30,_tcpdatalen_out
	LDS  R31,_tcpdatalen_out+1
	LDS  R26,_my_seqnum
	LDS  R27,_my_seqnum+1
	LDS  R24,_my_seqnum+2
	LDS  R25,_my_seqnum+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
_0x1AA:
	STS  _expected_ack,R30
	STS  _expected_ack+1,R31
	STS  _expected_ack+2,R22
	STS  _expected_ack+3,R23
;    1387 	
;    1388 	ip_packet_len = 40 + tcpdatalen_out;
	LDS  R30,_tcpdatalen_out
	LDS  R31,_tcpdatalen_out+1
	ADIW R30,40
	STS  _ip_packet_len,R30
	STS  _ip_packet_len+1,R31
;    1389 	packet[ip_pktlen] = make8(ip_packet_len,1);
	CALL SUBOPT_0x15
	__PUTB1MN _packet,16
;    1390 	packet[ip_pktlen + 1] = make8(ip_packet_len,0);
	LDS  R30,_ip_packet_len
	LDS  R31,_ip_packet_len+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,17
;    1391 	packet[ip_proto] = PROT_TCP;
	LDI  R30,LOW(6)
	__PUTB1MN _packet,23
;    1392 	setipaddrs();
	CALL _setipaddrs
;    1393 	data_L = packet[TCP_srcport];
	__GETB1MN _packet,34
	STS  _data_L,R30
;    1394 	packet[TCP_srcport] = packet[TCP_destport];
	__GETB1MN _packet,36
	__PUTB1MN _packet,34
;    1395 	packet[TCP_destport] = data_L;
	__POINTW2MN _packet,36
	LDS  R30,_data_L
	ST   X,R30
;    1396 	data_L = packet[TCP_srcport+1];
	__GETB1MN _packet,35
	STS  _data_L,R30
;    1397 	packet[TCP_srcport+1] = packet[TCP_destport + 1];
	__GETB1MN _packet,37
	__PUTB1MN _packet,35
;    1398 	packet[TCP_destport+1] = data_L;
	__POINTW2MN _packet,37
	CALL SUBOPT_0x31
;    1399 	assemble_ack();
;    1400 	set_packet32(TCP_seqnum,my_seqnum);
	LDS  R30,_my_seqnum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,38
	CALL SUBOPT_0x33
	__PUTB1MN _packet,39
	CALL SUBOPT_0x34
	__PUTB1MN _packet,40
	LDS  R30,_my_seqnum
	LDS  R31,_my_seqnum+1
	LDS  R22,_my_seqnum+2
	LDS  R23,_my_seqnum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,41
;    1401 	
;    1402 	packet[TCP_hdrflags+1]=0x00;
	CLR  R30
	__PUTB1MN _packet,47
;    1403 	if(ackflag = 1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ackflag,R30
	STS  _ackflag+1,R31
	SBIW R30,0
	BREQ _0xF7
;    1404 		ACK_OUT;
	__POINTW1MN _packet,47
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,0x10
	POP  R26
	POP  R27
	RJMP _0x1AB
;    1405 	else
_0xF7:
;    1406 		NO_ACK;
	__POINTW1MN _packet,47
	PUSH R31
	PUSH R30
	LD   R30,Z
	ANDI R30,LOW(0x47)
	POP  R26
	POP  R27
_0x1AB:
	ST   X,R30
;    1407 	
;    1408 	ackflag = 0;
	CLR  R30
	STS  _ackflag,R30
	STS  _ackflag+1,R30
;    1409 	
;    1410 	if(flags & finflag)
	SBRS R14,1
	RJMP _0xF9
;    1411 	{
;    1412 		FIN_OUT;
	__POINTW1MN _packet,47
	PUSH R31
	PUSH R30
	LD   R30,Z
	ORI  R30,1
	POP  R26
	POP  R27
	ST   X,R30
;    1413 		clr_finflag;
	CALL SUBOPT_0x3A
;    1414 	}
;    1415 	
;    1416 	packet[TCP_cksum] = 0x00;
_0xF9:
	CLR  R30
	__PUTB1MN _packet,50
;    1417 	packet[TCP_cksum + 1] = 0x00;
	__PUTB1MN _packet,51
;    1418 	
;    1419 	hdr_chksum = 0;
	CALL SUBOPT_0x10
;    1420 	hdrlen = 0x08;
;    1421 	addr = &packet[ip_srcaddr];
	__POINTW1MN _packet,26
	STS  _addr,R30
	STS  _addr+1,R31
;    1422 	cksum();
	CALL _cksum
;    1423 	hdr_chksum += packet[ip_proto];
	__GETB1MN _packet,23
	CALL SUBOPT_0x2F
;    1424 	tcplen = ip_packet_len - ((packet[ip_vers_len]& 0x0F)<<2);
	__GETB1MN _packet,14
	CALL SUBOPT_0x2E
;    1425 	hdr_chksum=hdr_chksum+tcplen;
	CALL SUBOPT_0x30
;    1426 	hdrlen = tcplen;
;    1427 	addr = &packet[TCP_srcport];
	__POINTW1MN _packet,34
	CALL SUBOPT_0xD
;    1428 	cksum();
;    1429 	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000)>>16));
;    1430 	packet[TCP_cksum] = make8(chksum16,1);
	CALL SUBOPT_0xE
	__PUTB1MN _packet,50
;    1431 	packet[TCP_cksum + 1] = make8(chksum16,0);
	LDS  R30,_chksum16
	LDS  R31,_chksum16+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,51
;    1432 	
;    1433 	txlen = ip_packet_len + 14;
	CALL SUBOPT_0x17
;    1434 	if(txlen<60)
	BRSH _0xFA
;    1435 		txlen = 60;
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	STS  _txlen,R30
	STS  _txlen+1,R31
;    1436 	data_L = make8(txlen,0);
_0xFA:
	CALL SUBOPT_0x18
;    1437 	data_H = make8(txlen,1);
;    1438 	write_rtl(CR,0x22);
;    1439 	read_rtl(CR);
;    1440 	while(byte_read&0x04)
_0xFB:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x4)
	BREQ _0xFD
;    1441 		read_rtl(CR);
	CALL SUBOPT_0x19
	RJMP _0xFB
_0xFD:
;    1442 	
;    1443 	write_rtl(TPSR,txstart);
	CALL SUBOPT_0x1A
;    1444 	write_rtl(RSAR0,0x00);
;    1445 	write_rtl(RSAR1,0x40);
	CALL SUBOPT_0x1B
;    1446 	write_rtl(ISR,0xFF);
;    1447 	write_rtl(RBCR0,data_L);
;    1448 	write_rtl(RBCR1,data_H);
;    1449 	write_rtl(CR,0x12);
;    1450 	
;    1451 	for(i=0;i<txlen;++i)
	__GETWRN 16,17,0
_0xFF:
	LDS  R30,_txlen
	LDS  R31,_txlen+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x100
;    1452 		write_rtl(RDMAPORT,packet[enetpacketDest0+i]);
	CALL SUBOPT_0x1C
	__ADDWRN 16,17,1
	RJMP _0xFF
_0x100:
;    1453 		
;    1454 	byte_read = 0;
	CLR  R30
	STS  _byte_read,R30
;    1455 	while(!(byte_read & RDC))
_0x101:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x40)
	BRNE _0x103
;    1456 		read_rtl(ISR);
	CALL SUBOPT_0xA
	RJMP _0x101
_0x103:
;    1457 	
;    1458 	write_rtl(TBCR0,data_L);
	CALL SUBOPT_0x1D
;    1459 	write_rtl(TBCR1,data_H);
;    1460 	write_rtl(CR,0x24);
;    1461 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1462 
;    1463 //for sending the html
;    1464 unsigned int pack_html(unsigned char flash *req_page, unsigned int req_offset)
;    1465 {
_pack_html:
;    1466 	unsigned char i;
;    1467 	unsigned char flash *start;
;    1468 	unsigned char flash *cursor;
;    1469 
;    1470 	// place cursor at start of data to send
;    1471 	start = req_page+req_offset;
	SBIW R28,4
	ST   -Y,R16
;	*req_page -> Y+7
;	req_offset -> Y+5
;	i -> R16
;	*start -> Y+3
;	*cursor -> Y+1
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
;    1472 	cursor = start;
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1473 
;    1474 	// send portion of data
;    1475 	for(i=0; i<100; i++)
	LDI  R16,LOW(0)
_0x106:
	CPI  R16,100
	BRLO PC+3
	JMP _0x107
;    1476 	{
;    1477 		packet[TCP_data+i] = *cursor;
	MOV  R30,R16
	SUBI R30,-LOW(66)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	PUSH R31
	PUSH R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
;    1478 		// advance cursor
;    1479 		++cursor;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
;    1480 		if(req_page != favicon)
	LDI  R30,LOW(_favicon*2)
	LDI  R31,HIGH(_favicon*2)
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x108
;    1481 		{
;    1482 			// check if end of page
;    1483 			if(*cursor == '\0')
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x109
;    1484 			{
;    1485 				packet[TCP_data+i+1] = "\0";
	CALL SUBOPT_0x3B
	PUSH R31
	PUSH R30
	__POINTW1FN _260,0
	POP  R26
	POP  R27
	ST   X,R30
;    1486 				break;
	RJMP _0x107
;    1487 			}
;    1488 		}
_0x109:
;    1489 		else
	RJMP _0x10A
_0x108:
;    1490 		{
;    1491 			// check if end of page
;    1492 			if((cursor-req_page) > page_size)
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUB  R30,R26
	SBC  R31,R27
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x10B
;    1493 			{
;    1494 				packet[TCP_data+i+1] = "\0";
	CALL SUBOPT_0x3B
	PUSH R31
	PUSH R30
	__POINTW1FN _260,2
	POP  R26
	POP  R27
	ST   X,R30
;    1495 				break;
	RJMP _0x107
;    1496 			}
;    1497 		}
_0x10B:
_0x10A:
;    1498 	}
	SUBI R16,-1
	RJMP _0x106
_0x107:
;    1499 
;    1500 	// return amount of data
;    1501 	tcpdatalen_out = cursor-start;
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _tcpdatalen_out,R30
	STS  _tcpdatalen_out+1,R31
;    1502 	return tcpdatalen_out;
	LDD  R16,Y+0
	ADIW R28,9
	RET
;    1503 }
;    1504 #include "nic.h"
;    1505 /*nic.c library source file
;    1506 created by Eric Mesa
;    1507 
;    1508 *********************************
;    1509 ver 0.1 10 Apr 2005
;    1510 created nic.c
;    1511 simply an implementation
;    1512 of what Jeremy had written
;    1513 without any extra optimizations
;    1514 outside of what we had fixed
;    1515 as of atmelwebserver.c ver 0.94.1
;    1516 *********************************
;    1517 
;    1518 goes along with nic.h
;    1519 header file
;    1520 */
;    1521 
;    1522 /*
;    1523 *******************************************************
;    1524 * Write to NIC Control Register
;    1525 *******************************************************
;    1526 */
;    1527 
;    1528 void write_rtl(unsigned char regaddr, unsigned char regdata)
;    1529 {
_write_rtl:
;    1530 	//write the regaddr into PORTB
;    1531 	rtladdr = regaddr;
	LDD  R30,Y+1
	OUT  0x18,R30
;    1532 	tortl;
	LDI  R30,LOW(255)
	OUT  0x14,R30
;    1533 	//write data into PORTC
;    1534 	rtldata = regdata;
	LD   R30,Y
	OUT  0x15,R30
;    1535 	#asm
;    1536 		nop
		nop
;    1537 	#endasm

;    1538 	//toggle write pin
;    1539 	clr_iow_pin;
	CBI  0x12,7
;    1540 	#asm
;    1541 		nop
		nop
;    1542 		nop
		nop
;    1543 		nop
		nop
;    1544 	#endasm

;    1545 	set_iow_pin;
	SBI  0x12,7
;    1546 	#asm
;    1547 		nop
		nop
;    1548 	#endasm

;    1549 	//set data port back to input
;    1550 	fromrtl;
	CALL SUBOPT_0x3C
;    1551 	PORTC = 0xFF;
;    1552 }
	ADIW R28,2
	RET
;    1553 
;    1554 /*
;    1555 *******************************************************
;    1556 * Read From NIC Control Register
;    1557 *******************************************************
;    1558 */
;    1559 
;    1560 void read_rtl(unsigned char regaddr)
;    1561 {
_read_rtl:
;    1562 	fromrtl;
	CALL SUBOPT_0x3C
;    1563 	PORTC = 0xFF;
;    1564 	rtladdr = regaddr;
	LD   R30,Y
	OUT  0x18,R30
;    1565 	clr_ior_pin;
	CBI  0x12,6
;    1566 	#asm
;    1567 		nop
		nop
;    1568 	#endasm

;    1569 	#asm
;    1570 		nop
		nop
;    1571 		nop
		nop
;    1572 		nop
		nop
;    1573 	#endasm

;    1574 	byte_read = PINC;
	IN   R30,0x13
	STS  _byte_read,R30
;    1575 	set_ior_pin;
	SBI  0x12,6
;    1576 	#asm
;    1577 		nop
		nop
;    1578 	#endasm

;    1579 }
	ADIW R28,1
	RET
;    1580 
;    1581 /*
;    1582 //**********************************************************
;    1583 //* Initialize the RTL8019AS
;    1584 //************************************************************
;    1585 */
;    1586 
;    1587 void init_RTL8019AS()
;    1588 {
_init_RTL8019AS:
;    1589 	unsigned char i;
;    1590 	fromrtl;	//PORTC data lines = input
	ST   -Y,R16
;	i -> R16
	CALL SUBOPT_0x3C
;    1591 	PORTC = 0xFF;
;    1592 	DDRB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;    1593 	rtladdr = 0x00; //clear address lines
	CLR  R30
	OUT  0x18,R30
;    1594 	DDRA = 0x00; 	//PORTA is an input
	OUT  0x1A,R30
;    1595 	//DDRA = 0xFF;
;    1596 	DDRD = 0xE0;	//setup IOW, IOR, EEPROM,RXD,TXD,CTS
	LDI  R30,LOW(224)
	OUT  0x11,R30
;    1597 	PORTD = 0x1F; 	//enable pullups on input pins
	LDI  R30,LOW(31)
	OUT  0x12,R30
;    1598 	clr_EEDO;
	CBI  0x12,5
;    1599 	set_iow_pin;	//disable IOW
	SBI  0x12,7
;    1600 	set_ior_pin; 	//disable IOR
	SBI  0x12,6
;    1601 	set_rst_pin;	//put NIC in reset
	SBI  0x18,7
;    1602 	delay_ms(2);	//delay at least 1.6 ms
	CALL SUBOPT_0x3D
;    1603 	clr_rst_pin;	//disable reset line
	CBI  0x18,7
;    1604 	
;    1605 	read_rtl(RSTPORT);	//read contents of reset port
	LDI  R30,LOW(24)
	ST   -Y,R30
	CALL _read_rtl
;    1606 	write_rtl(RSTPORT,byte_read); //do soft reset
	LDI  R30,LOW(24)
	ST   -Y,R30
	LDS  R30,_byte_read
	ST   -Y,R30
	CALL _write_rtl
;    1607 	delay_ms(20);	//give it time
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    1608 	read_rtl(ISR);	//check for good soft reset
	CALL SUBOPT_0xA
;    1609 	
;    1610 	if(!(byte_read & RST))
	LDS  R30,_byte_read
	ANDI R30,LOW(0x80)
	BRNE _0x112
;    1611 	{
;    1612 		//for(i=0;i<sizeof(msg_initfail)-1;++i)
;    1613 		//{
;    1614 			//delay_ms1(1);
;    1615 			//lcd_send_byte(1,msg_initfail[i]);
;    1616 		//}
;    1617 	}
;    1618 	write_rtl(CR,0x21);	//stop the NIC,abort DMA,page 0
_0x112:
	CALL SUBOPT_0x3E
;    1619 	delay_ms(2);		//make sure nothing is coming in or going out
	CALL SUBOPT_0x3D
;    1620 	write_rtl(DCR,dcrval);	//0x58
	CALL SUBOPT_0x3F
;    1621 	write_rtl(RBCR0,0x00);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x9
;    1622 	write_rtl(RBCR1,0x00);
	CALL SUBOPT_0x2
;    1623 	write_rtl(RCR,0x04);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _write_rtl
;    1624 	write_rtl(TPSR,txstart);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(64)
	CALL SUBOPT_0x40
;    1625 	write_rtl(TCR,0x02);
	CALL SUBOPT_0x41
;    1626 	write_rtl(PSTART,rxstart);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x42
;    1627 	write_rtl(BNRY,rxstart);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x42
;    1628 	write_rtl(PSTOP,rxstop);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(96)
	ST   -Y,R30
	CALL _write_rtl
;    1629 	write_rtl(CR,0x61);
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(97)
	ST   -Y,R30
	CALL _write_rtl
;    1630 	delay_ms(2);
	CALL SUBOPT_0x3D
;    1631 	write_rtl(CURR,rxstart);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x42
;    1632 	for(i=0;i<6;++i)
	LDI  R16,LOW(0)
_0x114:
	CPI  R16,6
	BRSH _0x115
;    1633 		write_rtl(PAR0+i,MYMAC[i]);
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	MOV  R30,R16
	CALL SUBOPT_0x6
	SUBI R16,-LOW(1)
	RJMP _0x114
_0x115:
;    1634 		
;    1635 	write_rtl(CR,0x21);
	CALL SUBOPT_0x3E
;    1636 	write_rtl(DCR,dcrval);
	CALL SUBOPT_0x3F
;    1637 	write_rtl(CR,0x22);
	CALL SUBOPT_0x43
;    1638 	write_rtl(ISR,0xFF);
	CALL SUBOPT_0x44
;    1639 	write_rtl(IMR,imrval);
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(17)
	CALL SUBOPT_0x40
;    1640 	write_rtl(TCR,tcrval);
	CALL SUBOPT_0x9
;    1641 	write_rtl(CR,0x22);
	CALL SUBOPT_0x43
;    1642 }
	LD   R16,Y+
	RET
;    1643 #include "ringbuff.h"
;    1644 /*ringbuff.c library source file
;    1645 created by Eric Mesa
;    1646 
;    1647 *********************************
;    1648 ver 0.1 13 Apr 2005
;    1649 created ringbuff.c
;    1650 simply an implementation
;    1651 of what Jeremy had written
;    1652 without any extra optimizations
;    1653 outside of what we had fixed
;    1654 as of atmelwebserver.c ver 0.94.1
;    1655 *********************************
;    1656 
;    1657 goes along with ringbuff.h
;    1658 header file
;    1659 */
;    1660 
;    1661 /*
;    1662 ******************************************************
;    1663 * Handle Receive Ring Buffer Overrun
;    1664 * No packets are recovered
;    1665 *******************************************************
;    1666 */
;    1667 
;    1668 void overrun()
;    1669 {
_overrun:
;    1670 	read_rtl(CR);
	CALL SUBOPT_0x19
;    1671 	data_L = byte_read;
	LDS  R30,_byte_read
	STS  _data_L,R30
;    1672 	write_rtl(CR,0x21);
	CALL SUBOPT_0x3E
;    1673 	delay_ms(2);
	CALL SUBOPT_0x3D
;    1674 	write_rtl(RBCR0,0x00);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x9
;    1675 	write_rtl(RBCR1,0x00);
	CALL SUBOPT_0x2
;    1676 	if(!(data_L&0x04))
	LDS  R30,_data_L
	ANDI R30,LOW(0x4)
	BRNE _0x118
;    1677 		resend = 0;
	CLR  R30
	STS  _resend,R30
;    1678 	else if(data_L & 0x04)
	RJMP _0x119
_0x118:
	LDS  R30,_data_L
	ANDI R30,LOW(0x4)
	BREQ _0x11A
;    1679 	{
;    1680 		read_rtl(ISR);
	CALL SUBOPT_0xA
;    1681 		data_L = byte_read;
	LDS  R30,_byte_read
	STS  _data_L,R30
;    1682 		if((data_L&0x02) || (data_L & 0x08))
	ANDI R30,LOW(0x2)
	BRNE _0x11C
	LDS  R30,_data_L
	ANDI R30,LOW(0x8)
	BREQ _0x11B
_0x11C:
;    1683 			resend = 0;
	CLR  R30
	RJMP _0x1AC
;    1684 		else
_0x11B:
;    1685 			resend = 1;
	LDI  R30,LOW(1)
_0x1AC:
	STS  _resend,R30
;    1686 	}
;    1687 	
;    1688 	write_rtl(TCR,0x02);
_0x11A:
_0x119:
	LDI  R30,LOW(13)
	CALL SUBOPT_0x41
;    1689 	write_rtl(CR,0x22);
	CALL SUBOPT_0x43
;    1690 	write_rtl(BNRY,rxstart);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x42
;    1691 	write_rtl(CR,0x62);
	CALL SUBOPT_0x45
;    1692 	write_rtl(CURR,rxstart);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x42
;    1693 	write_rtl(CR,0x22);
	CALL SUBOPT_0x43
;    1694 	write_rtl(ISR,0x10);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(16)
	CALL SUBOPT_0x40
;    1695 	write_rtl(TCR,tcrval);
	CALL SUBOPT_0x9
;    1696 }
	RET
;    1697 #include "echo.h"
;    1698 /*echo.c library source file
;    1699 created by Eric Mesa
;    1700 
;    1701 *********************************
;    1702 ver 0.1 10 Apr 2005
;    1703 created echo.c
;    1704 simply an implementation
;    1705 of what Jeremy had written
;    1706 without any extra optimizations
;    1707 outside of what we had fixed
;    1708 as of atmelwebserver.c ver 0.94.1
;    1709 *********************************
;    1710 
;    1711 goes along with echo.h
;    1712 header file
;    1713 */
;    1714 
;    1715 /*
;    1716 ******************************************************
;    1717 * Echo Packet Function
;    1718 * This routine does not modify the incoming packet size and
;    1719 * thus echoes the original packet structure
;    1720 ********************************************************
;    1721 */
;    1722 
;    1723 void echo_packet()
;    1724 {
_echo_packet:
;    1725 	unsigned int i;
;    1726 	write_rtl(CR,0x22);
	ST   -Y,R17
	CALL SUBOPT_0x0
;	i -> R16,R17
;    1727 	write_rtl(TPSR,txstart);
;    1728 	write_rtl(RSAR0,0x00);
;    1729 	write_rtl(RSAR1,0x40);
;    1730 	write_rtl(ISR,0xFF);
;    1731 	write_rtl(RBCR0,pageheader[enetpacketLenL]-4);
	__GETB1MN _pageheader,2
	CALL SUBOPT_0x46
;    1732 	write_rtl(RBCR1,pageheader[enetpacketLenH]);
	LDI  R30,LOW(11)
	ST   -Y,R30
	__GETB1MN _pageheader,3
	ST   -Y,R30
	CALL _write_rtl
;    1733 	write_rtl(CR,0x12);
	CALL SUBOPT_0x3
;    1734 	
;    1735 	txlen = make16(pageheader[enetpacketLenH],pageheader[enetpacketLenL])-4;
	__GETB1MN _pageheader,3
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _pageheader,2
	POP  R26
	POP  R27
	CLR  R31
	ADD  R26,R30
	ADC  R27,R31
	SBIW R26,4
	STS  _txlen,R26
	STS  _txlen+1,R27
;    1736 	for(i=0;i<txlen;++i)
	__GETWRN 16,17,0
_0x122:
	LDS  R30,_txlen
	LDS  R31,_txlen+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x123
;    1737 		write_rtl(RDMAPORT,packet[enetpacketDest0+i]);
	CALL SUBOPT_0x1C
	__ADDWRN 16,17,1
	RJMP _0x122
_0x123:
;    1738 	
;    1739 	byte_read = 0;
	CLR  R30
	STS  _byte_read,R30
;    1740 	while(!(byte_read&RDC))
_0x124:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x40)
	BRNE _0x126
;    1741 		read_rtl(ISR);
	CALL SUBOPT_0xA
	RJMP _0x124
_0x126:
;    1742 		
;    1743 	write_rtl(TBCR0,pageheader[enetpacketLenL]-4);
	LDI  R30,LOW(5)
	ST   -Y,R30
	__GETB1MN _pageheader,2
	CALL SUBOPT_0x46
;    1744 	write_rtl(TBCR1,pageheader[enetpacketLenH]);
	LDI  R30,LOW(6)
	ST   -Y,R30
	__GETB1MN _pageheader,3
	ST   -Y,R30
	CALL _write_rtl
;    1745 	write_rtl(CR,0x24);
	CALL SUBOPT_0xB
;    1746 }
	RJMP _0x1A8
;    1747 #include "ring.h"
;    1748 /*ring.c library source file
;    1749 created by Eric Mesa
;    1750 
;    1751 *********************************
;    1752 ver 0.1 13 Apr 2005
;    1753 created ring.c
;    1754 simply an implementation
;    1755 of what Jeremy had written
;    1756 without any extra optimizations
;    1757 outside of what we had fixed
;    1758 as of atmelwebserver.c ver 0.94.1
;    1759 *********************************
;    1760 
;    1761 goes along with ring.h
;    1762 header file
;    1763 */
;    1764 
;    1765 /*
;    1766 *****************************************************
;    1767 * Get A Packet From the Ring
;    1768 * This routine removes data packet from the receive buffer
;    1769 * ring
;    1770 *******************************************************
;    1771 */
;    1772 
;    1773 void get_packet()
;    1774 {
_get_packet:
;    1775 	unsigned int i;
;    1776 	//execute a send packet command to retrieve the packet
;    1777 	write_rtl(CR,0x1A);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(26)
	ST   -Y,R30
	CALL _write_rtl
;    1778 	for(i=0;i<4;++i)
	__GETWRN 16,17,0
_0x12A:
	__CPWRN 16,17,4
	BRSH _0x12B
;    1779 	{
;    1780 		read_rtl(RDMAPORT);
	CALL SUBOPT_0x47
;    1781 		pageheader[i]=byte_read;
	__GETW1R 16,17
	SUBI R30,LOW(-_pageheader)
	SBCI R31,HIGH(-_pageheader)
	CALL SUBOPT_0x48
;    1782 	}
	__ADDWRN 16,17,1
	RJMP _0x12A
_0x12B:
;    1783 	rxlen = make16(pageheader[enetpacketLenH],pageheader[enetpacketLenL]);
	__GETB1MN _pageheader,3
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _pageheader,2
	POP  R26
	POP  R27
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	STS  _rxlen,R30
	STS  _rxlen+1,R31
;    1784 	
;    1785 	for(i=0;i<rxlen;++i)
	__GETWRN 16,17,0
_0x12D:
	LDS  R30,_rxlen
	LDS  R31,_rxlen+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x12E
;    1786 	{
;    1787 		read_rtl(RDMAPORT);
	CALL SUBOPT_0x47
;    1788 		//dump any bytes that wil overrun the receive buffer  (which is probably > 1kb)
;    1789 		if(i<700)
	__CPWRN 16,17,700
	BRSH _0x12F
;    1790 			packet[i]=byte_read;
	__GETW1R 16,17
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	CALL SUBOPT_0x48
;    1791 	}
_0x12F:
	__ADDWRN 16,17,1
	RJMP _0x12D
_0x12E:
;    1792 	//changed from * to & typeo 7 Apr 2005
;    1793 	while(!(byte_read & RDC))
_0x130:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x40)
	BRNE _0x132
;    1794 		read_rtl(ISR);
	CALL SUBOPT_0xA
	RJMP _0x130
_0x132:
;    1795 	write_rtl(ISR,0xFF);
	CALL SUBOPT_0x44
;    1796 	
;    1797 	//process an ARP packet
;    1798 	if(packet[enetpacketType0] == 0x08 && packet[enetpacketType1] == 0x06)
	__GETB1MN _packet,12
	CPI  R30,LOW(0x8)
	BRNE _0x134
	__GETB1MN _packet,13
	CPI  R30,LOW(0x6)
	BREQ _0x135
_0x134:
	RJMP _0x133
_0x135:
;    1799 	{
;    1800 		if(packet[arp_hwtype+1]==0x01 && packet[arp_prtype] == 0x08 && packet[arp_prtype+1] == 0x00 && packet[arp_hwlen] == 0x06 && packet[arp_prlen] == 0x04 && packet[arp_op+1] == 0x01 && MYIP[0] == packet[arp_tipaddr] && MYIP[1] == packet[arp_tipaddr+1] && MYIP[2] == packet[arp_tipaddr+2] && MYIP[3] == packet[arp_tipaddr+3])
	__GETB1MN _packet,15
	CPI  R30,LOW(0x1)
	BRNE _0x137
	__GETB1MN _packet,16
	CPI  R30,LOW(0x8)
	BRNE _0x137
	__GETB1MN _packet,17
	CPI  R30,0
	BRNE _0x137
	__GETB1MN _packet,18
	CPI  R30,LOW(0x6)
	BRNE _0x137
	__GETB1MN _packet,19
	CPI  R30,LOW(0x4)
	BRNE _0x137
	__GETB1MN _packet,21
	CPI  R30,LOW(0x1)
	BRNE _0x137
	__GETB1MN _packet,38
	LDS  R26,_MYIP
	CP   R30,R26
	BRNE _0x137
	__GETB1MN _MYIP,1
	PUSH R30
	__GETB1MN _packet,39
	POP  R26
	CP   R30,R26
	BRNE _0x137
	__GETB1MN _MYIP,2
	PUSH R30
	__GETB1MN _packet,40
	POP  R26
	CP   R30,R26
	BRNE _0x137
	__GETB1MN _MYIP,3
	PUSH R30
	__GETB1MN _packet,41
	POP  R26
	CP   R30,R26
	BREQ _0x138
_0x137:
	RJMP _0x136
_0x138:
;    1801 			arp();
	CALL _arp
;    1802 	}
_0x136:
;    1803 	//process an IP packet
;    1804 	else if(packet[enetpacketType0] == 0x08 && packet[enetpacketType1] == 0x00 && packet[ip_destaddr] == MYIP[0] && packet[ip_destaddr+1] == MYIP[1] && packet[ip_destaddr+2] == MYIP[2] && packet[ip_destaddr+3] == MYIP[3])
	RJMP _0x139
_0x133:
	__GETB1MN _packet,12
	CPI  R30,LOW(0x8)
	BRNE _0x13B
	__GETB1MN _packet,13
	CPI  R30,0
	BRNE _0x13B
	__GETB2MN _packet,30
	LDS  R30,_MYIP
	CP   R30,R26
	BRNE _0x13B
	__GETB1MN _packet,31
	PUSH R30
	__GETB1MN _MYIP,1
	POP  R26
	CP   R30,R26
	BRNE _0x13B
	__GETB1MN _packet,32
	PUSH R30
	__GETB1MN _MYIP,2
	POP  R26
	CP   R30,R26
	BRNE _0x13B
	__GETB1MN _packet,33
	PUSH R30
	__GETB1MN _MYIP,3
	POP  R26
	CP   R30,R26
	BREQ _0x13C
_0x13B:
	RJMP _0x13A
_0x13C:
;    1805 	{
;    1806 		//do a checksum of the ipheader
;    1807 		ic_chksum = make16(packet[ip_hdr_cksum],packet[ip_hdr_cksum+1]);
	__GETB1MN _packet,24
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,25
	POP  R26
	POP  R27
	CALL SUBOPT_0xF
;    1808 		packet[ip_hdr_cksum] = 0x00;
	__PUTB1MN _packet,24
;    1809 		packet[ip_hdr_cksum+1] = 0x00;
	CLR  R30
	__PUTB1MN _packet,25
;    1810 		hdr_chksum = 0;
	CLR  R30
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R30
	STS  _hdr_chksum+2,R30
	STS  _hdr_chksum+3,R30
;    1811 		chksum16 = 0;
	CLR  R30
	STS  _chksum16,R30
	STS  _chksum16+1,R30
;    1812 		hdrlen = (packet[ip_vers_len] & 0x0F) << 2;
	__GETB1MN _packet,14
	CALL SUBOPT_0x16
;    1813 		addr = &packet[ip_vers_len];
	__POINTW1MN _packet,14
	CALL SUBOPT_0xD
;    1814 		cksum();
;    1815 		chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000) >> 16));
;    1816 		
;    1817 		if(chksum16 == ic_chksum)
	CALL SUBOPT_0x13
	BRNE _0x13D
;    1818 		{
;    1819 			packet[ip_hdr_cksum] = make8(ic_chksum,1);
	LDS  R30,_ic_chksum
	LDS  R31,_ic_chksum+1
	MOV  R30,R31
	__ANDD1N 0xFF
	__PUTB1MN _packet,24
;    1820 			packet[ip_hdr_cksum+1] = make8(ic_chksum,0);
	LDS  R30,_ic_chksum
	LDS  R31,_ic_chksum+1
	LDS  R22,_ic_chksum+2
	LDS  R23,_ic_chksum+3
	__ANDD1N 0xFF
	__PUTB1MN _packet,25
;    1821 			//Find the IP packet length
;    1822 			ip_packet_len = make16(packet[ip_pktlen],packet[ip_pktlen+1]);
	__GETB1MN _packet,16
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	__GETB1MN _packet,17
	POP  R26
	POP  R27
	CALL SUBOPT_0x14
;    1823 			//response to packet here
;    1824 			if(packet[ip_proto] == PROT_ICMP)
	__GETB1MN _packet,23
	CPI  R30,LOW(0x1)
	BRNE _0x13E
;    1825 				icmp();
	CALL _icmp
;    1826 			else if(packet[ip_proto] == PROT_UDP)
	RJMP _0x13F
_0x13E:
	__GETB1MN _packet,23
	CPI  R30,LOW(0x11)
	BRNE _0x140
;    1827 				udp();
	CALL _udp
;    1828 			else if(packet[ip_proto] == PROT_TCP)
	RJMP _0x141
_0x140:
	__GETB1MN _packet,23
	CPI  R30,LOW(0x6)
	BRNE _0x142
;    1829 				tcp();
	CALL _tcp
;    1830 		}
_0x142:
_0x141:
_0x13F:
;    1831 	}
_0x13D:
;    1832 }
_0x13A:
_0x139:
_0x1A8:
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1833 #include "ipad.h"
;    1834 /*ipad.c library source file
;    1835 created by Eric Mesa
;    1836 
;    1837 *********************************
;    1838 ver 0.1 13 Apr 2005
;    1839 created ipad.c
;    1840 simply an implementation
;    1841 of what Jeremy had written
;    1842 without any extra optimizations
;    1843 outside of what we had fixed
;    1844 as of atmelwebserver.c ver 0.94.1
;    1845 *********************************
;    1846 
;    1847 goes along with ipad.h
;    1848 header file
;    1849 */
;    1850 
;    1851 /*
;    1852 ********************************************************
;    1853 * SETIPADDRS
;    1854 * This function builds the IP header
;    1855 *********************************************************
;    1856 */
;    1857 
;    1858 void setipaddrs()
;    1859 {
_setipaddrs:
;    1860 	packet[enetpacketType0] = 0x08;
	LDI  R30,LOW(8)
	__PUTB1MN _packet,12
;    1861 	packet[enetpacketType1] = 0x00;
	CLR  R30
	__PUTB1MN _packet,13
;    1862 	/* client[0] = packet[ip_srcaddr+1];
;    1863 	client[1] = packet[ip_srcaddr+1];
;    1864 	client[2] = packet[ip_srcaddr+2];
;    1865 	client[3] = packet[ip_srcaddr+3];
;    1866 	//move IP source address to destination address
;    1867 	packet[ip_destaddr] = client[0];
;    1868 	packet[ip_destaddr+1] = client[1];
;    1869 	packet[ip_destaddr+2] = client[2];
;    1870 	packet[ip_destaddr+3] = client[3];*/
;    1871 	//move IP source address to destination address
;    1872 	packet[ip_destaddr] = packet[ip_srcaddr];
	__GETB1MN _packet,26
	__PUTB1MN _packet,30
;    1873 	packet[ip_destaddr+1] = packet[ip_srcaddr+1];
	__GETB1MN _packet,27
	__PUTB1MN _packet,31
;    1874 	packet[ip_destaddr+2] = packet[ip_srcaddr+2];
	__GETB1MN _packet,28
	__PUTB1MN _packet,32
;    1875 	packet[ip_destaddr+3] = packet[ip_srcaddr+3];
	__GETB1MN _packet,29
	__PUTB1MN _packet,33
;    1876 	//make ethernet module IP address source address
;    1877 	packet[ip_srcaddr] = MYIP[0];
	LDS  R30,_MYIP
	__PUTB1MN _packet,26
;    1878 	packet[ip_srcaddr+1] = MYIP[1];
	__GETB1MN _MYIP,1
	__PUTB1MN _packet,27
;    1879 	packet[ip_srcaddr+2] = MYIP[2];
	__GETB1MN _MYIP,2
	__PUTB1MN _packet,28
;    1880 	packet[ip_srcaddr+3] = MYIP[3];
	__GETB1MN _MYIP,3
	__PUTB1MN _packet,29
;    1881 	//move hardware source address to destination address
;    1882 	packet[enetpacketDest0] = packet[enetpacketSrc0];
	__GETB1MN _packet,6
	STS  _packet,R30
;    1883 	packet[enetpacketDest1] = packet[enetpacketSrc1];
	__GETB1MN _packet,7
	__PUTB1MN _packet,1
;    1884 	packet[enetpacketDest2] = packet[enetpacketSrc2];
	__GETB1MN _packet,8
	__PUTB1MN _packet,2
;    1885 	packet[enetpacketDest3] = packet[enetpacketSrc3];
	__GETB1MN _packet,9
	__PUTB1MN _packet,3
;    1886 	packet[enetpacketDest4] = packet[enetpacketSrc4];
	__GETB1MN _packet,10
	__PUTB1MN _packet,4
;    1887 	packet[enetpacketDest5] = packet[enetpacketSrc5];
	__GETB1MN _packet,11
	__PUTB1MN _packet,5
;    1888 	//make ethernet module mac address the source address
;    1889 	packet[enetpacketSrc0] = MYMAC[0];
	LDS  R30,_MYMAC
	__PUTB1MN _packet,6
;    1890 	packet[enetpacketSrc1] = MYMAC[1];
	__GETB1MN _MYMAC,1
	__PUTB1MN _packet,7
;    1891 	packet[enetpacketSrc2] = MYMAC[2];
	__GETB1MN _MYMAC,2
	__PUTB1MN _packet,8
;    1892 	packet[enetpacketSrc3] = MYMAC[3];
	__GETB1MN _MYMAC,3
	__PUTB1MN _packet,9
;    1893 	packet[enetpacketSrc4] = MYMAC[4];
	__GETB1MN _MYMAC,4
	__PUTB1MN _packet,10
;    1894 	packet[enetpacketSrc5] = MYMAC[5];
	__GETB1MN _MYMAC,5
	__PUTB1MN _packet,11
;    1895 	//set IP header length to 20 bytes
;    1896 	packet[ip_vers_len] = 0x45;
	LDI  R30,LOW(69)
	__PUTB1MN _packet,14
;    1897 	//calculate IP packet length done by the respective protocols
;    1898 	//calculate the IP header checksum
;    1899 	packet[ip_hdr_cksum] = 0x00;
	CLR  R30
	__PUTB1MN _packet,24
;    1900 	packet[ip_hdr_cksum+1] = 0x00;
	__PUTB1MN _packet,25
;    1901 	hdr_chksum = 0;
	CLR  R30
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R30
	STS  _hdr_chksum+2,R30
	STS  _hdr_chksum+3,R30
;    1902 	hdrlen = (packet[ip_vers_len] & 0x0F) << 2;
	__GETB1MN _packet,14
	CALL SUBOPT_0x16
;    1903 	addr = &packet[ip_vers_len];
	__POINTW1MN _packet,14
	CALL SUBOPT_0xD
;    1904 	cksum();
;    1905 	chksum16 = ~(hdr_chksum + ((hdr_chksum & 0xFFFF0000)>>16));
;    1906 	packet[ip_hdr_cksum] = make8(chksum16,1);
	CALL SUBOPT_0xE
	__PUTB1MN _packet,24
;    1907 	packet[ip_hdr_cksum+1] = make8(chksum16,0);
	LDS  R30,_chksum16
	LDS  R31,_chksum16+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	__PUTB1MN _packet,25
;    1908 }
	RET
;    1909                                               
;    1910 //*******************************************************
;    1911 //* timer interrupt
;    1912 //*******************************************************
;    1913 interrupt[TIM0_COMP] void t0_cmp(void)
;    1914 {
_t0_cmp:
	CALL __SAVEISR
;    1915 	waitcount--;
	LDS  R30,_waitcount
	LDS  R31,_waitcount+1
	SBIW R30,1
	STS  _waitcount,R30
	STS  _waitcount+1,R31
;    1916 	if(waitcount<0)
	LDS  R26,_waitcount
	LDS  R27,_waitcount+1
	SBIW R26,0
	BRGE _0x146
;    1917 	{
;    1918 		waitcount = 9000;
	LDI  R30,LOW(9000)
	LDI  R31,HIGH(9000)
	STS  _waitcount,R30
	STS  _waitcount+1,R31
;    1919 	}
;    1920 }
_0x146:
	CALL __LOADISR
	RETI
;    1921 
;    1922 //******************************************************
;    1923 //* HTTP Server
;    1924 //* This particular code echoes the incomeing Telnet data 
;    1925 //* to the LCD
;    1926 //******************************************************
;    1927 
;    1928 unsigned char flash *req_page;

	.DSEG
_req_page:
	.BYTE 0x2
;    1929 
;    1930 unsigned char flash *parse_http(void)
;    1931 {

	.CSEG
_parse_http:
;    1932 	unsigned char i, j;
;    1933 	unsigned char *getstr;
;    1934 	unsigned char flash *req_page;
;    1935 	unsigned char tmp_buffer[32];
;    1936 
;    1937 	getstr = packet+TCP_data;
	SBIW R28,36
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16
;	j -> R17
;	*getstr -> Y+36
;	*req_page -> Y+34
;	tmp_buffer -> Y+2
	__POINTW1MN _packet,66
	STD  Y+36,R30
	STD  Y+36+1,R31
;    1938 
;    1939 	i = strpos(getstr, ' ');
	CALL SUBOPT_0x49
	MOV  R16,R30
;    1940 	
;    1941 	if (i == -1)
	CPI  R16,255
	BRNE _0x148
;    1942 	{
;    1943 		return error400;
	LDS  R30,_error400
	LDS  R31,_error400+1
	RJMP _0x1A7
;    1944 	}
;    1945 	strncpy(tmp_buffer, getstr, i);
_0x148:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R16
	CALL _strncpy
;    1946 	tmp_buffer[i] = '\0';
	MOV  R30,R16
	CALL SUBOPT_0x4A
;    1947 
;    1948 	if (!strcmpf(tmp_buffer, "GET"))
	__POINTW1FN _327,0
	CALL SUBOPT_0x4B
	BREQ PC+3
	JMP _0x149
;    1949 	{
;    1950 		i++;
	SUBI R16,-1
;    1951  		j = strpos(getstr+i, ' ');
	MOV  R30,R16
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x49
	MOV  R17,R30
;    1952  		
;    1953  		if (j == -1)
	CPI  R17,255
	BRNE _0x14A
;    1954  		{
;    1955  			return error400;
	LDS  R30,_error400
	LDS  R31,_error400+1
	RJMP _0x1A7
;    1956  		}
;    1957 		strncpy(tmp_buffer, getstr+i, j);
_0x14A:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R16
	LDD  R26,Y+38
	LDD  R27,Y+38+1
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	CALL _strncpy
;    1958 		tmp_buffer[j] = '\0';
	MOV  R30,R17
	CALL SUBOPT_0x4A
;    1959 
;    1960 		if (!strcmpf(tmp_buffer, "/") || !strcmpf(tmp_buffer, "/index.html"))
	__POINTW1FN _327,4
	CALL SUBOPT_0x4B
	BREQ _0x14C
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,6
	CALL SUBOPT_0x4B
	BRNE _0x14B
_0x14C:
;    1961 		{
;    1962 			req_page = index;
	LDS  R30,_index
	LDS  R31,_index+1
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1963 		}
;    1964 		else if (!strcmpf(tmp_buffer, "/about.html"))
	RJMP _0x14E
_0x14B:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,18
	CALL SUBOPT_0x4B
	BRNE _0x14F
;    1965 		{
;    1966 			req_page = about;
	LDS  R30,_about
	LDS  R31,_about+1
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1967 		}
;    1968 		else if (!strcmpf(tmp_buffer, "/index2.html"))
	RJMP _0x150
_0x14F:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,30
	CALL SUBOPT_0x4B
	BRNE _0x151
;    1969 		{
;    1970 			req_page = index2;
	LDS  R30,_index2
	LDS  R31,_index2+1
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1971 		}
;    1972 		else if (!strcmpf(tmp_buffer, "/favicon.ico"))
	RJMP _0x152
_0x151:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,43
	CALL SUBOPT_0x4B
	BRNE _0x153
;    1973 		{
;    1974 			req_page = favicon;
	LDI  R30,LOW(_favicon*2)
	LDI  R31,HIGH(_favicon*2)
	RJMP _0x1AD
;    1975 		}
;    1976 		else
_0x153:
;    1977 		{
;    1978 			req_page = error404;
	LDS  R30,_error404
	LDS  R31,_error404+1
_0x1AD:
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1979 		}
_0x152:
_0x150:
_0x14E:
;    1980 	}
;    1981 	else if (!strcmpf(tmp_buffer, "HEAD"))
	RJMP _0x155
_0x149:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,56
	CALL SUBOPT_0x4B
	BRNE _0x156
;    1982 	{
;    1983 		req_page = error501;
	LDS  R30,_error501
	LDS  R31,_error501+1
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1984 	}
;    1985 	else if (!strcmpf(tmp_buffer, "POST"))
	RJMP _0x157
_0x156:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,61
	CALL SUBOPT_0x4B
	BRNE _0x158
;    1986 	{
;    1987 		req_page = error501;
	LDS  R30,_error501
	LDS  R31,_error501+1
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1988 	}
;    1989 	else if (!strcmpf(tmp_buffer, "TRACE"))
	RJMP _0x159
_0x158:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _327,66
	CALL SUBOPT_0x4B
	BRNE _0x15A
;    1990 	{
;    1991 		req_page = error501;
	LDS  R30,_error501
	LDS  R31,_error501+1
	RJMP _0x1AE
;    1992 	}
;    1993 	else
_0x15A:
;    1994 	{
;    1995 		req_page = error400;
	LDS  R30,_error400
	LDS  R31,_error400+1
_0x1AE:
	STD  Y+34,R30
	STD  Y+34+1,R31
;    1996 	}
_0x159:
_0x157:
_0x155:
;    1997 
;    1998 	return req_page;
	LDD  R30,Y+34
	LDD  R31,Y+34+1
_0x1A7:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,38
	RET
;    1999 }
;    2000 
;    2001 void http_server()
;    2002 {	
_http_server:
;    2003 	if(http_state == 0)
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x15D
;    2004 	{
;    2005 		http_state = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 6,7
;    2006 		req_page = parse_http();
	CALL _parse_http
	STS  _req_page,R30
	STS  _req_page+1,R31
;    2007 	}
;    2008 	
;    2009 	if(sendflag == 0 && pageendflag == 0)
_0x15D:
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRNE _0x15F
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BREQ _0x160
_0x15F:
	RJMP _0x15E
_0x160:
;    2010 	{
;    2011 		sendflag=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 8,9
;    2012 
;    2013 		page_size = strlenf(req_page);
	LDS  R30,_req_page
	LDS  R31,_req_page+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	__PUTW1R 4,5
;    2014 		counter += pack_html(req_page, counter);
	LDS  R30,_req_page
	LDS  R31,_req_page+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_counter
	LDS  R31,_counter+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _pack_html
	LDS  R26,_counter
	LDS  R27,_counter+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _counter,R30
	STS  _counter+1,R31
;    2015 		if (counter >= page_size)
	LDS  R26,_counter
	LDS  R27,_counter+1
	CP   R26,R4
	CPC  R27,R5
	BRLO _0x161
;    2016 		{
;    2017 			tcpdatalen_out+=12;//figure this out
	LDS  R30,_tcpdatalen_out
	LDS  R31,_tcpdatalen_out+1
	ADIW R30,12
	STS  _tcpdatalen_out,R30
	STS  _tcpdatalen_out+1,R31
;    2018  			pageendflag = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1R 10,11
;    2019 			set_finflag;
	CALL SUBOPT_0x38
;    2020 		}
;    2021 		send_tcp_packet();
_0x161:
	CALL _send_tcp_packet
;    2022 		rollback=0;
	CLR  R12
	CLR  R13
;    2023 	}
;    2024 	// the send operation has been completed
;    2025 	else if(pageendflag == 1)
	RJMP _0x162
_0x15E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x163
;    2026 	{
;    2027 		pageendflag = 0;
	CLR  R10
	CLR  R11
;    2028 		counter = 0;
	CLR  R30
	STS  _counter,R30
	STS  _counter+1,R30
;    2029 		rollback = 0;
	CLR  R12
	CLR  R13
;    2030 		http_state = 0;
	CLR  R6
	CLR  R7
;    2031 	}
;    2032 }
_0x163:
_0x162:
	RET
;    2033 
;    2034 //**********************************************************
;    2035 //* Main
;    2036 //**********************************************************
;    2037 void main(void)
;    2038 {
_main:
;    2039 	init_RTL8019AS();
	CALL _init_RTL8019AS
;    2040 	//setup timer 0
;    2041 	TIMSK = 2;
	LDI  R30,LOW(2)
	OUT  0x39,R30
;    2042 	OCR0 = 200;
	LDI  R30,LOW(200)
	OUT  0x3C,R30
;    2043 	TCCR0 = 0b00001011;
	LDI  R30,LOW(11)
	OUT  0x33,R30
;    2044 	ADMUX = 0b11100000; //internal 2.56 voltage ref with ext cap at AREF pin
	LDI  R30,LOW(224)
	OUT  0x7,R30
;    2045 	
;    2046 	//enable ADC and set prescaler to 1/64*16MHz = 125,000
;    2047 	//and set int enable
;    2048 	ADCSR = 0x80 + 0x07 + 0x08;
	LDI  R30,LOW(143)
	OUT  0x6,R30
;    2049 	MCUCR = 0b10010000; //enable sleep and choose ADC mode
	LDI  R30,LOW(144)
	OUT  0x35,R30
;    2050 	#asm("sei")
	sei
;    2051 	
;    2052 	clr_synflag;
	CALL SUBOPT_0x35
;    2053 	clr_finflag;
	CALL SUBOPT_0x3A
;    2054 	// decreased by 4.8 seconds by Eric and Richard
;    2055 	delay_ms(5000); //wait for boot up (0.2 seconds)
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    2056 	
;    2057 	//ob-mstain an ip address
;    2058 	dhcp();
	CALL _dhcp
;    2059 
;    2060 	//************************************************
;    2061 	//* Look for a packet in the receive buffer ring
;    2062 	
;    2063 	
;    2064 	//************************************************
;    2065 	while(1)
_0x165:
;    2066 	{
;    2067 		//start the NIC
;    2068 		
;    2069 		write_rtl(CR,0x22);
	CALL SUBOPT_0x43
;    2070 		write_rtl(ISR,0x7F);
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(127)
	ST   -Y,R30
	CALL _write_rtl
;    2071 		
;    2072 		//wait for a good packet
;    2073 		read_rtl(ISR);
	CALL SUBOPT_0xA
;    2074 		while(!(byte_read & 1))
_0x168:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x1)
	BRNE _0x16A
;    2075 		{
;    2076 			//PORTA.0 = 1;
;    2077 			//resend previous data
;    2078 			
;    2079 			if(waitcount == 0)
	LDS  R30,_waitcount
	LDS  R31,_waitcount+1
	SBIW R30,0
	BRNE _0x16B
;    2080 			{
;    2081 				if(DHCP_wait == 1)
	LDS  R26,_DHCP_wait
	LDS  R27,_DHCP_wait+1
	CPI  R26,LOW(0x1)
	LDI  R30,HIGH(0x1)
	CPC  R27,R30
	BRNE _0x16C
;    2082 				{
;    2083 					dhcpstate = DHCP_DIS;
	CLR  R30
	STS  _dhcpstate,R30
	STS  _dhcpstate+1,R30
;    2084 					dhcp();
	CALL _dhcp
;    2085 				}
;    2086 				if(DHCP_wait==2)
_0x16C:
	LDS  R26,_DHCP_wait
	LDS  R27,_DHCP_wait+1
	CPI  R26,LOW(0x2)
	LDI  R30,HIGH(0x2)
	CPC  R27,R30
	BRNE _0x16D
;    2087 				{
;    2088 					dhcpstate = DHCP_OFF;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dhcpstate,R30
	STS  _dhcpstate+1,R31
;    2089 					dhcp();
	CALL _dhcp
;    2090 				}
;    2091 			}
_0x16D:
;    2092 			read_rtl(ISR);
_0x16B:
	CALL SUBOPT_0xA
;    2093 		}
	RJMP _0x168
_0x16A:
;    2094 		//PORTA.0 = 0;
;    2095 		
;    2096 		//read the interrupt status register
;    2097 		read_rtl(ISR);
	CALL SUBOPT_0xA
;    2098 		
;    2099 		//if the receive buffer has been overrun
;    2100 		if(byte_read & OVW)
	LDS  R30,_byte_read
	ANDI R30,LOW(0x10)
	BREQ _0x16E
;    2101 			overrun();
	CALL _overrun
;    2102 		
;    2103 		//if the receive buffer holds a good packet
;    2104 		if(byte_read & PRX)
_0x16E:
	LDS  R30,_byte_read
	ANDI R30,LOW(0x1)
	BREQ _0x16F
;    2105 		get_packet();
	CALL _get_packet
;    2106 		//make sure the receive buffer ring is empty
;    2107 		//if BNRY = CURR, the buffer is empty
;    2108 		read_rtl(BNRY);
_0x16F:
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_rtl
;    2109 		data_L = byte_read;
	LDS  R30,_byte_read
	STS  _data_L,R30
;    2110 		write_rtl(CR,0x62);
	CALL SUBOPT_0x45
;    2111 		read_rtl(CURR);
	CALL SUBOPT_0xA
;    2112 		data_H = byte_read;
	LDS  R30,_byte_read
	STS  _data_H,R30
;    2113 		
;    2114 		write_rtl(CR,0x22);
	CALL SUBOPT_0x43
;    2115 		//buffer is not empty ..get next packet
;    2116 		if(data_L!=data_H)
	LDS  R30,_data_H
	LDS  R26,_data_L
	CP   R30,R26
	BREQ _0x170
;    2117 			get_packet();
	CALL _get_packet
;    2118 			
;    2119 		//reset the interrupt bits
;    2120 		write_rtl(ISR,0xFF);
_0x170:
	CALL SUBOPT_0x44
;    2121 	}
	RJMP _0x165
;    2122 }
_0x171:
	RJMP _0x171
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x0:
	ST   -Y,R16
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(34)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(8)
	ST   -Y,R30
	CLR  R30
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1:
	LDI  R30,LOW(60)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2:
	LDI  R30,LOW(11)
	ST   -Y,R30
	CLR  R30
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3:
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(18)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x4:
	LDI  R30,LOW(16)
	ST   -Y,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x5:
	SUBI R30,-LOW(6)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	LD   R30,Z
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x6:
	CLR  R31
	SUBI R30,LOW(-_MYMAC)
	SBCI R31,HIGH(-_MYMAC)
	LD   R30,Z
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x7:
	LDS  R26,_addr
	LDS  R27,_addr+1
	LD   R30,X+
	STS  _addr,R26
	STS  _addr+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x8:
	LD   R30,Z
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES
SUBOPT_0x9:
	ST   -Y,R30
	CLR  R30
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES
SUBOPT_0xA:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0xB:
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(36)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES
SUBOPT_0xC:
	MOVW R26,R30
	CLR  R27
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES
SUBOPT_0xD:
	STS  _addr,R30
	STS  _addr+1,R31
	CALL _cksum
	LDS  R30,_hdr_chksum
	LDS  R31,_hdr_chksum+1
	LDS  R22,_hdr_chksum+2
	LDS  R23,_hdr_chksum+3
	ANDI R30,LOW(0xFFFF0000)
	ANDI R31,HIGH(0xFFFF0000)
	CALL __LSRD16
	LDS  R26,_hdr_chksum
	LDS  R27,_hdr_chksum+1
	LDS  R24,_hdr_chksum+2
	LDS  R25,_hdr_chksum+3
	CALL __ADDD12
	CALL __COMD1
	STS  _chksum16,R30
	STS  _chksum16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0xE:
	LDS  R30,_chksum16+1
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0xF:
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	CLR  R22
	CLR  R23
	STS  _ic_chksum,R30
	STS  _ic_chksum+1,R31
	STS  _ic_chksum+2,R22
	STS  _ic_chksum+3,R23
	CLR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x10:
	CLR  R30
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R30
	STS  _hdr_chksum+2,R30
	STS  _hdr_chksum+3,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _hdrlen,R30
	STS  _hdrlen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x11:
	LDS  R26,_hdr_chksum
	LDS  R27,_hdr_chksum+1
	LDS  R24,_hdr_chksum+2
	LDS  R25,_hdr_chksum+3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R31
	STS  _hdr_chksum+2,R22
	STS  _hdr_chksum+3,R23
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _hdrlen,R30
	STS  _hdrlen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x12:
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	STS  _hdrlen,R30
	STS  _hdrlen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x13:
	LDS  R30,_ic_chksum
	LDS  R31,_ic_chksum+1
	LDS  R22,_ic_chksum+2
	LDS  R23,_ic_chksum+3
	LDS  R26,_chksum16
	LDS  R27,_chksum16+1
	CLR  R24
	CLR  R25
	CALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x14:
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	STS  _ip_packet_len,R30
	STS  _ip_packet_len+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x15:
	LDS  R30,_ip_packet_len+1
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x16:
	ANDI R30,LOW(0xF)
	LSL  R30
	LSL  R30
	CLR  R31
	STS  _hdrlen,R30
	STS  _hdrlen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x17:
	LDS  R30,_ip_packet_len
	LDS  R31,_ip_packet_len+1
	ADIW R30,14
	STS  _txlen,R30
	STS  _txlen+1,R31
	LDS  R26,_txlen
	LDS  R27,_txlen+1
	CPI  R26,LOW(0x3C)
	LDI  R30,HIGH(0x3C)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x18:
	LDS  R30,_txlen
	LDS  R31,_txlen+1
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	STS  _data_L,R30
	LDS  R30,_txlen+1
	ANDI R31,HIGH(0x0)
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	STS  _data_H,R30
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(34)
	ST   -Y,R30
	CALL _write_rtl
	CLR  R30
	ST   -Y,R30
	JMP  _read_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x19:
	CLR  R30
	ST   -Y,R30
	JMP  _read_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1A:
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(8)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1B:
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDS  R30,_data_L
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDS  R30,_data_H
	ST   -Y,R30
	CALL _write_rtl
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1C:
	LDI  R30,LOW(16)
	ST   -Y,R30
	__GETW1R 16,17
	ADIW R30,0
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x1D:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDS  R30,_data_L
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDS  R30,_data_H
	ST   -Y,R30
	CALL _write_rtl
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1E:
	MOV  R26,R16
	CLR  R27
	SUBI R26,LOW(-_MYIP)
	SBCI R27,HIGH(-_MYIP)
	LDI  R30,LOW(255)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x1F:
	MOV  R26,R16
	CLR  R27
	SUBI R26,LOW(-_packet)
	SBCI R27,HIGH(-_packet)
	CLR  R30
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x20:
	MOV  R30,R16
	SUBI R30,-LOW(70)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x21:
	MOV  R30,R16
	CLR  R31
	SUBI R30,LOW(-_MYMAC)
	SBCI R31,HIGH(-_MYMAC)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x22:
	MOV  R30,R16
	SUBI R30,-LOW(76)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	MOVW R26,R30
	CLR  R30
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x23:
	MOV  R30,R16
	SUBI R30,-LOW(86)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	MOVW R26,R30
	CLR  R30
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x24:
	MOV  R30,R16
	LDI  R26,LOW(288)
	LDI  R27,HIGH(288)
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x25:
	STS  _dhcpoptlen,R30
	STS  _dhcpoptlen+1,R31
	SUBI R30,LOW(-244)
	SBCI R31,HIGH(-244)
	MOV  R30,R31
	ANDI R30,LOW(0xFF)
	ANDI R31,HIGH(0xFF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x26:
	LDS  R26,_dhcpoptlen
	LDS  R27,_dhcpoptlen+1
	SUBI R26,LOW(-244)
	SBCI R27,HIGH(-244)
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	AND  R30,R26
	AND  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x27:
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(24)
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x28:
	CLR  R31
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	CALL __LSLD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x29:
	MOV  R30,R16
	CLR  R31
	SUBI R30,LOW(-_req_ip)
	SBCI R31,HIGH(-_req_ip)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2A:
	MOV  R30,R16
	SUBI R30,-LOW(58)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2B:
	MOV  R30,R16
	CLR  R31
	SUBI R30,LOW(-_serverid)
	SBCI R31,HIGH(-_serverid)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2C:
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2D:
	MOVW R26,R30
	CLR  R30
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x2E:
	ANDI R30,LOW(0xF)
	LSL  R30
	LSL  R30
	LDS  R26,_ip_packet_len
	LDS  R27,_ip_packet_len+1
	CLR  R31
	SUB  R26,R30
	SBC  R27,R31
	STS  _tcplen,R26
	STS  _tcplen+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x2F:
	LDS  R26,_hdr_chksum
	LDS  R27,_hdr_chksum+1
	LDS  R24,_hdr_chksum+2
	LDS  R25,_hdr_chksum+3
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R31
	STS  _hdr_chksum+2,R22
	STS  _hdr_chksum+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x30:
	LDS  R30,_tcplen
	LDS  R31,_tcplen+1
	LDS  R26,_hdr_chksum
	LDS  R27,_hdr_chksum+1
	LDS  R24,_hdr_chksum+2
	LDS  R25,_hdr_chksum+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R31
	STS  _hdr_chksum+2,R22
	STS  _hdr_chksum+3,R23
	LDS  R30,_tcplen
	LDS  R31,_tcplen+1
	STS  _hdrlen,R30
	STS  _hdrlen+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x31:
	LDS  R30,_data_L
	ST   X,R30
	JMP  _assemble_ack

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x32:
	LDS  R26,_ISN
	LDS  R27,_ISN+1
	ADIW R26,1
	STS  _ISN,R26
	STS  _ISN+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x33:
	LDS  R30,_my_seqnum
	LDS  R31,_my_seqnum+1
	LDS  R22,_my_seqnum+2
	LDS  R23,_my_seqnum+3
	CALL __LSRD16
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x34:
	LDS  R30,_my_seqnum
	LDS  R31,_my_seqnum+1
	MOV  R30,R31
	__ANDD1N 0xFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x35:
	MOV  R30,R14
	ANDI R30,0xFE
	MOV  R14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x36:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _ackflag,R30
	STS  _ackflag+1,R31
	JMP  _http_server

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x37:
	LDS  R26,_incoming_ack
	LDS  R27,_incoming_ack+1
	LDS  R24,_incoming_ack+2
	LDS  R25,_incoming_ack+3
	LDS  R30,_expected_ack
	LDS  R31,_expected_ack+1
	LDS  R22,_expected_ack+2
	LDS  R23,_expected_ack+3
	CALL __SUBD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x38:
	MOV  R30,R14
	ORI  R30,2
	MOV  R14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x39:
	STS  _data_L,R30
	LDS  R26,_data_H
	CLR  R27
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12U
	MOVW R26,R30
	LDS  R30,_data_L
	CLR  R31
	ADD  R30,R26
	ADC  R31,R27
	STS  _chksum16,R30
	STS  _chksum16+1,R31
	LDS  R26,_hdr_chksum
	LDS  R27,_hdr_chksum+1
	LDS  R24,_hdr_chksum+2
	LDS  R25,_hdr_chksum+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _hdr_chksum,R30
	STS  _hdr_chksum+1,R31
	STS  _hdr_chksum+2,R22
	STS  _hdr_chksum+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3A:
	MOV  R30,R14
	ANDI R30,0xFD
	MOV  R14,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3B:
	MOV  R30,R16
	SUBI R30,-LOW(67)
	CLR  R31
	SUBI R30,LOW(-_packet)
	SBCI R31,HIGH(-_packet)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3C:
	CLR  R30
	OUT  0x14,R30
	LDI  R30,LOW(255)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES
SUBOPT_0x3D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x3E:
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(33)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x3F:
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(88)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x40:
	ST   -Y,R30
	CALL _write_rtl
	LDI  R30,LOW(13)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x41:
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES
SUBOPT_0x42:
	ST   -Y,R30
	LDI  R30,LOW(70)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES
SUBOPT_0x43:
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(34)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES
SUBOPT_0x44:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x45:
	CLR  R30
	ST   -Y,R30
	LDI  R30,LOW(98)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x46:
	SUBI R30,LOW(4)
	ST   -Y,R30
	JMP  _write_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x47:
	LDI  R30,LOW(16)
	ST   -Y,R30
	JMP  _read_rtl

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x48:
	MOVW R26,R30
	LDS  R30,_byte_read
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x49:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _strpos

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES
SUBOPT_0x4A:
	CLR  R31
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ST   X,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES
SUBOPT_0x4B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _strcmpf
	CPI  R30,0
	RET

_strcmpf:
	ld   r30,y+
	ld   r31,y+
	ld   r26,y+
	ld   r27,y+
__strcmpf0:
	ld   r1,x+
	lpm  r0,z+
	cp   r0,r1
	brne __strcmpf1
	tst  r0
	brne __strcmpf0
	clr  r30
	rjmp __strcmpf2
__strcmpf1:
	sub  r1,r0
	mov  r30,r1
__strcmpf2:
	ret

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_strncpy:
	ld   r23,y+
	ld   r30,y+
	ld   r31,y+
	ld   r26,y+
	ld   r27,y+
	movw r24,r26
__strncpy0:
	tst  r23
	breq __strncpy1
	dec  r23
	ld   r22,z+
	st   x+,r22
	tst  r22
	brne __strncpy0
__strncpy2:
	tst  r23
	breq __strncpy1
	dec  r23
	st   x+,r22
	rjmp __strncpy2
__strncpy1:
	movw r30,r24
	ret

_strpos:
	ld   r22,y+
	ld   r26,y+
	ld   r27,y+
	clr  r30
__strpos0:
	ld   r23,x+
	cp   r22,r23
	breq __strpos1
	inc  r30
	tst  r23
	brne __strpos0
	ldi  r30,-1
__strpos1:
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__SAVEISR:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R0,SREG
	ST   -Y,R0
	RET

__LOADISR:
	LD   R0,Y+
	OUT  SREG,R0
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	CLR  R22
	CLR  R23
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	CLR  R30
	CLR  R31
	RET

__CWD2:
	CLR  R24
	CLR  R25
	SBRS R27,7
	RET
	SER  R24
	SER  R25
	RET

__COMD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

