DATAS SEGMENT ; 数据段
    MSG_INPUT DB 'scores:',13,10,'$' ; 提示输入10个学生的成绩
    MSG_60 DB 13,10,'60~69:',13,10,'$' ; 提示60~69分的人数
    MSG_70 DB 13,10,'70~79:',13,10,'$' ; 提示70~79分的人数
    MSG_80 DB 13,10,'80~89:',13,10,'$' ; 提示80~89分的人数
    MSG_90 DB 13,10,'90~99:',13,10,'$' ; 提示90~99分的人数
    MSG_100 DB 13,10,'100:',13,10,'$' ; 提示100分的人数

    COUNT_60 DB '0','$' ; 存放60~69分的人数，初始为'0'
    COUNT_70 DB '0','$' ; 存放70~79分的人数，初始为'0'
    COUNT_80 DB '0','$' ; 存放80~89分的人数，初始为'0'
    COUNT_90 DB '0','$' ; 存放90~99分的人数，初始为'0'
    COUNT_100 DB '0','$' ; 存放100分的人数，初始为'0'
DATAS ENDS

STACKS SEGMENT stack ; 栈段
    DB 16 DUP (?) ; 分配16字节的栈空间
STACKS ENDS

CODES SEGMENT ; 代码段
    ASSUME CS:CODES, DS:DATAS, SS:STACKS ; 段寄存器假设

MAIN:
    MOV AX, DATAS ; 获取数据段地址
    MOV DS, AX ; 设置DS寄存器
    MOV AX, STACKS ; 获取栈段地址
    MOV SS, AX ; 设置SS寄存器

    ; 显示输入提示信息
    MOV AH, 09H ; 设置功能号为09H，显示字符串
    LEA DX, MSG_INPUT ; 将MSG_INPUT的地址加载到DX
    INT 21H ; 调用中断，显示字符串

    MOV CX, 10 ; 设置循环次数为10
INPUT_LOOP:
    MOV AH, 01H ; 设置功能号为01H，从键盘读取字符
    INT 21H ; 调用中断，读取第一个字符
    CALL CLASSIFY ; 调用CLASSIFY过程，分类分数
    MOV AH, 01H ; 再次读取第二个字符
    INT 21H ; 调用中断，读取第二个字符
    MOV AH, 02H ; 设置功能号为02H，显示字符
    MOV DL, ' ' ; 显示空格
    INT 21H ; 调用中断，显示空格
    LOOP INPUT_LOOP ; 循环10次

    ; 显示各分数段的人数
    MOV AH, 09H ; 设置功能号为09H，显示字符串
    LEA DX, MSG_60 ; 显示60~69分的人数提示
    INT 21H
    LEA DX, COUNT_60 ; 显示60~69分的人数
    INT 21H

    LEA DX, MSG_70 ; 显示70~79分的人数提示
    INT 21H
    LEA DX, COUNT_70 ; 显示70~79分的人数
    INT 21H

    LEA DX, MSG_80 ; 显示80~89分的人数提示
    INT 21H
    LEA DX, COUNT_80 ; 显示80~89分的人数
    INT 21H

    LEA DX, MSG_90 ; 显示90~99分的人数提示
    INT 21H
    LEA DX, COUNT_90 ; 显示90~99分的人数
    INT 21H

    LEA DX, MSG_100 ; 显示100分的人数提示
    INT 21H
    LEA DX, COUNT_100 ; 显示100分的人数
    INT 21H

    ; 程序退出
    MOV AH, 4CH ; 设置功能号为4CH，程序退出
    INT 21H ; 调用中断，退出程序

CLASSIFY PROC NEAR
    CMP AL, '1' ; 与字符'1'比较
    JE SCORE_100 ; 如果等于，跳转到SCORE_100
    CMP AL, '9' ; 与字符'9'比较
    JE SCORE_90 ; 如果等于，跳转到SCORE_90
    CMP AL, '8' ; 与字符'8'比较
    JE SCORE_80 ; 如果等于，跳转到SCORE_80
    CMP AL, '7' ; 与字符'7'比较
    JE SCORE_70 ; 如果等于，跳转到SCORE_70
    CMP AL, '6' ; 与字符'6'比较
    JE SCORE_60 ; 如果等于，跳转到SCORE_60
    RET ; 返回主程序

SCORE_60:
    INC COUNT_60 ; 60~69分人数加1
    JMP DONE ; 跳转到DONE
SCORE_70:
    INC COUNT_70 ; 70~79分人数加1
    JMP DONE ; 跳转到DONE
SCORE_80:
    INC COUNT_80 ; 80~89分人数加1
    JMP DONE ; 跳转到DONE
SCORE_90:
    INC COUNT_90 ; 90~99分人数加1
    JMP DONE ; 跳转到DONE
SCORE_100:
    INC COUNT_100 ; 100分人数加1
    MOV AH, 01H ; 再次读取字符，处理100分的情况
    INT 21H ; 调用中断，读取字符
DONE:
    RET ; 返回主程序
CLASSIFY ENDP

CODES ENDS
    END MAIN ; 程序入口点
