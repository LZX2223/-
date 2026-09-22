#include <reg52.h>
void delay(unsigned int n) 
{
    unsigned int i, j;
    for(i = 0; i < n; i++)
        for(j = 0; j < 125; j++);
		
}
void main() 
{
    unsigned char led_status = 0x01;
    P0= 0XFE;
    while(1) 
	{
	delay(200); 
	led_status = led_status << 1;
	if(led_status == 0)
	led_status = 0x01;
	P0=~led_status;
    }
}