#include "stm32f10x.h" 
#include "MyRTC.h"
#include "Key.h"// Device header
#include "Buzzer.h"
#include "OLED.h"
		//定义全局的时间数组，数组内容分别为年、月、日、时、分、秒
uint32_t Alarm_CNT,Alarm_Time;	/*闹钟相关变量，分别为写入RTC_ALR寄存器的时间（即当前时间戳+设定闹钟的时间），设定闹钟的时间


单位秒*/
uint8_t Hour,Min,Sec;							//用来调整闹钟时间的变量
uint8_t KeyNum;									//按键键码值
uint8_t Flag_Count;								//是否在计时标志，0为不在计时
uint8_t Mode_Change;							//按键调节闹钟/日期/时间，0为调节闹钟，1为调节日期，2为调节时间

void Key_Control(void)
{
	KeyNum = Key_GetNum();	//读取按键键码
	
	if(Mode_Change == 0)	//调节闹钟
	{
		if(KeyNum == 1)		//1号按键调整小时
		{
			Hour++;
			if(Hour > 60)
				Hour = 0;
		}
		else if(KeyNum == 2)	//2号按键调整分钟
		{
			Min++;
			if(Min > 60)
				Min = 0;
		}
		else if(KeyNum == 3)	//3号按键调整秒
		{
			Sec++;
			if(Sec > 60)
				Sec = 0;
		}

		else if(KeyNum == 4)	//4号按键
		{
			if(Buzzer_State()==0)		//若蜂鸣器没响
			{
				Alarm_Time = Hour*3600 + Min*60 + Sec;			//计算闹钟时长，单位是秒
				
				if(Alarm_Time > 0)
				{
					Alarm_CNT = RTC_GetCounter()+Alarm_Time-1;			//设定闹钟值，需要-1
					RTC_SetAlarm(Alarm_CNT);							//写入闹钟值到RTC的ALR寄存器
					Flag_Count = 1;
				}
				else	//若闹钟时长为0，则转到按键调节日期
				{
					Mode_Change = 1;	
				}
			}
			
			
			else	//若蜂鸣器响
			{
				Buzzer_OFF();		//关闭蜂鸣器
				OLED_ShowString(4,1,"        ");	//刷新oled第四行	
			}
		}
	}
	
	else if(Mode_Change == 1)		//调节日期
	{
		if(KeyNum == 1)			//1号按键调整年
		{
			MyRTC_Time[0]++;
			MyRTC_SetTime();
		}
		else if(KeyNum == 2)	//2号按键调整月
		{
			MyRTC_Time[1]++;
			MyRTC_SetTime();
		}
		else if(KeyNum == 3)	//3号按键调整日
		{
			MyRTC_Time[2]++;
			MyRTC_SetTime();
		}
		else if(KeyNum == 4)	//4号按键，改为调整时间
		{
			Mode_Change = 2;
		}			
	}
	
	else if(Mode_Change == 2)		//调节时间
	{
		if(KeyNum == 1)			//1号按键调整小时
		{
			MyRTC_Time[3]++;
			MyRTC_SetTime();
		}
		else if(KeyNum == 2)	//2号按键调整分钟
		{
			MyRTC_Time[4]++;
			MyRTC_SetTime();
		}
		else if(KeyNum == 3)	//3号按键调整秒
		{
			MyRTC_Time[5]++;
			MyRTC_SetTime();
		}
		else if(KeyNum == 4)	//4号按键
		{
			Mode_Change = 0;	//改为调整闹钟
			OLED_ShowString(4,1,"            ");	//刷新oled第四行
		}			
	}

}
