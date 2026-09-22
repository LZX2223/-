DATAS SEGMENT                  ; 数据段开始
    INFON DB 13,10,'Please input a year:',13,10,'$'     ; 定义提示输入年份的字符串，回车换行后显示“Please input a year:”
    Y     DB 13,10,'This is a leap year!',13,10,'$'     ; 定义“是闰年”提示字符串，回车换行后显示“This is a leap year!”
    N     DB 13,10,'This is not a leap year!',13,10,'$' ; 定义“不是闰年”提示字符串，回车换行后显示“This is not a leap year!”
    W     DW 0                  ; 定义一个字变量W，用于存储输入年份转换后的数字，初始值为0
    BUF   DB 8                  ; 定义输入缓冲区最大可接受的字符长度为8
          DB ?                  ; 实际输入的字符个数，由系统自动填充
          DB 8 DUP(0)           ; 预留8个字节用于存放输入的字符串内容，全部初始化为0
DATAS ENDS                     ; 数据段结束

STACKS SEGMENT STACK           ; 栈段开始
    DB 32 DUP(0)               ; 定义栈空间，大小为32个字节，全部初始化为0
STACKS ENDS                    ; 栈段结束

CODES SEGMENT                  ; 代码段开始
    ASSUME DS:DATAS, SS:STACKS, CS:CODES   ; 告诉汇编器各段寄存器指向的段

START:                         ; 程序入口标号
    MOV AX, DATAS              ; 将数据段DATAS的段地址装入AX寄存器
    MOV DS, AX                 ; 把AX中的数据段地址传送给DS寄存器，使DS指向数据段
    MOV AX, STACKS             ; 将栈段STACKS的段地址装入AX寄存器
    MOV SS, AX                 ; 把AX中的栈段地址传送给SS寄存器，使SS指向栈段
    XOR AX, AX                 ; 将AX寄存器清零（异或自身）

    ; 显示输入提示信息
    MOV DX, OFFSET INFON       ; 将提示字符串INFON的偏移地址装入DX寄存器
    MOV AH, 9                  ; 设置AH=9，调用DOS 9号功能（显示以$结尾的字符串）
    INT 21H                    ; 执行中断，显示“Please input a year:”

    ; 从键盘接收用户输入的年份字符串
    MOV DX, OFFSET BUF         ; 将输入缓冲区BUF的偏移地址装入DX寄存器
    MOV AH, 0AH                ; 设置AH=0AH，调用DOS 10号功能（带缓冲的键盘输入）
    INT 21H                    ; 执行中断，从键盘读取字符串并存入BUF缓冲区

    ; 调用子程序将输入的字符串转换为数字
    CALL DATACATE              ; 调用DATACATE子程序，把输入的ASCII字符串转为二进制数字存入W

    ; 调用子程序判断是否为闰年
    CALL IFYEARS               ; 调用IFYEARS子程序，判断年份是否为闰年，结果通过进位标志CF返回

    JC A1                      ; 如果进位标志CF=1（是闰年），则跳转到A1标号
    MOV DX, OFFSET N           ; 不是闰年，将“不是闰年”字符串的偏移地址装入DX
    MOV AH, 9                  ; 设置AH=9，准备显示字符串
    INT 21H                    ; 显示“This is not a leap year!”
    JMP EXIT                   ; 跳转到程序退出处

A1:                            ; 是闰年的处理标号
    MOV DX, OFFSET Y           ; 将“是闰年”字符串的偏移地址装入DX
    MOV AH, 9                  ; 设置AH=9，准备显示字符串
    INT 21H                    ; 显示“This is a leap year!”

EXIT:                          ; 程序退出标号
    MOV AH, 4CH                ; 设置AH=4CH，调用DOS 4CH号功能（终止程序）
    INT 21H                    ; 执行中断，退出程序并返回DOS

; 子程序：字符串转换为数字 
DATACATE PROC NEAR             ; 定义近过程子程序DATACATE（字符串转数字）
    PUSH CX                    ; 将CX寄存器压入栈中备份（保护现场）
    PUSH SI                    ; 将SI寄存器压入栈中备份
    PUSH BX                    ; 将BX寄存器压入栈中备份
    PUSH DX                    ; 将DX寄存器压入栈中备份

    XOR AX, AX                 ; 将AX清零，作为累加结果使用
    MOV [W], AX                ; 把W变量也清零，准备存放最终年份数字

    MOV CL, [BUF+1]            ; 将实际输入的字符个数取出，放入CL中（用于循环控制）
    MOV SI, OFFSET BUF+2       ; SI指向输入字符串的第一个有效字符（BUF+2位置）

CONVERT_LOOP:                  ; 字符串转数字循环标号
    MOV BL, [SI]               ; 从SI指向的内存单元取出一个字符（ASCII码）
    SUB BL, 30H                ; 把ASCII码减去'0'的ASCII值（30H），转换为对应的十进制数字0-9
    MOV BH, 0                  ; 将BH清零，使BX成为完整的16位数字

    MOV DX, 10                 ; 把10放入DX，准备做乘10运算
    MUL DX                     ; AX = AX * 10（把之前的结果左移一位，相当于乘10）
    ADD AX, BX                 ; 把当前数字加到AX中，实现 result = result*10 + digit

    INC SI                     ; SI加1，指向下一个字符
    DEC CL                     ; 输入长度计数器CL减1
    JNZ CONVERT_LOOP           ; 如果CL不为0，继续循环处理下一个字符

    MOV [W], AX                ; 转换完成，把最终结果存入变量W中

    POP DX                     ; 从栈中弹出DX，恢复现场
    POP BX                     ; 从栈中弹出BX，恢复现场
    POP SI                     ; 从栈中弹出SI，恢复现场
    POP CX                     ; 从栈中弹出CX，恢复现场
    RET                        ; 子程序返回
DATACATE ENDP                  ; DATACATE子程序结束

; 子程序：判断是否为闰年
IFYEARS PROC NEAR              ; 定义近过程子程序IFYEARS（判断闰年）
    PUSH BX                    ; 将BX寄存器压入栈中备份
    PUSH CX                    ; 将CX寄存器压入栈中备份
    PUSH DX                    ; 将DX寄存器压入栈中备份

    MOV AX, [W]                ; 把转换后的年份数字从W中取出，放入AX寄存器
    MOV CX, AX                 ; 将年份备份到CX寄存器中，供后续多次使用

    ; 第一步：判断年份能否被400整除
    XOR DX, DX                 ; 把DX清零，防止除法时出现溢出错误
    MOV BX, 400                ; 把400放入BX，作为除数
    DIV BX                     ; AX除以BX，商在AX，余数在DX
    CMP DX, 0                  ; 判断余数是否为0
    JZ IS_LEAP                 ; 如果余数为0（能被400整除），则一定是闰年，跳转到IS_LEAP

    ; 第二步：判断年份能否被100整除
    MOV AX, CX                 ; 恢复年份到AX寄存器
    XOR DX, DX                 ; 再次清零DX
    MOV BX, 100                ; 把100放入BX，作为除数
    DIV BX                     ; AX除以100
    CMP DX, 0                  ; 判断余数是否为0
    JZ NOT_LEAP                ; 如果能被100整除但不能被400整除，则不是闰年

    ; 第三步：判断年份能否被4整除
    MOV AX, CX                 ; 再次恢复年份到AX
    XOR DX, DX                 ; 清零DX
    MOV BX, 4                  ; 把4放入BX，作为除数
    DIV BX                     ; AX除以4
    CMP DX, 0                  ; 判断余数是否为0
    JZ IS_LEAP                 ; 如果能被4整除，则是闰年
NOT_LEAP:                      ; 不是闰年的处理
    CLC                        ; 清进位标志CF=0，表示不是闰年
    JMP END_IF                 ; 跳转到子程序结束部分

IS_LEAP:                       ; 是闰年的处理
    STC                        ; 置进位标志CF=1，表示是闰年

END_IF:                        ; 判断结束标号
    POP DX                     ; 恢复DX寄存器
    POP CX                     ; 恢复CX寄存器
    POP BX                     ; 恢复BX寄存器
    RET                        ; 子程序返回
IFYEARS ENDP                   ; IFYEARS子程序结束
CODES ENDS                     ; 代码段结束
END START                      ; 整个程序结束，指定入口为START


