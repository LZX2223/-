DATAS SEGMENT
  MSG1 DB 13,10,'Enter the first decimal number:',13,10,'$' ; 提示用户输入第一个十进制数
  MSG2 DB 13,10,'Enter the second decimal number:',13,10,'$' ; 提示用户输入第二个十进制数
  MSG3 DB 13,10,'The sum is:',13,10,'$' ; 提示输出结果

  BUFFER1 DB 200 ; 定义第一个缓冲区，最大长度为200
          DB ? ; 用于存储实际输入的字符数
          DB 200 DUP (?) ; 初始化缓冲区
  BUFFER2 DB 200 ; 定义第二个缓冲区，最大长度为200
          DB ? ; 用于存储实际输入的字符数
          DB 200 DUP (?) ; 初始化缓冲区
  BUFFER3 DB 201 ; 定义第三个缓冲区，最大长度为201（用于存储结果）
          DB ? ; 用于存储实际结果的字符数
          DB 201 DUP (?) ; 初始化缓冲区
DATAS ENDS

STACKS SEGMENT STACK
  DW 128 DUP(0) ; 定义128个字的栈空间
STACKS ENDS

CODES SEGMENT
  ASSUME DS:DATAS, SS:STACKS, CS:CODES ; 告诉编译器各段寄存器的用途
MAIN:
  MOV AX, DATAS ; 将数据段地址加载到AX
  MOV DS, AX ; 将AX的值赋给DS寄存器
  MOV AX, STACKS ; 将栈段地址加载到AX
  MOV SS, AX ; 将AX的值赋给SS寄存器

  MOV DX, OFFSET MSG1 ; 将MSG1的偏移地址加载到DX
  MOV AH, 9 ; 设置AH为9，表示调用显示字符串的功能
  INT 21H ; 调用中断21H，显示MSG1的内容

  MOV DX, OFFSET BUFFER1 ; 将BUFFER1的偏移地址加载到DX
  MOV AH, 10 ; 设置AH为10，表示调用输入字符串的功能
  INT 21H ; 调用中断21H，将用户输入存储到BUFFER1

  MOV DX, OFFSET MSG2 ; 将MSG2的偏移地址加载到DX
  MOV AH, 9 ; 设置AH为9，表示调用显示字符串的功能
  INT 21H ; 调用中断21H，显示MSG2的内容

  MOV DX, OFFSET BUFFER2 ; 将BUFFER2的偏移地址加载到DX
  MOV AH, 10 ; 设置AH为10，表示调用输入字符串的功能
  INT 21H ; 调用中断21H，将用户输入存储到BUFFER2

  MOV CL, [BUFFER1+1] ; 将BUFFER1中实际输入的字符数加载到CL
  MOV CH, 0 ; 将CH置0，确保CX为BUFFER1的长度
  MOV SI, OFFSET BUFFER1+2 ; 将BUFFER1中第一个字符的地址加载到SI
  MOV DI, OFFSET BUFFER2+2 ; 将BUFFER2中第一个字符的地址加载到DI

  MOV DX, OFFSET MSG3 ; 将MSG3的偏移地址加载到DX
  MOV AH, 9 ; 设置AH为9，表示调用显示字符串的功能
  INT 21H ; 调用中断21H，显示MSG3的内容

  CALL PROCESS_DATA ; 调用子程序PROCESS_DATA，处理输入数据并计算和
  CALL DISPLAY_RESULT ; 调用子程序DISPLAY_RESULT，显示计算结果

  MOV AH, 4CH ; 设置AH为4CH，表示程序结束
  INT 21H ; 调用中断21H，返回DOS环境

PROCESS_DATA PROC NEAR ; 子程序PROCESS_DATA，用于处理输入数据并计算和
  PUSH CX ; 保存CX的值
  DEC CX ; CX减1，确保SI指向最后一个字符
ADJUST_SI:
  INC SI ; SI加1，指向下一个字符
  LOOP ADJUST_SI ; 循环直到SI指向最后一个字符
  POP CX ; 恢复CX的值

  PUSH CX ; 保存CX的值
  DEC CX ; CX减1，确保DI指向最后一个字符
ADJUST_DI:
  INC DI ; DI加1，指向下一个字符
  LOOP ADJUST_DI ; 循环直到DI指向最后一个字符
  POP CX ; 恢复CX的值

  MOV BX, OFFSET BUFFER3+2 ; 将BUFFER3中第一个字符的地址加载到BX
L1:
  SUB BYTE PTR [SI], 30H ; 将SI指向的字符从ASCII码转换为数值
  SUB BYTE PTR [DI], 30H ; 将DI指向的字符从ASCII码转换为数值
  MOV AL, BYTE PTR [SI] ; 将SI指向的数值加载到AL
  MOV AH, BYTE PTR [DI] ; 将DI指向的数值加载到AH
  ADD AL, AH ; 将AL和AH相加，结果存储在AL
  CMP AL, 10 ; 比较AL和10，判断是否需要进位
  JB NO_CARRY ; 如果AL小于10，跳转到NO_CARRY
  SUB AL, 10 ; 如果AL大于等于10，减去10
  CMP CX, 1 ; 比较CX和1，判断是否处理到最高位
  JE HANDLE_CARRY ; 如果CX等于1，跳转到HANDLE_CARRY
  PUSH DI ; 保存DI的值
  DEC DI ; DI减1，指向前一个字符
  ADD BYTE PTR [DI], 1 ; 将前一个字符加1（进位）
  POP DI ; 恢复DI的值
NO_CARRY:
  ADD AL, 30H ; 将AL中的数值转换为ASCII码
  MOV BYTE PTR [BX], AL ; 将AL的值存储到BUFFER3
  INC BX ; BX加1，指向BUFFER3的下一个位置
  PUSH BX ; 保存BX的值
  MOV BX, OFFSET BUFFER3+1 ; 将BUFFER3中字符数的地址加载到BX
  ADD BYTE PTR [BX], 1 ; 字符数加1
  POP BX ; 恢复BX的值
  DEC SI ; SI减1，指向前一个字符
  DEC DI ; DI减1，指向前一个字符
  JMP NEXT ; 跳转到NEXT
HANDLE_CARRY:
  STC ; 设置进位标志为1
NEXT:
  LOOP L1 ; 循环处理下一个字符
  JC HANDLE_OVERFLOW ; 如果有进位，跳转到HANDLE_OVERFLOW
  JMP DONE ; 否则跳转到DONE
HANDLE_OVERFLOW:
  ADD AL, 30H ; 将AL中的数值转换为ASCII码
  MOV BYTE PTR [BX], AL ; 将AL的值存储到BUFFER3
  INC BX ; BX加1，指向BUFFER3的下一个位置
  ADD BYTE PTR [BX], 31H ; 在BUFFER3中存储进位值（'1'）
  PUSH BX ; 保存BX的值
  MOV BX, OFFSET BUFFER3+1 ; 将BUFFER3中字符数的地址加载到BX
  ADD BYTE PTR [BX], 2 ; 字符数加2（一位结果和一位进位）
  POP BX ; 恢复BX的值
DONE:
  RET ; 返回主程序
PROCESS_DATA ENDP

DISPLAY_RESULT PROC NEAR ; 子程序DISPLAY_RESULT，用于显示计算结果
  MOV CL, [BUFFER3+1] ; 将BUFFER3中字符数加载到CL
  XOR CH, CH ; 将CH置0，确保CX为字符数
  DEC CX ; CX减1，确保BX指向最后一个字符
  PUSH CX ; 保存CX的值
  MOV BX, OFFSET BUFFER3+2 ; 将BUFFER3中第一个字符的地址加载到BX
LOOP3:
  INC BX ; BX加1，指向下一个字符
  LOOP LOOP3 ; 循环直到BX指向最后一个字符
  POP CX ; 恢复CX的值

  INC CX ; CX加1，确保循环次数正确
L2:
  XOR DX, DX ; 将DX置0
  MOV DL, BYTE PTR [BX] ; 将BX指向的字符加载到DL
  MOV AH, 2 ; 设置AH为2，表示调用显示字符的功能
  INT 21H ; 调用中断21H，显示DL中的字符
  DEC BX ; BX减1，指向前一个字符
  LOOP L2 ; 循环显示下一个字符
  RET ; 返回主程序
DISPLAY_RESULT ENDP
CODES ENDS
END MAIN ; 程序结束
