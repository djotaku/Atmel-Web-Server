/*tcp.h header file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created tcp.h
*********************************

goes along with tcp.c
library source file
*/
#ifndef _TCP_H_
#define _TCP_H_
void tcp();
void tcp_close();
void cksum();

#include "tcp.c"
#endif