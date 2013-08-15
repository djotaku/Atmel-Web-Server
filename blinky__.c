#include <Mega32.h>
#include <delay.h>

void main(void)
{
	DDRD = 0xFF;
	
	while(1)
	{
		PORTD.7 = 0;
		delay_ms(500);
		PORTD.7 = 1;
		delay_ms(500);
	}
}
