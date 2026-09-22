STACKS  SEGMENT      ;定义栈段
     DW  256 DUP(?)  ;注意这里分配的空间为256个字
    TOP EQU $-STACKS
STACKS  ENDS

DATAS  SEGMENT    ;定义数据段
     STRING  DB  13,10,'Hello World!',13,10,'$'
DATAS  ENDS

CODES  SEGMENT   ;定义代码段
     ASSUME    CS:CODES,DS:DATAS,SS:STACKS

START:
     MOV  AX,DATAS
     MOV  DS,AX
     
    MOV AX,STACKS
     MOV SS,AX
     MOV SP,TOP

     LEA  DX,STRING

     MOV  AH,9
     INT  21H
   
     MOV  AH,4CH
     INT  21H

CODES  ENDS
    END   START