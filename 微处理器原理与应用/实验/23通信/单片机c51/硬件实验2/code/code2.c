#include <reg52.h>//引入单片机的寄存器定义文件
void delay(unsigned int n) 
{
    unsigned int i, j;
    for(i = 0; i < n; i++)//循环执行n次
        for(j = 0; j < 125; j++);//内层循环，实现延迟操作
		/*更确切的来说，这里的内循环是通过对变量j的累加来占用处理器的时间
		（一次内循环（加法操作）对应着一次时钟周期）使得处理器不能继续指向下一条指令
		从而实现延时效果
		在这里引入延迟的目的是使得LED灯的状态改变有一定的时间间隔，
		使LED灯的状态改变时有明显的时间差，让人能够观察到LED灯的状态变化*/
}
void main() 
{
    unsigned char led_status = 0x01;//记录led灯的初始状态
    P0= 0XFE;//将0xFE的值写入P0口，将其第0位设为低电平，其他位设为高电平
    while(1) 
	{
	delay(200); //引入延迟，使LED灯的状态改变有一定时间间隔
	led_status = led_status << 1;//左移1位，改变LED灯的状态
	if(led_status == 0)
	led_status = 0x01;//如果到达边界，则进行复位处理
	P0=~led_status;//将led_status的值取反后写入P0口从而实现对led的控制     
    }
}