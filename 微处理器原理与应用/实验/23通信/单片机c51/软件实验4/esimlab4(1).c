#include<reg51.h>
#include<math.h>
typedef unsigned char uchar;
typedef unsigned int uint;

extern void delay(char n);
extern uint add(char c,char d);
extern float asmsin(float e);

uchar i,j,n;

uint x;
float y,z;

main()
{
n=100;
for(i=0;i<200;i++)
{
for(j=0;j<250;j++)
{
  delay(n);
}
}

i=150;
j=200;

x=add(i,j);

y=3.1415926/2;
z=asmsin(y);

while(1);
}