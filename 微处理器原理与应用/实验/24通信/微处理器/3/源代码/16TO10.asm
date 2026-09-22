DATA_SEG SEGMENT ; 数据段开始
    MSG_INPUT DB 13,10,'Enter a hexadecimal number (up to 4 digits):',13,10,'$' ; 定义输入提示字符串
    MSG_ERROR DB 13,10,'Invalid input! Please try again.',13,10,'$' ; 定义错误提示字符串
DATA_SEG ENDS ; 数据段结束
STACK_SEG SEGMENT STACK ; 栈段开始
    DW 64 DUP (0) ; 定义64个字的栈空间
STACK_SEG ENDS ; 栈段结束
CODE_SEG SEGMENT ; 代码段开始
    ASSUME CS:CODE_SEG,DS:DATA_SEG,SS:STACK_SEG ; 指定段寄存器关联
MAIN: ; 主程序入口标签
    MOV AX, DATA_SEG ; 将数据段地址加载到AX寄存器
    MOV DS, AX ; 将数据段地址存入DS寄存器
    LEA DX, MSG_INPUT ; 将输入提示字符串的偏移地址加载到DX
    MOV AH, 09H ; 设置AH为09H，准备显示字符串
    INT 21H ; 调用DOS中断21H显示输入提示
    XOR DX, DX ; 清零DX寄存器，用于累积十六进制数值
READ_INPUT: ; 读取输入循环标签
    MOV AH, 01H ; 设置AH为01H，准备从键盘读取单个字符
    INT 21H ; 调用DOS中断21H读取键盘输入到AL
    MOV BL, AL ; 将输入字符从AL移动到BL
    XOR BH, BH ; 清零BH寄存器，保证BX高字节为0（非常关键！）
    CMP BL, 0DH ; 比较BL是否为回车键（0DH）
    JE DISPLAY_RESULT ; 如果是回车，跳转到显示结果部分
    CMP BL, '0' ; 比较BL是否小于字符'0'
    JB INVALID_INPUT ; 如果小于'0'，跳转到无效输入处理
    CMP BL, '9' ; 比较BL是否小于等于字符'9'
    JBE CONVERT_DIGIT ; 如果是0-9数字，跳转到数字转换
    AND BL, 0DFH ; 将字母a-f转换为大写A-F
    CMP BL, 'A' ; 比较BL是否小于字符'A'
    JB INVALID_INPUT ; 如果小于'A'，跳转到无效输入
    CMP BL, 'F' ; 比较BL是否大于字符'F'
    JA INVALID_INPUT ; 如果大于'F'，跳转到无效输入
    SUB BL, 'A'-10 ; 将A-F字母转换为数值10-15
    JMP ADD_TO_DX ; 跳转到累加到结果部分
CONVERT_DIGIT: ; 数字转换标签
    SUB BL, '0' ; 将ASCII数字字符'0'-'9'转换为实际数值0-9
ADD_TO_DX: ; 累加数值标签
    MOV CL, 4 ; 设置左移位数为4
    SHL DX, CL ; 将DX左移4位（相当于当前值乘以16）
    ADD DX, BX ; 将新转换的数字加到DX中
    JMP READ_INPUT ; 跳转回继续读取下一个输入字符
INVALID_INPUT: ; 无效输入处理标签
    LEA DX, MSG_ERROR ; 将错误提示字符串的偏移地址加载到DX
    MOV AH, 09H ; 设置AH为09H，准备显示字符串
    INT 21H ; 调用DOS中断21H显示错误提示
    JMP READ_INPUT ; 跳转回继续等待输入（符合“try again”）
DISPLAY_RESULT: ; 显示十进制结果标签
    MOV AX, DX ; AX = 要显示的十进制数值
    MOV BX, 10 ; 设置除数为10
    XOR CX, CX ; CX 计数压栈的位数
    OR AX, AX ; 特殊处理0：检查AX是否为0
    JNZ CONVERT_LOOP ; 如果不为0，跳转到转换循环
    MOV DL, '0' ; 如果结果为0，直接准备显示字符'0'
    MOV AH, 02H ; 设置AH为02H，准备显示单个字符
    INT 21H ; 调用DOS中断21H显示字符'0'
    JMP EXIT ; 直接跳转到程序结束
CONVERT_LOOP: ; 十进制转换循环标签
    XOR DX, DX ; 清零DX，准备进行除法
    DIV BX ; AX ÷ 10，商在AX，余数在DX
    PUSH DX ; 余数压栈（从低位到高位）
    INC CX ; 计数压栈的位数加1
    OR AX, AX ; 检查商是否为0
    JNZ CONVERT_LOOP ; 如果商不为0，继续循环除法
PRINT_LOOP: ; 显示循环标签
    POP DX ; 从栈中弹出余数（高位先出）
    ADD DL, '0' ; 将数字转为ASCII字符
    MOV AH, 02H ; 设置AH为02H，准备显示单个字符
    INT 21H ; 调用DOS中断21H显示一位数字
    LOOP PRINT_LOOP ; 循环显示所有压栈的位
EXIT: ; 程序结束标签
    MOV AH, 4CH ; 设置AH为4CH，准备退出程序
    INT 21H ; 调用DOS中断21H退出程序
CODE_SEG ENDS ; 代码段结束
END MAIN ; 程序结束，以MAIN为入口
