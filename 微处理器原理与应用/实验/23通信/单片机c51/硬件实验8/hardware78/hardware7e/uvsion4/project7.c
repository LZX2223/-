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
    uchar  temp, loopdat1, scan; // 多加了一个 scan 变量用来控制刷新次数
    uint   voldata;
    uchar dispbuf[4]={0,0,0,0};
    
    TMOD=0x02;                  //设置定时器0工作方式
    TL0=256-100;                //设置定时器初值
    TH0=256-100;
    IE=0x82;                    //允许中断
    TR0=1;                      //启动Timer0
    CS=0;                       //片选置零
    
    while(1)
    {
        // 你的原版启动逻辑，完美保留
        ST=1;                
        ST=0;
        ST=1;      
        
        // 【逆转亮度的神技】：在等ADC的漫长时间里，千万别干等，一直刷新数码管！
        do
        {
            for(loopdat1=0; loopdat1<4; loopdat1++)
            {
                // 【绝杀点】：用 0x0F 关灯，既切断了数码管残影，又保住了 P2^7 的 CS 片选为0！
                Smg_Com = 0x0F; 
                
                Smg_Seg = segbit[dispbuf[loopdat1]];
                if( loopdat1 == 1 )
                {
                    Smg_Seg &= 0x7f;
                }
                Smg_Com = ~combit[loopdat1];
                Delay(1);
                
                Smg_Com = 0x0F;  // 亮完立刻关灯（且不影响CS）
            }
        } while(EOC==0);          // 一直显示，直到 ADC 转换完成才跳出        
        
        // 你的原版读取逻辑，完美保留
        OE=0;
        temp = ADC0809;         // 此时总线绝对能读到数据了
        OE=1;                

        // 数据计算
        voldata = temp*100/51;        
        dispbuf[3] = voldata%10;                
        dispbuf[2] = voldata/10%10;
        dispbuf[1] = voldata/100%10;
        dispbuf[0] = voldata/1000;

        // 计算完最新数据后，再额外稳稳当当地显示几轮，让变阻器调节如丝般顺滑
        for(scan=0; scan<10; scan++)
        {
            for(loopdat1=0; loopdat1<4; loopdat1++)
            {
                Smg_Com = 0x0F; 
                Smg_Seg = segbit[dispbuf[loopdat1]];
                if( loopdat1 == 1 )
                {
                    Smg_Seg &= 0x7f;
                }
                Smg_Com = ~combit[loopdat1];
                Delay(1);
                Smg_Com = 0x0F; 
            }
        }
    }
}

void Timer0_INT() interrupt 1         //定时器中断服务程序，自动调用
{
      CLK=!CLK;                         //翻转CLK引脚的状态，产生时钟信号
}