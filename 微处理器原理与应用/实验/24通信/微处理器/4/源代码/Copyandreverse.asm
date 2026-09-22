DATAS SEGMENT                              ; 定义数据段DATAS（存放所有字符串和提示信息）
    string_a     db 'The School of Information Science and Engineering Shandong University','$'   ; 定义源字符串string_a，以'$'作为DOS显示结束符
    string_b     db 100 dup(?)             ; 定义目标字符串string_b，预留100字节空间，用于存放复制结果（题目要求）
    msg_original db 'string original:$'    ; 定义“string original:”标签，用于显示原始字符串
    msg_copied   db 0Dh,0Ah,'copied:$'    ; 定义“copied:”标签，前面加0Dh,0Ah实现换行
    msg_reversed db 0Dh,0Ah,'reversed:$'   ; 定义“reversed:”标签，前面加0Dh,0Ah实现换行
    msg_press    db 0Dh,0Ah,0Dh,0Ah,'Press any key to continue$'   ; 定义“Press any key to continue”提示信息，前面加两个换行
DATAS ENDS                                 ; 数据段DATAS定义结束

STACKS SEGMENT                             ; 定义堆栈段STACKS（题目要求必须编写堆栈段代码）
    db 200 dup(0)                          ; 分配200字节的堆栈空间，用于存放临时数据和返回地址
STACKS ENDS                                ; 堆栈段STACKS定义结束

CODES SEGMENT                              ; 定义代码段CODES（存放程序所有指令）
    ASSUME CS:CODES, DS:DATAS, SS:STACKS, ES:DATAS   ; 告诉汇编器：CS指向代码段、DS/ES都指向DATAS段（单段设计，最稳定）

START:                                     ; 程序入口标号（程序从这里开始执行）
    MOV AX, DATAS                          ; 把DATAS段的段地址装入AX寄存器
    MOV DS, AX                             ; 将AX中的段地址赋给DS，使DS指向数据段
    MOV ES, AX                             ; 将AX中的段地址赋给ES，使ES也指向同一数据段（便于字符串操作）

    ; 显示 string original: 
    LEA DX, msg_original                   ; DX指向“string original:”标签的偏移地址
    MOV AH, 9                              ; AH=9，表示调用DOS 9号功能（显示以$结尾的字符串）
    INT 21H                                ; 调用DOS中断21H，在屏幕显示“string original:”
    LEA DX, string_a                       ; DX指向源字符串string_a的偏移地址
    MOV AH, 9                              ; AH=9，准备显示原字符串
    INT 21H                                ; 调用DOS中断21H，显示原始字符串

    ; 使用 REP MOVSB 复制字符串
    LEA SI, string_a                       ; SI指向源字符串string_a的偏移地址
    LEA DI, string_b                       ; DI指向目标字符串string_b的偏移地址
    MOV CX, 70                             ; CX=70（字符串实际长度69个字符 + 1个'$'结束符）
    CLD                                    ; 清方向标志DF=0，使字符串操作正向进行（从低地址到高地址）
    REP MOVSB                              ; 重复执行MOVSB CX次，完成字符串从string_a到string_b的复制

    ; 显示 copied:
    LEA DX, msg_copied                     ; DX指向“copied:”标签的偏移地址
    MOV AH, 9                              ; AH=9，准备显示copied标签
    INT 21H                                ; 调用DOS中断21H，显示“copied:”并换行
    LEA DX, string_b                       ; DX指向复制后的字符串string_b的偏移地址
    MOV AH, 9                              ; AH=9，准备显示复制结果
    INT 21H                                ; 调用DOS中断21H，显示复制后的字符串

    ; 显示 reversed:
    LEA DX, msg_reversed                   ; DX指向“reversed:”标签的偏移地址
    MOV AH, 9                              ; AH=9，准备显示reversed标签
    INT 21H                                ; 调用DOS中断21H，显示“reversed:”并换行

    ; 倒序显示字符串（选做部分实现）
    MOV SI, OFFSET string_b + 68           ; SI指向string_b的最后一个有效字符（69个字符前一个位置）
    MOV CX, 69                             ; CX=69，要倒序打印的字符个数（不包含$）
REVERSE_LOOP:                              ; 倒序循环标号
    MOV DL, [SI]                           ; 把当前字符从[SI]取出放入DL
    MOV AH, 2                              ; AH=2，表示调用DOS 2号功能（显示单个字符）
    INT 21H                                ; 调用DOS中断21H，屏幕显示当前字符
    DEC SI                                 ; SI减1，指向前一个字符
    LOOP REVERSE_LOOP                      ; CX减1，若CX不为0则继续循环

    ; 显示按任意键继续提示
    LEA DX, msg_press                      ; DX指向“Press any key to continue”提示信息的偏移地址
    MOV AH, 9                              ; AH=9，准备显示提示信息
    INT 21H                                ; 调用DOS中断21H，显示按键提示

    ; 等待用户按任意键
    MOV AH, 1                              ; AH=1，表示调用DOS 1号功能（等待键盘输入）
    INT 21H                                ; 调用DOS中断21H，程序暂停，直到用户按下任意键

    MOV AH, 4CH                            ; AH=4CH，表示程序正常结束并返回DOS
    INT 21H                                ; 调用DOS中断21H，结束程序并返回操作系统

CODES ENDS                                 ; 代码段CODES定义结束
END START                                  ; 整个程序结束，告诉汇编器从START标号开始执行
