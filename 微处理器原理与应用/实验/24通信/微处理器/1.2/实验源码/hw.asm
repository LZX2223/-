STACKS SEGMENT          ;定义栈段
     DW 256 DUP(?)      ;DW即define word（定义字），注意这里分配的空间为256个字，一个字为两个字节
                        ;DUP全称Duplicate（重复、复制），（?）代表保留空间但未初始化的值，整句意思为
                        ;批量分配256个未初始化的值的字的空间
     TOP EQU $-STACKS
STACKS ENDS             ;栈段结束

DATAS SEGMENT           ;定义数据段
     STRING DB 13,10,'Hello World!',13,10,'$'
DATAS ENDS

CODES SEGMENT           ;定义代码段
     ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
     MOV AX,DATAS
     MOV DS,AX
    
     MOV AX,STACKS
     MOV SS,AX
     MOV SP,TOP
     LEA DX,STRING
     MOV AH,9
     INT 21H
  
     MOV AH,4CH
     INT 21H
CODES ENDS
END START