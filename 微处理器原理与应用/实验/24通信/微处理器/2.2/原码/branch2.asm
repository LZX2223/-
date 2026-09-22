ASSUME CS:CODE               ; CS指向名为CODE的段
                                    ; 16位实模式程序必须写此句确保段寻址正确
    CODE SEGMENT                  ; 定义代码段开始
                                 
START:                              ; 程序入口标号
                                    ; DOS加载后 CS:IP 指向这里
    MOV AH, 01H                     ; AH=01H：DOS功能，从键盘读字符
    INT 21H                         ; 调用中断21H，输入字符ASCII码存入AL
                                    ; 同时字符会自动显示在屏幕（回显）
    MOV BL, AL                      ; 把AL（输入字符）备份到BL
                                     ; 防止后续CMP破坏AL，用于多次比较
    CMP BL, 0DH                     ; 比较BL是否为回车（0DH = Enter）
    JE s                            ; 是回车 → 跳转结束程序

    CMP BL, 31H                     ; 比较BL是否 < '1'（31H）
    JB START                        ; < '1' → 跳回重新读，不输出

    CMP BL, 39H                     ; 比较BL是否 <= '9'（39H）
    JBE OUTPUT1                     ; 是1~9 → 去显示原输入字符

    CMP BL, 41H                     ; 比较BL是否 < 'A'（41H）
    JB START                        ; < 'A' → 跳回重新读

    CMP BL, 5AH                     ; 比较BL是否 <= 'Z'（5AH）
    JBE OUTPUT2                     ; 是是A~Z则显示 'c'

    CMP BL, 61H                     ; 比较BL是否 < 'a'（61H）
    JB START                        ; < 'a' → 跳回重新读字符

    CMP BL, 7AH                     ; 比较BL是否 <= 'z'（7AH）
    JBE OUTPUT2                     ; 如果是a~z则显示 'c'

    JMP START                       ; 其他字符 → 无输出，继续循环

OUTPUT1:                            ; 处理1~9：显示用户输入的原字符
    MOV DL, BL                      ; 把BL（原字符）放入DL（显示用）
    MOV AH, 02H                     ; AH=02H：显示单个字符（DL中内容）
    INT 21H                         ; 执行显示（如输入'5'则显示'5'）
    JMP START                       ; 返回主循环

OUTPUT2:                            ; 处理A-Z/a-z：显示 'c'
    MOV DL, 'c'                     ; DL = 'c' 的ASCII码
    MOV AH, 02H                     ; AH=02H：显示字符
    INT 21H                         ; 显示 'c'
    JMP START                       ; 返回主循环
s:                                  ; 结束标签
    MOV AH, 4CH                     ; AH=4CH：终止程序，返回DOS
    INT 21H                         ; 执行退出
    CODE ENDS                       ; 代码段结束
    END START                       ; 汇编结束，入口为START
