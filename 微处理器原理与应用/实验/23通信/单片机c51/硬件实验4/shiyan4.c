#include <reg52.h>  

sbit key = P3^2; // 定义单个位变量key，连接到P3端口的第2位，假设用于外部中断触发
unsigned int count = 0; // 定义全局变量count，用于记录中断次数
unsigned char code led_table[] = {0xc0,0xf9,0xa4,0xb0, 0x99,0x92,0x82,0xf8,0x80,0x90}; // 数码管显示数字0-9的编码表

int a[4]= {0x00,0x00,0x00,0x00}; // 定义数组a，用于存储每位数字的显示

// 定义延时函数
void delay(unsigned int t) {
    unsigned int i, j;
    for (i = 0; i < t; i++) {
        for (j = 0; j < 10; j++); // 简单的循环延时
    }
}

// 定义外部中断服务程序
//外部中断：程序使用P3.2作为外部中断输入，每次外部中断触发时，count 计数器加1。
//并且对该数进行分解，将各位数存储在数组 a 中，然后在四个数码管上显示出来。
void external_interrupt() interrupt 0 {
    unsigned int i, j;
    EX0 = 0; // 关闭外部中断0，避免在处理中断时再次被中断

    if (count > 9999) {
        count = 0; // 如果计数器超过9999，则重置为0
    }
    count++; // 每次中断计数器加1
    j = 10000; // 设置初始除数为10000，用于提取每个数位

    for (i = 0; i < 4; i++) {
        a[i] = count % j; // 获取当前数位
        j = j / 10;       // 降低除数的数量级
        a[i] = a[i] / j;  // 根据数量级获得实际显示的数
    }
    
    EX0 = 1; // 处理完后重新开启外部中断0
}

// 主函数
void main() {
    unsigned int i;
    // 初始化外部中断
    IT0 = 1; // 设置外部中断0为下降沿触发
    EX0 = 1; // 开启外部中断0
    EA = 1;  // 开启全局中断

    while (1) {
        for (i = 0; i < 4; i++) {
            P1 = 0x00; // 清空P1口
            P0 = led_table[a[i]]; // 设置P0口输出对应数字的编码，控制数码管显示
            P1 = (1 << i); // 设置P1口对应位为低电平，使得对应数码管被选中
            delay(10); // 延时一段时间，保证数码管显示稳定
        }
    }
}