DATAS SEGMENT
    MSG1 DB 13,10,'Enter the first number: $'      ; 定义第一个数的输入提示字符串，回车换行后显示提示信息
    MSG2 DB 13,10,'Enter the second number: $'     ; 定义第二个数的输入提示字符串，回车换行后显示提示信息
    MSG3 DB 13,10,'The sum is: $'                          ; 定义结果输出提示字符串，回车换行后显示"The sum is: "

    BUFFER1 DB 200                 ; 定义第一个数输入缓冲区，最大可输入199个字符
            DB ?                   ; 用于存放实际输入的字符个数，由系统自动填充
            DB 200 DUP(?)          ; 预留200个字节用于存放用户输入的第一个数字字符串

    BUFFER2 DB 200                 ; 定义第二个数输入缓冲区，最大可输入199个字符
            DB ?                   ; 用于存放实际输入的字符个数，由系统自动填充
            DB 200 DUP(?)          ; 预留200个字节用于存放用户输入的第二个数字字符串

    BUFFER3 DB 201                 ; 定义结果缓冲区，比输入多1位，用于存放可能的最高位进位（如999+1=1000）
            DB ?                   ; 用于存放最终结果的实际字符个数
            DB 201 DUP(?)          ; 预留201个字节用于存放计算后的结果字符串
DATAS ENDS

STACKS SEGMENT STACK
    DW 128 DUP(0)                  ; 定义栈段，分配128个字（256字节）的栈空间，并全部初始化为0
STACKS ENDS

CODES SEGMENT
    ASSUME DS:DATAS, SS:STACKS, CS:CODES   ; 告诉汇编器：DS指向数据段，SS指向栈段，CS指向代码段

MAIN:
    MOV AX, DATAS                  ; 将数据段DATAS的段地址装入AX寄存器
    MOV DS, AX                     ; 把AX中的段地址传送给DS，使DS指向数据段
    MOV AX, STACKS                 ; 将栈段STACKS的段地址装入AX寄存器
    MOV SS, AX                     ; 把AX中的段地址传送给SS，使SS指向栈段

    ; 输入第一个大数 
    MOV DX, OFFSET MSG1            ; 将第一个输入提示字符串的偏移地址装入DX寄存器
    MOV AH, 9                      ; 设置AH=9，调用DOS 9号功能（显示以$结尾的字符串）
    INT 21H                        ; 执行中断，屏幕上显示“Enter the first number: ”

    MOV DX, OFFSET BUFFER1         ; 将BUFFER1缓冲区的偏移地址装入DX
    MOV AH, 10                     ; 设置AH=10，调用DOS 10号功能（带缓冲的键盘字符串输入）
    INT 21H                        ; 从键盘接收用户输入的第一个数字字符串并存入BUFFER1

    ; 输入第二个大数
    MOV DX, OFFSET MSG2            ; 将第二个输入提示字符串的偏移地址装入DX寄存器
    MOV AH, 9                      ; 设置AH=9，准备显示字符串
    INT 21H                        ; 执行中断，屏幕上显示“Enter the second number: ”

    MOV DX, OFFSET BUFFER2         ; 将BUFFER2缓冲区的偏移地址装入DX
    MOV AH, 10                     ; 设置AH=10，准备接收键盘输入
    INT 21H                        ; 从键盘接收用户输入的第二个数字字符串并存入BUFFER2

    ; 显示结果提示
    MOV DX, OFFSET MSG3            ; 将结果提示字符串的偏移地址装入DX
    MOV AH, 9                      ; 设置AH=9，准备显示字符串
    INT 21H                        ; 执行中断，屏幕上显示“The sum is: ”

    CALL PROCESS_DATA              ; 调用大数加法处理子程序，完成两个大数的相加
    CALL DISPLAY_RESULT            ; 调用结果显示子程序，将计算结果输出到屏幕

    MOV AH, 4CH                    ; 设置AH=4CH，调用DOS终止程序功能
    INT 21H                        ; 执行中断，退出程序并返回到DOS

; 子程序：大数加法处理（从低位到高位逐位相加，正确处理进位和不同长度）
PROCESS_DATA PROC NEAR
    PUSH AX                        ; 将AX寄存器压栈，保护现场
    PUSH BX                        ; 将BX寄存器压栈，保护现场
    PUSH CX                        ; 将CX寄存器压栈，保护现场
    PUSH DX                        ; 将DX寄存器压栈，保护现场
    PUSH SI                        ; 将SI寄存器压栈，保护现场
    PUSH DI                        ; 将DI寄存器压栈，保护现场

    ; 确定循环次数：取两个数中较长的长度
    MOV CL, [BUFFER1+1]            ; CL = 第一个数的实际输入长度
    MOV CH, [BUFFER2+1]            ; CH = 第二个数的实际输入长度
    CMP CL, CH                     ; 比较两个数的长度
    JAE SETLEN                     ; 如果CL >= CH，则跳转到SETLEN
    MOV CL, CH                     ; 否则把较长的长度放入CL

SETLEN:
    MOV BYTE PTR [BUFFER3+1], CL   ; 把当前最大长度暂存到结果缓冲区的长度字段

    ; 计算第一个数最后一位的地址（低位）
    MOV SI, OFFSET BUFFER1 + 2     ; SI指向BUFFER1中第一个字符的位置
    MOV DL, CL                     ; 用DL暂存长度（避免直接用CL加SI）
    XOR DH, DH                     ; DH清零，使DX成为完整的字
    ADD SI, DX                     ; SI = BUFFER1起始地址 + 长度
    DEC SI                         ; SI指向最后一个有效字符（低位）

    ; 计算第二个数最后一位的地址（低位）
    MOV DI, OFFSET BUFFER2 + 2     ; DI指向BUFFER2中第一个字符的位置
    ADD DI, DX                     ; DI = BUFFER2起始地址 + 长度
    DEC DI                         ; DI指向最后一个有效字符（低位）

    ; 计算结果缓冲区最后一位的地址（低位开始存放）
    MOV BX, OFFSET BUFFER3 + 2     ; BX指向BUFFER3中第一个字符的位置
    ADD BX, DX                     ; BX = BUFFER3起始地址 + 长度
    DEC BX                         ; BX指向结果缓冲区的最后一位

    MOV DH, 0                      ; DH作为进位标志，初始为0

ADDLOOP:
    MOV AL, 0                      ; AL清零，默认第一个数当前位为0
    CMP CL, [BUFFER1+1]            ; 判断是否超过第一个数的实际长度
    JA SKIP1                       ; 如果超过，则跳过取数（保持AL=0）
    MOV AL, [SI]                   ; 取出第一个数当前位的ASCII码
    SUB AL, 30H                    ; 把ASCII码转换为实际数字（0-9）

SKIP1:
    MOV AH, 0                      ; AH清零，默认第二个数当前位为0
    CMP CL, [BUFFER2+1]            ; 判断是否超过第二个数的实际长度
    JA SKIP2                       ; 如果超过，则跳过取数（保持AH=0）
    MOV AH, [DI]                   ; 取出第二个数当前位的ASCII码
    SUB AH, 30H                    ; 把ASCII码转换为实际数字（0-9）

SKIP2:
    ADD AL, AH                     ; 把两个当前位的数字相加，结果在AL中
    ADD AL, DH                     ; 加上上一位产生的进位
    MOV DH, 0                      ; 先把进位标志清零

    CMP AL, 10                     ; 判断当前位相加结果是否大于等于10
    JB NOCARRY                     ; 如果小于10，则不需要进位
    SUB AL, 10                     ; 大于等于10时，减去10
    MOV DH, 1                      ; 设置进位标志为1

NOCARRY:
    ADD AL, 30H                    ; 把计算后的数字转回ASCII码
    MOV [BX], AL                   ; 把结果存入结果缓冲区当前位

    DEC SI                         ; SI指向第一个数的前一位
    DEC DI                         ; DI指向第二个数的前一位
    DEC BX                         ; BX指向结果缓冲区的前一位
    DEC CL                         ; 循环计数器减1
    JNZ ADDLOOP                    ; 如果还没有处理完所有位，则继续循环

    ; 处理最高位可能产生的进位
    CMP DH, 0                      ; 检查是否有最终进位
    JE NOFINAL                     ; 如果没有进位，则跳转
    MOV BYTE PTR [BX], '1'         ; 有进位时，在最高位补上字符'1'
    INC BYTE PTR [BUFFER3+1]       ; 结果的总长度加1

NOFINAL:
    POP DI                         ; 恢复DI寄存器
    POP SI                         ; 恢复SI寄存器
    POP DX                         ; 恢复DX寄存器
    POP CX                         ; 恢复CX寄存器
    POP BX                         ; 恢复BX寄存器
    POP AX                         ; 恢复AX寄存器
    RET                            ; 子程序返回
PROCESS_DATA ENDP

; 子程序：显示最终计算结果（从高位到低位正常显示）
DISPLAY_RESULT PROC NEAR
    PUSH AX                        ; 保护AX寄存器
    PUSH BX                        ; 保护BX寄存器
    PUSH CX                        ; 保护CX寄存器
    PUSH DX                        ; 保护DX寄存器

    MOV CL, [BUFFER3+1]            ; CL = 结果字符串的实际长度
    MOV CH, 0                      ; CH清零，使CX成为完整的字计数器
    MOV BX, OFFSET BUFFER3 + 2     ; BX指向结果缓冲区的第一个字符（最高位）

DISPLOOP:
    MOV DL, [BX]                   ; 把当前一位字符取出到DL
    MOV AH, 2                      ; 设置AH=2，调用DOS显示单个字符功能
    INT 21H                        ; 执行中断，在屏幕上显示一位数字
    INC BX                         ; BX指向结果的下一位
    LOOP DISPLOOP                  ; 按照长度循环显示所有位

    POP DX                         ; 恢复DX寄存器
    POP CX                         ; 恢复CX寄存器
    POP BX                         ; 恢复BX寄存器
    POP AX                         ; 恢复AX寄存器
    RET                            ; 子程序返回
DISPLAY_RESULT ENDP

CODES ENDS
END MAIN                           ; 整个程序结束，指定程序入口为MAIN标号

