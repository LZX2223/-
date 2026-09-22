#include <reg51.h>
sbit CS = P2^7;   // 将CS位定义为P2.7引脚
sbit WR12 = P3^6; // 将WR12位定义为P3.6引脚
sfr DAC0832 = 0x80; // 将 DAC0832 连接到 P0 端口
void delay(unsigned int time) {
    unsigned int i, j;
    for (i = 0; i < time; i++)
        for (j = 0; j < 10; j++);
}
void main(void) {
    unsigned char value;
	CS=0;
	WR12=0;

    while (1) {
        // 递减循环，从255到0，对应0到-2.5V的输出电压
        for (value = 0; value < 255; value++) {
            DAC0832 = -value; // 输出当前数值到 DAC0832 
			delay(10);
        // 输出0V，即255对应的数值
		}
        DAC0832 = 0;
		 		         		    
}
}


