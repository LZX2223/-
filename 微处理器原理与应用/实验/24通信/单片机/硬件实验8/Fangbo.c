#include <reg51.h>

sbit CS = P2^7;
sbit WR12 = P3^6;
sfr DAC0832 = 0x80;

void delay(unsigned int time)
{
    unsigned int i, j;
    for(i = 0; i < time; i++)
        for(j = 0; j < 120; j++);
}

void main(void)
{
    CS = 0;
    WR12 = 0;

    while(1)
    {
        DAC0832 = 0x00;   // 输出低电平
        delay(50);

        DAC0832 = 0xff;   // 输出高电平
        delay(50);
    }
}