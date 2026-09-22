DATAS SEGMENT ; 数据段
    PROMPT DB 'Generated random digit is:',13,10,'$' ; 提示信息
DATAS ENDS

STACKS SEGMENT stack ; 栈段
    DB 16 DUP(0) ; 分配16字节的栈空间
STACKS ENDS

CODES SEGMENT ; 代码段
    ASSUME CS:CODES, DS:DATAS, SS:STACKS ; 段寄存器假设

BEGIN:
    MOV AX, DATAS ; 获取数据段地址
    MOV DS, AX ; 设置DS寄存器
    MOV AX, STACKS ; 获取栈段地址
    MOV SS, AX ; 设置SS寄存器

    PUSH DS ; 保存DS，因为后续操作会修改DS
    MOV AX, OFFSET RANDOM_GEN ; 获取中断子程序的偏移地址
    MOV DX, AX ; 将偏移地址存入DX
    MOV AX, SEG RANDOM_GEN ; 获取中断子程序的段地址
    MOV DS, AX ; 设置DS为中断子程序的段地址
    MOV AL, 86H ; 设置中断号为86H
    MOV AH, 25H ; 设置功能号为25H，用于修改中断向量表
    INT 21H ; 调用中断，修改中断向量表
    POP DS ; 恢复DS寄存器

    ; 输出提示信息
    MOV AH, 09H ; 设置功能号为09H，显示字符串
    LEA DX, PROMPT ; 将PROMPT的地址加载到DX
    INT 21H ; 调用中断，显示字符串

    ; 调用自定义中断INT 86H
    INT 86H ; 触发中断，执行RANDOM_GEN

    ; 程序退出
    MOV AH, 4CH ; 设置功能号为4CH，程序退出
    INT 21H ; 调用中断，退出程序

RANDOM_GEN:
    MOV AH, 00H ; 设置功能号为00H，读取系统时钟计数器
    INT 1AH ; 读取时钟计数器值，CX:DX存储计数器值
    MOV AX, DX ; 将DX的值存入AX
    XOR DX, DX ; 清零DX
    MOV CX, 09H ; 设置除数为9
    DIV CX ; 除以9，获得0~8的余数
    INC DL ; 余数加1，得到1~9的随机数
    ADD DL, 30H ; 转换为ASCII码
    MOV AH, 02H ; 设置功能号为02H，显示字符
    INT 21H ; 调用中断，显示随机数
    IRET ; 中断返回

CODES ENDS
    END BEGIN ; 程序入口点
