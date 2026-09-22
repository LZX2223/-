   ORG 0000H  ;设置程序起始地址
   AJMP MAIN  ;跳转到MAIN
   ORG 0030H  ;指定后续代码的起始地址为0030H
MAIN:         ;MAIN函数 
   MOV SP,#60H  ;给SP赋值为60H
   MOV A,#0H    ;给A赋值为0H
   MOV R1,#30H  ;给R1赋值为30H
   MOV R7,#10H  ;给R7赋值为10H
LOOP1:          ;循环1
   MOV @R1,A   ;寄存器寻址操作，将表格中内容读到内存
   INC R1        ;R1自加1，指向下一个内存单元
   DJNZ R7,LOOP1  ;R7不为0 则自动跳转到循环LOOP1起始
   NOP           ;空指令，占用一个指令的时间
   MOV R1,#30H   ;将30H放到R1中
   MOV R7,#10H   ;将10H放到R7中
LOOP:            ;循环LOOP
   MOV @R1,A    ;寄存器寻址操作，将表格中内容读到内存
   INC R1         ;R1自加1，指向下一个内存单
   INC A          ;A自加1，指向下一个内存单
   DJNZ R7,LOOP   ;如果R7不为0，则自动跳到循环LOOP起始
   SJMP $         ;原地跳转，等待中断    
END         ;程序结束SJMP $
