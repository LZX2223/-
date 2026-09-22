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

// 位选码：只选通一位
// COM1~COM4分别接P2.0~P2.3，高电平有效
unsigned char code combit[] = {
    0x01, 0x02, 0x04, 0x08
};

#define ADC0809 P0      // ADC0809数据口接P0
#define Smg_Seg P1      // 数码管段选接P1
#define Smg_Com P2      // 数码管位选接P2

sbit EOC = P3^0;        // 转换结束信号
sbit CLK = P3^1;        // ADC时钟
sbit OE  = P3^7;        // 读控制信号，经过门电路后控制ADC的OE
sbit ST  = P3^6;        // 启动转换信号，经过门电路后控制ADC的START
sbit CS  = P2^7;        // ADC片选信号

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
    TMOD = 0x02;        // 定时器0方式2，8位自动重装
    TL0 = 256 - 100;
    TH0 = 256 - 100;
    IE = 0x82;          // EA=1，ET0=1，允许定时器0中断
    TR0 = 1;            // 启动定时器0

    CS = 0;             // ADC0809片选有效

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
        ADC0809 = 0xff;     // 释放P0口，准备读入数据
        temp = ADC0809;
        OE = 1;

        // ADC结果换算成电压值
        // 0~255 对应 0~5.00V
        // voldata = temp * 500 / 255
        // 近似写成 temp * 100 / 51
        voldata = temp * 100 / 51;

        // 拆分成4位显示数据
        dispbuf[3] = voldata % 10;          // 小数第2位
        dispbuf[2] = voldata / 10 % 10;     // 小数第1位
        dispbuf[1] = voldata / 100 % 10;    // 个位
        dispbuf[0] = voldata / 1000;        // 十位

        // 最高位为0时熄灭，例如显示 2.50 而不是 02.50
        if(dispbuf[0] == 0)
        {
            dispbuf[0] = 10;
        }

        // 数码管动态扫描
        for(loopdat1 = 0; loopdat1 < 4; loopdat1++)
        {
            Smg_Com = 0x00;     // 先关闭所有位，防止重影

            Smg_Seg = segbit[dispbuf[loopdat1]];

            // 在第二位后面加小数点，显示格式为 X.XX
            if(loopdat1 == 1)
            {
                Smg_Seg &= 0x7f;
            }

            Smg_Com = combit[loopdat1];    // 选通当前位
            Delay(1);
        }
    }
}

// 定时器0中断服务函数
void Timer0_INT() interrupt 1
{
    CLK = !CLK;      // 翻转CLK，给ADC0809提供时钟
}