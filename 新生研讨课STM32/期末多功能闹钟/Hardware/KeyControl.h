#ifndef __KEY_CONTROL_H
#define __KEY_CONTROL_H
void KEY_CONTROL(void);
extern uint8_t Hour,Min,Sec;							//用来调整闹钟时间的变量
extern uint8_t KeyNum;									//按键键码值
extern uint32_t Alarm_CNT,Alarm_Time;					//是否在计时标志，0为不在计时
extern uint8_t Mode_Change;	
extern uint8_t Flag_Count;//按键调节闹钟/日期/时间，0为调节闹钟，1为调节日期，2为调节时间
#endif
