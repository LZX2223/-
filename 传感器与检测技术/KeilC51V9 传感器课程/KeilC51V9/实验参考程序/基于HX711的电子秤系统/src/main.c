#include "main.h"       // 引入主头文件，通常包含单片机寄存器定义、基本数据类型定义以及全局宏定义
#include "1602.h"       // 引入 LCD1602 液晶屏驱动头文件，用于调用 LCD 初始化、清屏、显示字符等函数
#include "HX711.h"      // 引入 HX711 称重模块头文件，用于调用 HX711_Read() 读取传感器数据
#include "delay.h"      // 引入延时函数头文件，用于调用 delay_ms() 等延时函数
#include "uart.h"       // 引入串口通信头文件，用于调用 uart_init() 和 send_data() 等串口函数

unsigned long HX711_Buffer = 0;                    // 定义无符号长整型变量 HX711_Buffer；unsigned 表示不能存负数，long 表示长整型，占用字节更多，可存较大
                                                   //的 HX711 原始数据

unsigned long Weight_Maopi = 0, Weight_Shiwu = 0;  // 定义两个无符号长整型变量；Weight_Maopi 用于保存空载毛皮值，Weight_Shiwu 用于保存去皮后的实际重量值

void Get_Maopi(void)                               // 定义 Get_Maopi 函数；void 表示该函数没有返回值，括号里的 void 表示该函数没有参数
{                                                   // Get_Maopi 函数开始

    HX711_Buffer = HX711_Read();                    // 调用 HX711_Read() 函数读取 HX711 模块输出的原始称重数据，并保存到 HX711_Buffer 中

    Weight_Maopi = HX711_Buffer / 100;              // 将 HX711 原始数据除以 100 进行缩小处理，并作为空载基准值保存到 Weight_Maopi 中

}                                                   // Get_Maopi 函数结束

void Get_Weight(void)                              // 定义 Get_Weight 函数；该函数用于读取当前重量并计算实际物体重量
{                                                   // Get_Weight 函数开始

    HX711_Buffer = HX711_Read();                    // 读取 HX711 当前输出的数据，也就是当前压力传感器对应的原始采样值

    HX711_Buffer = HX711_Buffer / 100;              // 将当前读取到的原始数据除以 100，使其和 Weight_Maopi 的处理方式保持一致

    if(HX711_Buffer >= Weight_Maopi)                // 判断当前读数是否大于或等于空载毛皮值；如果小于毛皮值，可能会出现负重量，所以不进行计算
    {                                               // if 条件语句开始

        Weight_Shiwu = HX711_Buffer;                // 将当前读取到的传感器数据先保存到 Weight_Shiwu 中

        Weight_Shiwu = Weight_Shiwu - Weight_Maopi; // 当前值减去空载毛皮值，得到去皮后的净重量对应数据

        Weight_Shiwu = (unsigned int)((float)Weight_Shiwu / 3.95 + 0.05); // 将净重量数据先强制转换为float浮点数参与小数运算，再除以校准系数 3.95，最后
		                                                                  //转换成 unsigned int无符号整型保存

    }                                               // if 条件语句结束

}                                                   // Get_Weight 函数结束

void main()                                        // 定义主函数 main；单片机程序从 main 函数开始执行
{                                                   // main 主函数开始

    uart_init();                                    // 初始化串口，使单片机具备串口发送或调试输出的能力

    lcd_init();                                     // 初始化 LCD1602 液晶显示屏，使 LCD 进入正常工作状态

    lcd_display_str(0, 1, "Welcome to use! ");      // 在 LCD1602 上显示欢迎语；第一个参数 0 表示起始列，第二个参数 1 表示显示行

    delay_ms(1000);                                 // 延时 1000 毫秒，也就是延时 1 秒，让欢迎界面显示一段时间

    lcd_clear();                                    // 清除 LCD1602 屏幕上的所有显示内容，准备进入称重显示界面

    lcd_display_str(0, 1, "WEIGHT:         ");      // 在 LCD1602 上显示字符串 WEIGHT，提示当前界面用于显示重量

    Get_Maopi();                                    // 调用 Get_Maopi() 函数获取毛皮值；执行时称重台上最好不要放物体，相当于电子秤去皮

    while(1)                                        // 进入无限循环；1 恒为真，所以程序会一直重复执行循环体
    {                                               // while 循环开始

        Get_Weight();                               // 调用 Get_Weight() 函数，读取 HX711 当前数据并计算实际重量

        // send_data((Weight_Shiwu*100)>>16);       // 串口发送重量数据的高 8 位；当前被注释掉，不参与程序运行

        // send_data((Weight_Shiwu*100)>>8);        // 串口发送重量数据的中间 8 位；当前被注释掉，不参与程序运行

        // send_data(Weight_Shiwu*100);             // 串口发送重量数据的低 8 位；当前被注释掉，不参与程序运行

        write_command(0x80 + 0x40);                 // 向 LCD1602 写入命令，设置光标到第二行第一列；0x80 是设置地址命令，0x40 是第二行起始地址

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 1 个字符

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 2 个字符

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 3 个字符

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 4 个字符

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 5 个字符

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 6 个字符

        write_data(' ');                            // 写入空格，用于清除上一轮重量显示留下的第 7 个字符

        write_command(0x80 + 0x40);                 // 再次设置光标回到第二行第一列，准备从头显示新的重量数据

        if(Weight_Shiwu / 10000 != 0)               // 判断重量的万位是否不为 0；如果万位为 0，就不显示，避免前面出现多余的 0
            write_data(Weight_Shiwu / 10000 + 0x30); // 取出万位数字并加 0x30 转成 ASCII 字符；例如数字 1 加 0x30 后就是字符 '1'

        if(Weight_Shiwu / 1000 != 0)                // 判断重量的千位及以上是否不为 0；如果不为 0，则需要显示千位
            write_data((Weight_Shiwu % 10000) / 1000 + 0x30); // 先对 10000 取余去掉万位，再除以 1000 得到千位数字，并转换成字符显示

        // write_data('.');                         // 显示小数点的语句；当前被注释掉，如果需要显示小数可以取消注释

        if(Weight_Shiwu / 100 != 0)                 // 判断重量的百位及以上是否不为 0；如果不为 0，则需要显示百位
            write_data(((Weight_Shiwu % 10000) % 1000) / 100 + 0x30); // 通过取余和除法提取百位数字，再加 0x30 转换成字符显示

        if(Weight_Shiwu / 10 != 0)                  // 判断重量的十位及以上是否不为 0；如果不为 0，则需要显示十位
            write_data((((Weight_Shiwu % 10000) % 1000) % 100) / 10 + 0x30); // 通过连续取余和除法提取十位数字，再转换成字符显示

        write_data((((Weight_Shiwu % 10000) % 1000) % 100) % 10 + 0x30); // 提取个位数字并显示；个位始终显示，保证重量为 0 时也能显示字符 '0'

        write_data(' ');                            // 在数字后面显示一个空格，使重量数值和单位之间有间隔

        // write_data('K');                         // 显示大写字母 K 的语句；当前被注释掉，如果要显示 Kg 单位可以取消注释

        write_data('g');                            // 显示重量单位 g，表示当前重量单位是克

    }                                               // while 循环结束；由于 while(1) 是无限循环，程序正常情况下不会跳出这里

}                                                   // main 主函数结束