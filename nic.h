/*nic.h header file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created nic.h
*********************************

goes along with nic.c
library source file
*/
#ifndef _NIC_H_
#define _NIC_H_
void write_rtl(unsigned char regaddr, unsigned char regdata);
void read_rtl(unsigned char regaddr);
void init_RTL8019AS();

#include "nic.c"
#endif