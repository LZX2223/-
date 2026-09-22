#include<reg51.h>
#include<stdio.h>
char data a[32] _at_ 0x30;
void main()
{
char code
b[32]={1,3,9,2,17,4,11,6,5,20,100,64,21,14,79,35,92,7,91,23,65,16,13,18,18,73,65,101,27,19,62,69};
int i=0;
int t=0;
int j=0;
for(i=0;i<32;i++)
{a[i]=b[j];
j++;
}
for(j=0;j<31;j++)
  for(i=0;i<31-j;i++)
    if(a[i]>a[i+1])
     {
      t=a[i];
      a[i]=a[i+1];
      a[i+1]=t;
     }
     while(1);
}

