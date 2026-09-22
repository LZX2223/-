#include <reg51.h>
#define uchar unsigned char
#define uint  unsigned int

uchar data a[32] _at_ 0x30;

void main()
{

    uchar code table[32] = {
        1, 3, 9, 2, 17, 4, 11, 6,
        5, 20, 100, 64, 21, 14, 79, 35,
        92, 7, 91, 23, 65, 16, 13, 18,
        18, 73, 65, 101, 27, 19, 62, 69
    };

    uchar i, j;
    uchar temp;

 
    for(i = 0; i < 32; i++)
    {
        a[i] = table[i];
    }

  
    for(j = 0; j < 31; j++)
    {
    
        for(i = 0; i < 31 - j; i++)
        {
            
            if(a[i] > a[i + 1])
            {
                temp = a[i];
                a[i] = a[i + 1];
                a[i + 1] = temp;
            }
        }
    }


    while(1);
}