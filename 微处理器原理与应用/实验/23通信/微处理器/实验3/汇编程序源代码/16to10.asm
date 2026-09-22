DATA_SEG SEGMENT ; 数据段开始
  MSG_INPUT DB 13,10,'Enter a hexadecimal number (up to 4 digits):',13,10,'$' ; 提示输入信息
  MSG_ERROR DB 13,10,'Invalid input! Please try again.',13,10,'$' ; 错误提示信息
DATA_SEG ENDS ; 数据段结束

STACK_SEG SEGMENT STACK ; 栈段开始
  DW 64 DUP (0) ; 定义64个字的栈空间
STACK_SEG ENDS ; 栈段结束

CODE_SEG SEGMENT ; 代码段开始
    ASSUME CS:CODE_SEG,DS:DATA_SEG,SS:STACK_SEG ; 指定段寄存器
  MAIN: ; 主程序入口
    MOV AX, DATA_SEG ; 将数据段地址加载到AX
    MOV DS, AX ; 将AX中的地址存入DS
    LEA DX, MSG_INPUT ; 将MSG_INPUT的地址加载到DX
    MOV AH, 09H ; 设置AH为09H，用于显示字符串
    INT 21H ; 调用DOS中断显示提示信息
    XOR DX, DX ; 清空DX，用于存储输入的数字

  READ_INPUT: ; 读取输入
    MOV AH, 01H ; 设置AH为01H，用于读取键盘输入
    INT 21H ; 调用DOS中断读取输入
    MOV BL, AL ; 将输入的字符存入BL
    XOR BH, BH ; 清空BH
    CMP BL, 0DH ; 检查是否为回车
    JE DISPLAY_RESULT ; 如果是回车，跳转到显示结果
    CMP BL, '0' ; 检查是否小于'0'
    JB INVALID_INPUT ; 如果小于'0'，跳转到错误处理
    CMP BL, '9' ; 检查是否小于等于'9'
    JBE CONVERT_DIGIT ; 如果是数字，跳转到数字转换
    AND BL, 0DFH ; 将字符转换为大写
    CMP BL, 'A' ; 检查是否小于'A'
    JB INVALID_INPUT ; 如果小于'A'，跳转到错误处理
    CMP BL, 'F' ; 检查是否小于等于'F'
    JBE CONVERT_LETTER ; 如果是字母，跳转到字母转换
    JMP INVALID_INPUT ; 否则跳转到错误处理

  INVALID_INPUT: ; 错误处理
    LEA DX, MSG_ERROR ; 将MSG_ERROR的地址加载到DX
    MOV AH, 09H ; 设置AH为09H，用于显示字符串
    INT 21H ; 调用DOS中断显示错误信息
    JMP EXIT ; 跳转到程序结束

  CONVERT_DIGIT: ; 数字转换
    SUB BL, '0' ; 将ASCII码转换为数值
    MOV CL, 4 ; 设置左移位数
    SHL DX, CL ; 将DX左移4位
    ADD DX, BX ; 将转换后的数值加到DX
    JMP READ_INPUT ; 继续读取输入

  CONVERT_LETTER: ; 字母转换
    SUB BL, 'A' - 10 ; 将字母转换为数值
    MOV CL, 4 ; 设置左移位数
    SHL DX, CL ; 将DX左移4位
    ADD DX, BX ; 将转换后的数值加到DX
    JMP READ_INPUT ; 继续读取输入

  DISPLAY_RESULT: ; 显示结果
    MOV CX, DX ; 将DX的值存入CX
    CMP CX, 10000 ; 检查是否小于10000
    JB DISPLAY_THOUSANDS ; 如果小于10000，跳转到千位显示
    MOV AX, CX ; 将CX的值存入AX
    XOR DX, DX ; 清空DX
    MOV BX, 10000 ; 设置除数为10000
    DIV BX ; 进行除法
    MOV CX, DX ; 将余数存入CX
    MOV DL, AL ; 将商存入DL
    ADD DL, '0' ; 将数值转换为ASCII码
    MOV AH, 02H ; 设置AH为02H，用于显示字符
    INT 21H ; 调用DOS中断显示字符

  DISPLAY_THOUSANDS: ; 显示千位
    CMP CX, 1000 ; 检查是否小于1000
    JB DISPLAY_HUNDREDS ; 如果小于1000，跳转到百位显示
    MOV AX, CX ; 将CX的值存入AX
    XOR DX, DX ; 清空DX
    MOV BX, 1000 ; 设置除数为1000
    DIV BX ; 进行除法
    MOV CX, DX ; 将余数存入CX
    MOV DL, AL ; 将商存入DL
    ADD DL, '0' ; 将数值转换为ASCII码
    MOV AH, 02H ; 设置AH为02H
    INT 21H ; 调用DOS中断显示字符

  DISPLAY_HUNDREDS: ; 显示百位
    CMP CX, 100 ; 检查是否小于100
    JB DISPLAY_TENS ; 如果小于100，跳转到十位显示
    MOV AX, CX ; 将CX的值存入AX
    XOR DX, DX ; 清空DX
    MOV BX, 100 ; 设置除数为100
    DIV BX ; 进行除法
    MOV CX, DX ; 将余数存入CX
    MOV DL, AL ; 将商存入DL
    ADD DL, '0' ; 将数值转换为ASCII码
    MOV AH, 02H ; 设置AH为02H
    INT 21H ; 调用DOS中断显示字符

  DISPLAY_TENS: ; 显示十位
    CMP CX, 10 ; 检查是否小于10
    JB DISPLAY_UNITS ; 如果小于10，跳转到个位显示
    MOV AX, CX ; 将CX的值存入AX
    XOR DX, DX ; 清空DX
    MOV BX, 10 ; 设置除数为10
    DIV BX ; 进行除法
    MOV CX, DX ; 将余数存入CX
    MOV DL, AL ; 将商存入DL
    ADD DL, '0' ; 将数值转换为ASCII码
    MOV AH, 02H ; 设置AH为02H
    INT 21H ; 调用DOS中断显示字符

  DISPLAY_UNITS: ; 显示个位
    ADD CL, '0' ; 将CL的值转换为ASCII码
    MOV DL, CL ; 将CL的值存入DL
    MOV AH, 02H ; 设置AH为02H
    INT 21H ; 调用DOS中断显示字符

  EXIT: ; 程序结束
    MOV AH, 4CH ; 设置AH为4CH，用于程序退出
    INT 21H ; 调用DOS中断退出程序
CODE_SEG ENDS ; 代码段结束
END MAIN ; 程序结束
