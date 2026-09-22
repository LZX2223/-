DATAS SEGMENT                  ; 数据段开始
    MSG_INPUT DB 'scores:',13,10,'$'          ; 提示输入10个学生的成绩
    MSG_60    DB 13,10,'60~69: ','$'         ; 提示60~69分的人数
    MSG_70    DB 13,10,'70~79: ','$'         ; 提示70~79分的人数
    MSG_80    DB 13,10,'80~89: ','$'         ; 提示80~89分的人数
    MSG_90    DB 13,10,'90~99: ','$'         ; 提示90~99分的人数
    MSG_100   DB 13,10,'100: ','$'           ; 提示100分的人数

    ; 存放各分数段人数（用字节变量，初始为0）
    COUNT_60  DB 0                            ; 60~69分人数
    COUNT_70  DB 0                            ; 70~79分人数
    COUNT_80  DB 0                            ; 80~89分人数
    COUNT_90  DB 0                            ; 90~99分人数
    COUNT_100 DB 0                            ; 100分人数

DATAS ENDS

STACKS SEGMENT STACK           ; 栈段
    DB 16 DUP (?)                 ; 分配16字节栈空间
STACKS ENDS

CODES SEGMENT                  ; 代码段开始
    ASSUME CS:CODES, DS:DATAS, SS:STACKS   ; 段寄存器假设

MAIN:                          ; 主程序入口
    MOV AX, DATAS              ; 获取数据段地址
    MOV DS, AX                 ; 设置DS指向数据段

    MOV AX, STACKS             ; 获取栈段地址
    MOV SS, AX                 ; 设置SS指向栈段

    ; 显示输入提示
    MOV AH, 09H                ; DOS 09H功能：显示以$结尾的字符串
    LEA DX, MSG_INPUT          ; 加载输入提示地址
    INT 21H                    ; 显示 "scores:"

    MOV CX, 10                 ; 循环10次，输入10个成绩

INPUT_LOOP:                    ; 输入循环
    MOV AH, 01H                ; 01H功能：键盘读入一个字符（带回显）
    INT 21H                    ; 读取十位数字到AL
    CALL CLASSIFY              ; 调用分类子程序判断分数段

    MOV AH, 01H                ; 再次读取个位数字（为了让用户正常输入）
    INT 21H

    MOV AH, 02H                ; 02H功能：显示单个字符
    MOV DL, ' '                ; 显示一个空格分隔成绩
    INT 21H

    LOOP INPUT_LOOP            ; 继续输入直到10个完成

    ; 显示统计结果
    LEA DX, MSG_60             ; 显示60~69提示
    MOV AH, 09H
    INT 21H
    CALL DispDigit             ; 调用显示数字子程序
    MOV DL, COUNT_60           ; 取出60~69人数
    CALL DispDigit             ; 显示人数

    LEA DX, MSG_70             ; 显示70~79提示
    MOV AH, 09H
    INT 21H
    MOV DL, COUNT_70
    CALL DispDigit

    LEA DX, MSG_80             ; 显示80~89提示
    MOV AH, 09H
    INT 21H
    MOV DL, COUNT_80
    CALL DispDigit

    LEA DX, MSG_90             ; 显示90~99提示
    MOV AH, 09H
    INT 21H
    MOV DL, COUNT_90
    CALL DispDigit

    LEA DX, MSG_100            ; 显示100提示
    MOV AH, 09H
    INT 21H
    MOV DL, COUNT_100
    CALL DispDigit

    ; 程序退出
    MOV AH, 4CH                ; 4CH功能：退出程序
    INT 21H

; 子程序
CLASSIFY PROC NEAR             ; 分类子程序（根据十位数字判断）
    CMP AL, '6'                ; 是否为'6'（60~69分）
    JE SCORE_60

    CMP AL, '7'                ; 是否为'7'（70~79分）
    JE SCORE_70

    CMP AL, '8'                ; 是否为'8'（80~89分）
    JE SCORE_80

    CMP AL, '9'                ; 是否为'9'（90~99分）
    JE SCORE_90

    CMP AL, '1'                ; 是否为'1'（100分）
    JE SCORE_100

    RET                        ; 都不是则直接返回

SCORE_60:
    INC COUNT_60               ; 60~69人数加1
    JMP DONE

SCORE_70:
    INC COUNT_70               ; 70~79人数加1
    JMP DONE

SCORE_80:
    INC COUNT_80               ; 80~89人数加1
    JMP DONE

SCORE_90:
    INC COUNT_90               ; 90~99人数加1
    JMP DONE

SCORE_100:
    INC COUNT_100              ; 100分人数加1
    MOV AH, 01H                ; 100分是三位数，多读一个'0'
    INT 21H
    JMP DONE

DONE:
    RET
CLASSIFY ENDP

; 新增子程序：显示一位数字（0~9）
DispDigit PROC NEAR
    ADD DL, '0'                ; 把数值0~9转换为ASCII字符 '0'~'9'
    MOV AH, 02H                ; 02H功能：显示单个字符
    INT 21H                    ; 显示数字
    RET
DispDigit ENDP

CODES ENDS                     ; 代码段结束
    END MAIN                   ; 程序入口

