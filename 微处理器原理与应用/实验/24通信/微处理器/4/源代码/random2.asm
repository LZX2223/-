DATAS SEGMENT                              ; 数据段开始
    MSG DB 'random',13,10,'$'              ; 提示信息告知用户即将显示1到9随机数
DATAS ENDS                                 ; 数据段结束

STACKS SEGMENT stack                       ; 栈段开始
    DW 8 DUP (0)                           ; 分配16字节的栈空间
STACKS ENDS                                ; 栈段结束

CODES SEGMENT                              ; 代码段开始
    ASSUME CS:CODES, DS:DATAS, SS:STACKS   ; 设置段寄存器的假设

MAIN:                                      ; 程序主入口
    MOV AX, DATAS                          ; 将数据段地址加载到AX寄存器
    MOV DS, AX                             ; 设置DS指向数据段
    MOV AX, STACKS                         ; 将栈段地址加载到AX寄存器
    MOV SS, AX                             ; 设置SS指向栈段

    MOV AH, 09H                            ; 设置AH为09H准备显示提示字符串
    LEA DX, MSG                            ; DX指向提示信息地址
    INT 21H                                ; 调用DOS中断显示提示信息

    CALL RANDOM                            ; 调用RANDOM子程序生成并显示随机数

    MOV AH, 4CH                            ; 设置AH为4CH准备结束程序
    INT 21H                                ; 调用DOS中断退出程序

RANDOM:                                    ; 随机数生成子程序标号
    MOV AH, 2CH                            ; 设置AH为2CH准备获取系统时间
    INT 21H                                ; 调用DOS中断获取当前时间
    MOV AL, DL                             ; 取毫秒值作为随机种子
    MOV AH, 0                              ; 清零AH准备除法
    MOV BL, 9                              ; 设置除数为9
    DIV BL                                 ; 除以9得到0到8的余数
    INC AH                                 ; 余数加1得到1到9的随机数
    ADD AH, 30H                            ; 转换为ASCII字符
    MOV DL, AH                             ; DL存放要显示的字符
    MOV AH, 2                              ; 设置AH为2准备显示单个字符
    INT 21H                                ; 调用DOS中断显示随机数
    RET                                    ; 子程序返回

CODES ENDS                                 ; 代码段结束
END MAIN                                   ; 指定程序入口点
