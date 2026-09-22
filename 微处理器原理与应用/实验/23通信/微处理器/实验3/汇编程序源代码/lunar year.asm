DATAS SEGMENT;数据段开始
INFON DB 13,10,'Please input a year:',13,10,'$';INFON定义字符串，回车换行后输出'PLEASE INPUT A YEAR:'
Y DB 13,10,'This is a leap year!',13,10,'$' ;Y定义字符串，回车换行后输出'THIS IS A LEAP YEAR!'
N DB 13,10,'This is not a leap year!',13,10,'$';N定义字符串，回车换行后输出'THIS IS NOT A LEAP YEAR!'
W DW 0 ;声明空间存储输入年份解析后生成的年份数字
BUF DB 8;定义一个字符串的存储区
DB ? ;实际接受的字符数，初始化为空
DB 8 DUP(0);对这8个双字节做初始化
DATAS ENDS ;数据段结束
  
STACKS SEGMENT STACK;栈段开始
DB 32 DUP(0) ;定义一个32个字的栈段，并初始化为0
STACKS ENDS;栈段结束

CODES SEGMENT;代码段开始
    ASSUME DS:DATAS, SS:STACKS,CS:CODES;伪指令，向编译器指明各段的位置
START: 
    MOV AX,DATAS;将DATAS的地址放到AX中
    MOV DS,AX;将AX中数据放入DS中，此时DS指向DATAS的地址
    MOV AX,STACKS;将STACKS的地址放到AX中
    MOV SS,AX;将AX中数据放入SS中，此时SS存储STACKS的地址
    XOR AX,AX;将AX中的数据初始化为0
    MOV DX,OFFSET INFON;将DX与INFON的偏移地址链接
    MOV AH,9;调用INT21H的9号功能，该功能为显示字符串
    INT 21H;从键盘输出字符显示在屏幕上
    
    comment*
        下面这段代码接受键盘输入的字符串进入缓冲区
    *comment
    MOV DX,OFFSET BUF;将DX与BUF的偏移地址链接
    MOV AH,0AH;调用INT21H的10号功能，该功能为从键盘输入字符串
    INT 21H;从键盘输入字符串，并存储在BUF中
    XOR CX,CX;将CX置0，保证CX的值为0
    MOV CL,[BUF+1];使CL的值为[BUF+1]，获取实际的输入长度
    
    CALL DATACATE;调用子程序DATACATE，将字符串解析为数字

    CALL IFYEARS;调用子程序IFYEARS，判断转化的年份是否为闰年
    
    JC A1;如果进位标志C为1，就跳转到A1
    MOV DX,OFFSET N;将DX与N的偏移地址链接
    MOV AH,9;调用INT21H的9号功能，该功能为显示字符串
    INT 21H;从键盘输出字符显示在屏幕上
    JMP EXIT;跳转到EXIT处

    A1:
    MOV DX,OFFSET Y;将DX与Y的偏移地址链接
    MOV AH,9;调用INT21H的9号功能，该功能为显示字符串
    INT 21H;从键盘输出字符显示在屏幕上

    EXIT: 
    MOV AH,4CH;调用INT21H的4CH号功能，该功能为退出程序
    INT 21H;退出程序

    DATACATE PROC NEAR;表明DATACATE子程序在主程序段内
        PUSH CX;将CX压入栈中备份
        DEC CX;CX中的内容自减1，确保下面的循环使SI指向最后一个字符（BUF中回车符前面的一个字符）
        MOV SI,OFFSET BUF+2;将SI与BUF+2的偏移地址链接,SI即得BUF字符串的首地址
        TT1:
            INC SI;将SI自增
        LOOP TT1;循环TT1段代码直至CX自减至0
        POP CX;将CX弹栈，恢复循环前的值

        MOV DH,30H;将DH的值置为30H，即数字0的ASCII码
        MOV BL,10;十进制的权重
        MOV AX,1;表示10^0，在循环过程中与BL共同体现权重
        L1:
            PUSH AX;将AX压入栈中备份
            PUSH BX;将BX压入栈中备份
            PUSH DX;将DX压入栈中备份
            SUB BYTE PTR [SI],DH;把数字的ASCII码减去30H，转换成其代表的数值，由于DH只有8位，因此强制转换[SI]
            MOV BL,BYTE PTR [SI];将上一步得到的数值存入BL中
            XOR BH,BH;使BH的值清零
            MUL BX;将AX的值乘上BX寄存器内代表的权值，然后把结果储存在AX中，MUL默认一个乘数存在AL(或AX）中，与乘数是8位还是16位有关
            ADD [W],AX;把AX的值加到最后的结果上
            POP DX;弹栈，使栈中的DX恢复
            POP BX;弹栈，使栈中的BX恢复
            POP AX;弹栈，使栈中的AX恢复
            MUL BL;继续使AX的值乘10
            DEC SI;SI中的内容自减，确保下一次循环SI指向前一个字符
        LOOP L1;循环执行L1段代码
        RET;子程序返回
    DATACATE ENDP;子程序DATACATE结束

    IFYEARS PROC NEAR;说明DATACATE子程序在主程序段内
        PUSH BX;将BX压入栈中备份
        PUSH CX;将CX压入栈中备份
        PUSH DX;将DX压入栈中备份
        MOV AX,[W];将结果的值放到AX中
        MOV CX,AX;使CX的值等于AX的值
        XOR DX,DX;使DX的值等于0
        
        comment*
            下面这段代码检测输入的年份能否被100整除
        *comment
        MOV BX,64H;使BX的值等于100
        DIV BX;将AX中的值和BX的值作除法（BX此时的值为100），DIV默认将被除数存在AX(或AX与DX）中，与被除数是8位还是16位有关
        CMP DX,0;将DX的值与0作比较，这是因为对于DIV，余数存在DX中
        JNZ LAB1;若除法结果得出不为0，跳转到LAB1,若为0则不跳转
        MOV AX,CX;将CX的值放入AX中

        comment*
            下面这段代码检测输入的年份能否被400整除
        *comment
        MOV BX,400;使BX的值等于400
        DIV BX;将AX中的值和BX的值作除法（BX此时的值为400）
        CMP DX,0;将DX的值和0作比较
        JZ LAB2;若结果为0，则继续执行LAB2段代码
        CLC;将C标记位清零
        JMP LAB3;跳转到LAB3段代码

        comment*
            下面这段代码检测输入的年份能否被4整除
        *comment
        LAB1: 
            MOV AX,CX;将CX的值放入AX中
            XOR DX,DX;使DX的值等于0
            MOV BX,4;使BX的值等于4
            DIV BX;将AX中的值和BX的值作除法（BX此时的值为4）
            CMP DX,0;将DX的值和0作比较
            JZ LAB2;为0则跳转到LAB2段代码
            CLC;将C标记位清零
            JMP LAB3;跳转到LAB3代码段

        LAB2: 
            STC;若是闰年则跳转到此处将C标志位置1
        LAB3:
            POP DX;弹栈，使栈中的DX恢复
            POP CX;弹栈，使栈中的CX恢复
            POP BX;弹栈，使栈中的BX恢复
        RET;子程序返回
    IFYEARS ENDP;子程序IFYEARS结束

CODES ENDS;代码段结束
END START;程序结束
