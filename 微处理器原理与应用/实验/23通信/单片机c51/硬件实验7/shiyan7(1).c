#include<reg52.h>
#include<absacc.h>

#define uchar unsigned char
#define uint unsigned int

unsigned char code segbit[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90, 0xff};//数码管段选码
unsigned char code combit[]={0xf1,0xf2,0xf4,0xf8};                                      //数码管位选码

#define  ADC0809 P0         //引脚定义
#define Smg_Seg P1
#define Smg_Com P2
sbit EOC=P3^0;
sbit CLK=P3^1;
sbit OE=P3^7;
sbit ST=P3^6;
sbit CS=P2^7;
void Delay(unsigned int i);


void Delay(unsigned int i)
{
  unsigned int j;
  for(;i>0;i--)
  {
  for(j=0;j<125;j++)
  {;}
  }
}
 

void main()
{
    uchar  temp,loopdat1;
    uint   voldata;
    uchar dispbuf[4];
       TMOD=0x02;                //设置定时器0工作方式
    TL0=256-100;                    //设置定时器初值
    TH0=256-100;
    IE=0x82;                    //10000010 允许中断
    TR0=1;                        //TR0 是Timer0的运行控制位，允许中断
     CS=0;                        //片选置零
    while(1)
    {
        //ADC0809=0x0f;    
      
        ST=1;                //0809启动信号
        ST=0;
        ST=1;      
        do
        {;}
        while(EOC==0);          //转换是否完成        
        //delayms(1);
        OE=0;
        temp = ADC0809;         //读出转换结果
        OE=1;                //输出允许

        voldata = temp*100/51;//temp*1.0/255*500;        //转换公式，0809读取的数字量为0-255，最高5V，后加00精确到小数点后2位
        //分离小数点后两位、个、十位
        dispbuf[3] = voldata%10;                
        dispbuf[2] = voldata/10%10;
        dispbuf[1] = voldata/100%10;
        dispbuf[0] = voldata/1000;

        for(loopdat1=0;loopdat1<4;loopdat1++)
        {
            
            Smg_Seg = segbit[dispbuf[loopdat1]];            //数码管显示数值
            if( loopdat1 == 1 )
            {
                //Smg_Com = 0x70;
			    Smg_Seg &= 0x7f;
            }
            Smg_Com = ~combit[loopdat1];            //数码管位选
            Delay(1);
           
        }
    }
}

void Timer0_INT()   interrupt 1         //定时器中断服务程序，自动调用
{
      CLK=!CLK;                         //翻转CLK引脚的状态，产生时钟信号
}
