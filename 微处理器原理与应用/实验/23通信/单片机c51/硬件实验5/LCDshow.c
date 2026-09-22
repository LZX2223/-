#include <reg52.h>
typedef unsigned char uchar;
typedef unsigned int uint;

#define out P0
sbit E=P2^2;	  //读写操作选择引脚
sbit RW=P2^1;	   //读写选择引脚
sbit RS=P2^0;		//寄存器选择引脚

void delay(uint j); 		  //调用函数声明
void delay_ms(uchar t); 
void check_busy(); 
void write_command(uchar com); 
void write_data(uchar wdata); 
void lcd_initial(); 
void string(uchar address,uchar *s);

void main(){		   //主函数
	lcd_initial();	 //设置初始状态
	string(0x80,"WINDWAY A GOOD ");	   //第一行显示字符串
	string(0xC0,"NEWS");					   //换行显示字符串
	while(1)							   //延时
	{
		delay(100);
	}
}

void delay(uint j){			 //定义延时函数
	uchar i = 60;
	for(; j>0; j--){
		while(--i);
		i = 59;
		while(--i);
		i = 60;
	}
}

void delay_ms(uchar t){
	uchar j;
	for(;t!=0; t--){
	  for (j=0;j<225;j++);
  }
}

void check_busy(){			   
	uchar flag=0xff;		   //使FLAG寄存器为全1；
	do{
		E=0;					//写之前设E=0
		RS=0;					//选择指令寄存器
		RW=1;				   //选择读命令
		E=1;					//读完设E=0
		flag=out;
	}while(flag&0x80); //??BF?
	E=0;
}

void write_command(uchar com){		   
	check_busy();					   //检查是否处于工作状态
	E=0;							   //选择指令寄存器，写命令并将E设为0；
	RS=0;
	RW=0;
	out=com;							
	delay_ms(5);
	E=1; //延时5ms后将E设为1
	delay_ms(5);
	E=0;
	delay(1);
}

void write_data(uchar wdata){		 
	check_busy();
	E=0;
	RS=1;
	RW=0;
	out=wdata;
	delay_ms(5);
	E=1; //???????,????
	delay_ms(5);
	E=0;
	delay(1);
}

void lcd_initial(){			
	write_command(0x38);//8位总线进行双行显示
	write_command(0x0f);//开整体显示，光标关，无闪烁
	write_command(0x06);//光标右移
	write_command(0x01);//清屏
	delay(1);
}

void string(uchar address,uchar *s)
{
	unsigned char i;
	write_command(address); 		 
	for(i=0;s[i]!='\0';i++)			//输出
	{
		write_data(s[i]);
	}
}
