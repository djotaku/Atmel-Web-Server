/*tcpsend.h header file
created by Eric Mesa

(C) 2005

Published: 12 Aug 2005
Published under the GNU General Public License version 2 - http://www.linux.org/info/gnu.html
http://www.ericsbinaryworld.com

*********************************
ver 0.1 10 Apr 2005
created tcpsend.h
*********************************

goes along with tcpsend.c
library source file
*/
#ifndef _TCPSEND_H_
#define _TCPSEND_H_
void send_tcp_packet();
unsigned int pack_html(unsigned char flash *req_page, unsigned int req_offset);

#include "tcpsend.c"
#endif