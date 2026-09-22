DATAS SEGMENT ; 数据段开始
    MSG DB 'random',13,10,'$' ; 提示信息，告知用户将生成一个1~9的随机数
DATAS ENDS ; 数据段结束

STACKS SEGMENT stack ; 栈段开始
    DW 8 DUP (0) ; 分配16字节的栈空间
STACKS ENDS ; 栈段结束

CODES SEGMENT ; 代码段开始
    ASSUME CS:CODES, DS:DATAS, SS:STACKS ; 设置段寄存器的假设

MAIN:
    MOV AX, DATAS ; 将数据段地址加载到AX寄存器
    MOV DS, AX ; 将AX寄存器的值赋给DS寄存器，设置数据段
    MOV AX, STACKS ; 将栈段地址加载到AX寄存器
    MOV SS, AX ; 将AX寄存器的值赋给SS寄存器，设置栈段

    XOR AX, AX ; 清零AX寄存器
    MOV ES, AX ; 将ES寄存器指向中断向量表所在的段地址
    MOV BX, 0218H ; 计算中断号为INT 86H的中断子程序首物理地址
    LEA AX, RANDOM ; 获取中断子程序的偏移地址
    MOV ES:WORD PTR[BX], AX ; 将中断子程序的偏移地址写入中断向量表
    MOV AX, CS ; 获取中断子程序的段地址
    MOV ES:WORD PTR[BX+2], AX ; 将中断子程序的段地址写入中断向量表

    ; 输出提示字符串MSG
    MOV AH, 09H ; 设置AH寄存器为09H，准备使用INT 21H中断显示字符串
    LEA DX, MSG ; 将MSG的偏移地址加载到DX寄存器
    INT 21H ; 调用中断，显示字符串

    ; 调用中断INT 86H，使程序通过中断向量表指向中断子程序RANDOM
    INT 86H ; 触发中断，执行RANDOM中断服务程序

    ; 退出程序的中断
    MOV AH, 4CH ; 设置AH寄存器为4CH，准备退出程序
    INT 21H ; 调用中断，退出程序

RANDOM:
    MOV AH, 00H ; 设置INT 1AH的功能号为00H，读取系统时钟计数器
    INT 1AH ; 读取时钟计数器值，CX:DX存储计数器值，CX为高位，DX为低位
    MOV AX, DX ; 将DX（时钟计数器的低16位）的值存入AX作为除法的低八位
    XOR DX, DX ; 将DX置零，作为除法的高八位
    MOV CX, 09H ; 将9存入CX，作为除数
    DIV CX ; 除以9获得0-8的随机数
    INC DL ; 使DL自增1，从而得到1~9的随机数
    ADD DL, 30H ; 将余数转换为ASCII码
    MOV AH, 2 ; 设置AH寄存器为2，准备使用INT 21H中断显示字符
    INT 21H ; 调用中断，显示随机数字符
    IRET ; 中断返回

CODES ENDS
    END MAIN ; 指定程序入口

