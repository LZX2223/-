#include "stm32f10x.h"                  // Device header
#include "Delay.h"						//延时模块，主函数中未使用
#include "OLED.h"						//OLED显示模块
#include "MyRTC.h"						//RTC模块
#include "Key.h"						//按键模块
#include "Buzzer.h"	                    //蜂鸣器模块
#include "Encode.h"                     //旋转编码器模块
#include "LED.h"                        //LED灯模块
#include "EncodeLight.h"                //旋转编码器+LED灯模块
#include "KeyControl.h"                 //按键控制模块
              

/*
	功能：	简易时钟，可以通过按键调整日期时间和设定闹钟，通过OLED显示日期时间等相关信息
	原理：	RTC
	接线：	OLED显示屏：SCK接PB8，SDA接PB9
			有源蜂鸣器（低电平触发）：I/O接PBA8
			1~4号独立按键：分别接PB12，PB13，PB14，PB15
*/

int main(void)
{   void Key_Control(void);//函数声明
	/*模块初始化*/
	OLED_Init();		//OLED初始化
	MyRTC_Init();		//RTC初始化
	Key_Init();			//按键初始化
	Buzzer_Init();		//蜂鸣器初始化
		
	
	OLED_ShowString(1, 1, "Date:XXXX-XX-XX");
	OLED_ShowString(2, 1, "Time:XX:XX:XX");
	OLED_ShowString(3, 1, "Alarm:XX:XX:XX");
	
	while (1)
	{
		MyRTC_ReadTime();							//RTC读取时间，最新的时间存储到MyRTC_Time数组中
		Key_Control();								//调用按键控制函数

		OLED_ShowNum(1, 6, MyRTC_Time[0], 4);		//显示MyRTC_Time数组中的时间值，年
		OLED_ShowNum(1, 11, MyRTC_Time[1], 2);		//月
		OLED_ShowNum(1, 14, MyRTC_Time[2], 2);		//日
		OLED_ShowNum(2, 6, MyRTC_Time[3], 2);		//时
		OLED_ShowNum(2, 9, MyRTC_Time[4], 2);		//分
		OLED_ShowNum(2, 12, MyRTC_Time[5], 2);		//秒
		
		
		if(Flag_Count)										//正在计时，则显示闹钟响起剩余时间
		{
			Alarm_Time = Alarm_CNT-RTC_GetCounter()+1;	//计算闹钟响起剩余时间
			
			
			OLED_ShowNum(3,7,Alarm_Time/3600,2);		//显示剩余小时
			OLED_ShowNum(3,10,(Alarm_Time%3600)/60,2);	//显示剩余分钟
			OLED_ShowNum(3,13,(Alarm_Time%3600)%60,2);	//显示剩余秒
			
			if(RTC_GetFlagStatus(RTC_FLAG_ALR) == SET)		//闹钟时间到，检查标志位为1
			{
				RTC_ClearFlag(RTC_FLAG_ALR);				//清除标志位
				Flag_Count = 0;Alarm_Time = 0;				//重置相关参数
				Hour = 0;Min = 0; Sec = 0;
				
				Buzzer_ON();								//打开蜂鸣器
				OLED_ShowString(4,1,"Time Out");
			}
			else											//闹钟时间未到
			{
				OLED_ShowString(4,1,"Counting");			//显示正在计时
			}
		}
		else												//不在计时状态，则显示需要设定的闹钟时间
		{
			OLED_ShowNum(3,7,Hour,2);
			OLED_ShowNum(3,10,Min,2);
			OLED_ShowNum(3,13,Sec,2);
		}
		
		if(Mode_Change == 1)		//显示“调节日期”
		{
			OLED_ShowString(4,1,"Change Date");
		}
		else if(Mode_Change == 2)	//显示“调节时间”
		{
			OLED_ShowString(4,1,"Change Time");
		}
		EncodeLight();
	}
}
