#include "stm32f10x.h"                  // Device header
#include "LED.h"
#include "Encode.h"
int16_t Num;
void EncodeLight(void){
Encoder_Init();		//旋转编码器初始化
LED_Init();
	
Num += Encoder_Get();		
 if( Num>3) LED1_ON();else LED1_OFF();
 if( Num>6) LED2_ON();else LED2_OFF();
 if( Num>9) LED3_ON();else LED3_OFF();
 if( Num>12) LED4_ON();else LED4_OFF();	//获取自上此调用此函数后，旋转编码器的增量值，并将增量值加到Num上
			
	
}
