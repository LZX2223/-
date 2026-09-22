#include <reg52.h>
#include <absacc.h>

#define uchar unsigned char
#define uint unsigned int

// 共阳极数码管段码：0~9，10表示熄灭
unsigned char code segbit[] = {
    0xc0, 0xf9, 0xa4, 0xb0, 0x99,
    0x92, 0x82, 0xf8, 0x80, 0x90,
    0xff
};

// 位选码：COM1~COM4分别接P2.0~P2.3，高电平有效
unsigned char code combit[] = {
    0x01, 0x02, 0x04, 0x08
};

#define ADC0809 P0
#define Smg_Seg P1
#define Smg_Com P2

sbit EOC = P3^0;
sbit CLK = P3^1;
sbit OE  = P3^7;
sbit ST  = P3^6;
sbit CS  = P2^7;

void Delay(unsigned int i)
{
    unsigned int j;
    for(; i > 0; i--)
    {
        for(j = 0; j < 125; j++)
        {
            ;
        }
    }
}

void main()
{
    uchar temp;
    uchar loopdat1;
    uint voldata;
    uchar dispbuf[4];

    // 定时器0初始化，用于产生ADC0809时钟
    TMOD = 0x02;
    TL0 = 256 - 100;
    TH0 = 256 - 100;
    IE = 0x82;
    TR0 = 1;

    CS = 0;

    while(1)
    {
        // 启动ADC0809转换
        ST = 1;
        ST = 0;
        ST = 1;

        // 等待转换完成
        while(EOC == 0);

        // 读取ADC0809转换结果
        OE = 0;
        ADC0809 = 0xff;
        temp = ADC0809;
        OE = 1;

        // 三位小数换算
        // 0~255 对应 0~5.000V
        // voldata = temp * 5000 / 255
        // 近似为 temp * 1000 / 51
        voldata = temp * 1000 / 51;

        // 拆分为 X.XXX
        dispbuf[0] = voldata / 1000;        // 个位
        dispbuf[1] = voldata / 100 % 10;    // 小数第1位
        dispbuf[2] = voldata / 10 % 10;     // 小数第2位
        dispbuf[3] = voldata % 10;          // 小数第3位

        // 数码管动态扫描
        for(loopdat1 = 0; loopdat1 < 4; loopdat1++)
        {
            Smg_Com = 0x00;     // 先关闭所有位，防止重影

            Smg_Seg = segbit[dispbuf[loopdat1]];

            // 小数点放在第一位后面，显示 X.XXX
            if(loopdat1 == 0)
            {
                Smg_Seg &= 0x7f;
            }

            Smg_Com = combit[loopdat1];
            Delay(1);
        }
    }
}

// 定时器0中断，产生ADC0809时钟
void Timer0_INT() interrupt 1
{
    CLK = !CLK;
}