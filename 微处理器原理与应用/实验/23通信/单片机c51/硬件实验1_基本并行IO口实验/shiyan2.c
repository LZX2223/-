#include <reg52.h>
#include <INTRINS.H>

void Delay(unsigned int xms)
{
  unsigned char i,j;
  while (xms--)
  {
    i=2;
	j=239;
	do
	{
      while(--j);	
	} while(--i);
	 
  }
}
void main()
{
  P0=0xfe;
  while(1)
  {
    Delay(250);
	P0=_crol_(P0,1);
  }
}