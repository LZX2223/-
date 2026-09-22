#include "stm32f10x.h"                  // Device header

/**
  * 函    数：蜂鸣器初始化
  * 参    数：无
  * 返 回 值：无
  */
void Buzzer_Init(void)
{
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE);	//开启GPIOB时钟
	
	GPIO_InitTypeDef GPIO_InitStructure;					//定义GPIOB初始化结构体
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;		//GPIOB推挽输出模式
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8;				//使用GPIOB12引脚
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	
	GPIO_Init(GPIOA,&GPIO_InitStructure);					//初始化GPIOB
	
	GPIO_SetBits(GPIOA,GPIO_Pin_8);						//GPIOB12引脚默认初始为1，即蜂鸣器默认关
}

/**
  * 函    数：蜂鸣器开
  * 参    数：无
  * 返 回 值：无
  */
void Buzzer_ON(void)
{
	GPIO_ResetBits(GPIOA,GPIO_Pin_8);
}

/**
  * 函    数：蜂鸣器关
  * 参    数：无
  * 返 回 值：无
  */
void Buzzer_OFF(void)
{
	GPIO_SetBits(GPIOA,GPIO_Pin_8);
}

/**
  * 函    数：蜂鸣器翻转
  * 参    数：无
  * 返 回 值：无
  */
void Buzzer_TURN(void)
{
	if(GPIO_ReadOutputDataBit(GPIOA,GPIO_Pin_8) == 0)
	{
		GPIO_SetBits(GPIOA,GPIO_Pin_8);
	}
	else
	{
		GPIO_ResetBits(GPIOA,GPIO_Pin_8);
	}
}

/**
  * 函    数：读取蜂鸣器状态，即是否在运行
  * 参    数：无
  * 返 回 值：蜂鸣器在运行则返回1，不在运行则返回0
  */
uint8_t Buzzer_State(void)
{
	if(GPIO_ReadOutputDataBit(GPIOA,GPIO_Pin_8) == 0)
		return 1;
	else
		return 0;
}
