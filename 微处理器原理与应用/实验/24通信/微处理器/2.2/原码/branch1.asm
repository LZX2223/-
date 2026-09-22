CODE SEGMENT
    ASSUME CS:CODE                  ; 告诉汇编器：CS 段寄存器指向我们当前定义的名为 CODE 的段
START:                              ; 程序的真正入口点，DOS 加载程序后会跳转到这里开始执行
    MOV  AL, 3EH                    ; 把十六进制数 3EH（二进制 0011 1110）装入 AL，这是我们要显示的目标数值
    MOV  BL, AL                     ; 把 AL 的原始值完整备份到 BL，后续 DL 会被多次修改，但原始值还要用来取低四位
    MOV  DL, AL                     ; 再次把 AL 的值复制到 DL，准备先处理高 4 位
    MOV  CL, 4                      ; 把右移次数 4 放入 CL，供后面的 SHR 指令使用
    SHR  DL, CL                     ; 把 DL 逻辑右移 4 位，高 4 位被移到低 4 位位置（3EH → 03H）
    CMP  DL, 9                      ; 比较 DL 和 9，判断这个 4bit 值是 0~9 还是 A~F（10~15）
    JBE  NEXT1                      ; 如果 DL ≤ 9（无符号比较），直接跳到加 '0' 的步骤
    ADD  DL, 7                      ; 如果大于 9，先加上 7，为转成字母 A~F 做偏移准备（后面还会再加 30H）
NEXT1:
    ADD  DL, 30H                    ; 转换成 ASCII 字符：0~9 变成 '0'~'9'，10~15 变成 'A'~'F'（这里应该是 '3'）
    MOV  AH, 2                      ; 设置 DOS 功能号 02H → 显示单个字符
    INT  21H                        ; 调用 DOS 中断 21H，把 DL 中的字符（'3'）显示到屏幕
    MOV  DL, BL                     ; 把一开始保存的原始数值（3EH）重新放回 DL，准备处理低 4 位
    AND  DL, 0FH                    ; 与 00001111 做与运算，只保留低 4 位，高 4 位清零（得到 0EH）
    CMP  DL, 9                      ; 再次比较 DL 和 9，判断低 4 位是数字还是字母
    JBE  NEXT2                      ; 如果 ≤ 9，直接跳到加 30H 转字符
    ADD  DL, 7                      ; 大于 9，先加 7，为转成 A~F 预留偏移量
NEXT2:
    ADD  DL, 30H                    ; 转换成对应的 ASCII 字符（0EH + 7 + 30H = 45H → 'E'）
    MOV  AH, 2                      ; 再次设置功能号 02H，准备显示下一个字符
    INT  21H                        ; 调用中断，把低 4 位对应的字符（'E'）显示出来，此时屏幕应显示 “3E”
    MOV  AH, 4CH                    ; 设置 AH = 4CH，表示“终止程序并返回 DOS”
    INT  21H                        ; 调用 DOS 中断 21H，程序正常结束，控制权交回 DOS
CODE ENDS
    END START                       ; 告诉汇编器：程序的入口地址是 START 标号
