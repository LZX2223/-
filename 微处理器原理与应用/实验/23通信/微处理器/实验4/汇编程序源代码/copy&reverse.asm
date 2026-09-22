DATAS SEGMENT ; 数据段定义
    STRING_INI DB 'The School of Information Science and Engineering Shandong University$' ; 初始字符串
    LENGTH_INI EQU $-STRING_INI ; 计算字符串长度（包含$）
    TIP_A DB 'string original:',13,10,'$' ; 提示信息
    TIP_B DB 13,10,'copied:',13,10,'$'
    TIP_C DB 13,10,'reversed:',13,10,'$'
    CR DB 13,10,'$' ; 换行符
DATAS ENDS

EXT SEGMENT ; 附加段定义
    STRING_DUP DB 100 DUP('$') ; 复制字符串缓冲区
    STRING_VER DB 100 DUP('$') ; 反转字符串缓冲区
EXT ENDS

STACKS SEGMENT STACK ; 堆栈段定义
    DB 256 DUP(?) ; 预分配256字节堆栈空间
STACKS ENDS

CODES SEGMENT ; 代码段定义
    ASSUME CS:CODES, DS:DATAS, ES:EXT, SS:STACKS ; 段寄存器关联

START:
    ; 初始化段寄存器
    MOV AX, DATAS
    MOV DS, AX ; 设置数据段地址
    MOV AX, EXT
    MOV ES, AX ; 设置附加段地址
    MOV AX, STACKS
    MOV SS, AX ; 设置堆栈段地址

    ; 显示初始字符串提示TIP_A
    MOV AH, 09H ; DOS功能号：显示字符串
    LEA DX, TIP_A ; 加载提示信息地址
    INT 21H ; 调用中断

    ; 显示原始字符串STRING_INI
    MOV AH, 09H
    LEA DX, STRING_INI ; 加载原始字符串地址
    INT 21H

    ; 显示换行
    MOV AH, 09H
    LEA DX, CR
    INT 21H

    ; 复制字符串到STRING_DUP
    LEA SI, STRING_INI ; SI指向源字符串
    LEA DI, ES:STRING_DUP ; DI指向目标缓冲区（附加段）
    MOV CX, LENGTH_INI ; 设置复制长度
    CLD ; 方向标志：正向
    REP MOVSB ; 重复字节复制（CX次）

    ; 显示复制提示TIP_B
    MOV AH, 09H
    LEA DX, TIP_B
    INT 21H

    ; 显示复制后的STRING_DUP
    PUSH DS ; 保存当前DS
    MOV AX, ES
    MOV DS, AX ; 临时切换DS到附加段
    MOV AH, 09H
    LEA DX, STRING_DUP ; 加载目标字符串地址
    INT 21H
    POP DS ; 恢复原DS

    ; 显示换行
    MOV AH, 09H
    LEA DX, CR
    INT 21H

    ; 反转字符串到STRING_VER
    LEA SI, STRING_INI ; SI指向源字符串起始
    LEA DI, ES:STRING_VER ; DI指向目标缓冲区

    ; 计算SI到最后一个有效字符位置（跳过末尾$）
    MOV CX, LENGTH_INI
    SUB CX, 2 ; 移动次数=长度-2
    JBE NO_MOVE ; 若长度<=2无需移动
    ADD SI, CX ; SI调整至倒数第二个字符
NO_MOVE:

    ; 设置反转循环次数
    MOV CX, LENGTH_INI
    DEC CX ; 循环次数=长度-1

REVERSE_LOOP:
    MOV AL, [SI] ; 从后往前取字符
    MOV ES:[DI], AL ; 存入目标缓冲区
    DEC SI ; 前移源指针
    INC DI ; 后移目标指针
    LOOP REVERSE_LOOP ; 循环直至CX=0

    ; 显示反转提示TIP_C
    MOV AH, 09H
    LEA DX, TIP_C
    INT 21H

    ; 显示反转后的STRING_VER
    PUSH DS ; 保存当前DS
    MOV AX, ES
    MOV DS, AX ; 临时切换DS到附加段
    MOV AH, 09H
    LEA DX, STRING_VER
    INT 21H
    POP DS ; 恢复原DS

    ; 显示换行
    MOV AH, 09H
    LEA DX, CR
    INT 21H

    ; 程序终止
    MOV AH, 4CH ; DOS功能号：退出程序
    INT 21H

CODES ENDS
    END START ; 程序入口点
