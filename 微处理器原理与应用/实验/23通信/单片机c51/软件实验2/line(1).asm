ORG 0000H       ; 程序起始地址设为0000H
AJMP MAIN       ; 跳转到MAIN主程序
ORG 0090H       ; 主程序从0090H开始

MAIN: 
    MOV SP,#62H  ; 设置堆栈指针为62H
    MOV R0,#30H  ; R0指向内部RAM 30H地址(数据存储区)
    MOV DPTR,#TABLE ; DPTR指向TABLE数据表
    MOV R1,#00H  ; R1清零(用作偏移量)
    MOV R2,#20H  ; R2=32(循环计数器，20H=32)

READ: 
    MOV A,R1     ; 将偏移量R1送入累加器A
    MOVC A,@A+DPTR ; 从程序存储器(CODE区)读取数据到A
    MOV @R0,A    ; 将A中的数据存入R0指向的RAM地址
    INC R0       ; R0指针加1(指向下一个RAM地址)
    INC DPTR     ; DPTR加1(指向TABLE下一个数据)
    DJNZ R2,READ ; R2减1，不为零则跳回READ循环

    MOV R7,#1FH  ; R7=31(1FH=31，外循环计数器)
L1: 
    MOV R1,#30H  ; R1重新指向RAM 30H(数据起始地址)
    MOV A,R7     ; 将外循环计数值送入A
    MOV R6,A     ; R6=A(内循环计数器初始化)

L2: 
    MOV A,@R1    ; 读取R1指向的RAM数据到A
    MOV R5,A     ; 临时保存当前数据到R5
    INC R1       ; R1指针加1(指向下一个数据)
    SUBB A, @R1  ; A减去R1指向的数据(比较相邻两数)
    JC L3        ; 如果有借位(C=1，即前数<后数)跳转到L3
    
    ; 交换相邻两数(冒泡排序)
    MOV A,R5     ; 恢复前一个数到A
    XCH A,@R1    ; 交换A与R1指向的数据
    DEC R1       ; R1指针减1(指向前一个数据)
    MOV @R1,A    ; 将较大的数存入前一个位置
    INC R1       ; R1指针加1(恢复指向后一个数据)

L3: 
    DJNZ R6,L2   ; 内循环计数器R6减1，不为零跳回L2
    DJNZ R7,L1   ; 外循环计数器R7减1，不为零跳回L1

SJMP $          ; 无限循环(程序结束)

; 数据表定义(从程序存储器30H开始)
ORG 30H   
TABLE: 
    DB 1,3,9,2,17,4,11,6      ; 第1组8个数据
    DB 5,20,100,64,21,14,79,35 ; 第2组8个数据
    DB 92,7,91,23,65,16,13,18  ; 第3组8个数据
    DB 18,73,65,101,27,19,62,69 ; 第4组8个数据(共32个)
END             ; 程序结束