#include <reg52.h>
#include <intrins.h>

#define uchar unsigned char
#define uint  unsigned int

sbit K1 = P1^0;
sbit K2 = P1^1;

void Delay(uint xms)
{
    uchar i, j;

    while(xms--)
    {
        i = 2;
        j = 240;
        do
        {
            while(--j);
        } while(--i);
    }
}

void main()
{
    P0 = 0xFE;

    while(1)
    {
        if(K1 == 0)
        {
            Delay(20);
            if(K1 == 0)
            {
                while(K1 == 0);
                Delay(20);

                P0 = _crol_(P0, 1);
            }
        }

        if(K2 == 0)
        {
            Delay(20);
            if(K2 == 0)
            {
                while(K2 == 0);
                Delay(20);

                P0 = _cror_(P0, 1);
            }
        }
    }
}