#include "stm32f10x.h"                  // Device header
#include "Delay.h"

/**
  * 函    数：按键初始化 
  * 参    数：无
  * 返 回 值：无
  */
void Key_Init(void)
{
	/*开启时钟*/
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);		//开启GPIOB的时钟
	
	/*GPIO初始化*/
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14 | GPIO_Pin_15 | GPIO_Pin_12 | GPIO_Pin_13;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure);						
}

/**
  * 函    数：按键获取键码
  * 参    数：无
  * 返 回 值：按下按键的键码值，范围：0~4，返回0代表没有按键按下
  * 注意事项：此函数1~3号按键有长按功能，当1~3号按键按住不放时，可以连续返回键码值
  */
uint8_t Key_GetNum(void)
{
	uint8_t KeyNum = 0;		//定义变量，默认键码值为0
	uint32_t Temp = 300000;	//临时用的计时变量
	
	if (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_12) == 0)			//读PB11输入寄存器的状态，如果为0，则代表按键1按下
	{
		Delay_ms(20);											//延时消抖
		while (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_12) == 0)	//等待按键松手，或长按连续返回值
		{
			Temp--;
			if(Temp == 0)
			{
				Delay_ms(20);
				return 1;
			}
		}
		Delay_ms(20);											//延时消抖
		KeyNum = 1;												//置键码为1
	}
	
	if (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_13) == 0)			//读PB10输入寄存器的状态，如果为0，则代表按键2按下
	{
		Delay_ms(20);											//延时消抖
		while (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_13) == 0)	//等待按键松手，或长按连续返回值
		{
			Temp--;
			if(Temp == 0)
			{
				Delay_ms(20);
				return 2;
			}			
		}
		Delay_ms(20);											//延时消抖
		KeyNum = 2;												//置键码为2
	}
	
	if (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_14) == 0)			//读PB1输入寄存器的状态，如果为0，则代表按键3按下
	{
		Delay_ms(20);											//延时消抖
		while (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_14) == 0)	//等待按键松手，或长按连续返回值
		{
			Temp--;
			if(Temp == 0)
			{
				Delay_ms(20);
				return 3;
			}
		}
		Delay_ms(20);											//延时消抖
		KeyNum = 3;												//置键码为3
	}

	if (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_15) == 0)			//读PB0输入寄存器的状态，如果为0，则代表按键4按下
	{
		Delay_ms(20);											//延时消抖
		while (GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_15) == 0);	//等待按键松手
		Delay_ms(20);											//延时消抖
		KeyNum = 4;												//置键码为4
	}

	return KeyNum;			//返回键码值，如果没有按键按下，所有if都不成立，则键码为默认值0
}
