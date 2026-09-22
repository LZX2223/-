;本动画先显示一些提示信息，然后按任意键进入，只见一个方框向中
;间由大变小，并留下痕迹，然后出现一个心，按空格重复出现心，按其他
;键将重复,按Q键退出程序。

Data segment
full db 0
buff1 db ' Welcome you to run this programme!'
db ' '
db ' *****Please press any key*****$'
buff2 db ' My heart beats with yours!'
db ' ***** Please q to quit *****$'
Data ends
code segment
assume cs: code , ds: Data
start:
push ds
sub ax,ax
push ax
mov ax, Data
mov ds, ax
mov ah, 0
mov al, 4
int 10h
mov ah,0bh
mov bh, 0
mov bl, 1
int 10h
mov ah,0bh
mov bh, 1
mov bl, 2
int 10h
mov dx,offset buff1 ;显示提示信息
mov ah, 9
int 21h
mov ah, 8
int 21h
call clear ;cls
sss:
call text ;display the text
mov di, 2
mov al,1 ;draw the big box
mov cx, 70
mov dx, 20
mov bx, 160
Call box
mov cx, 71
mov dx, 21
mov bx, 158
again:
mov al, 1
mov di, 0
Call box
Call delay
mov al, 0
mov di, 0
Call box
inc cx
inc dx
sub bx,2
cmp cx, 94
jnz again
mov di,0 ;draw the 2nd box
mov cx, 95
mov dx, 45
mov al, 1
mov bx, 110
Call box
mov cx, 96
mov dx, 46
mov bx, 108
again_00:
mov al, 1
mov di, 0
Call box
Call delay
Call delay
mov al, 0
mov di, 0
Call box
inc cx
inc dx
sub bx,2
cmp cx, 114
jnz again_00
mov cx,115 ;draw the 3rd box
mov dx, 65
mov al, 1
mov bx, 70
Call box
mov cx, 116
mov dx, 66
mov bx, 68
again_01:
mov al, 1
mov di, 0
Call box
Call delay
Call delay
mov al, 0
mov di, 0
Call box
inc cx
inc dx
sub bx,2
cmp cx, 129
jnz again_01
mov di, 2
mov al,1 ;draw the small box
mov cx, 130
mov dx, 80
mov bx, 40
Call box
mov di, 2
mov al,3 ;对角线
mov si, 0
mov cx, 71
mov dx, 21
mov bx, 59
Call xie_line
mov cx, 171
mov dx, 121
mov bx, 59
Call xie_line
mov si, 1
mov cx, 71
mov dx, 179
mov bx, 59
Call xie_line
mov cx, 171
mov dx, 79
mov bx, 59
Call xie_line
mov cx,150 ;十字线
mov dx, 20
mov si, 0
mov bx, 60
Call draw_line
mov cx, 150
mov dx, 120
mov bx, 60
Call draw_line
mov cx, 70
mov dx, 100
mov si, 1
mov bx, 60
Call draw_line
mov cx, 170
mov dx, 100
mov bx, 60
Call draw_line
mov si, 1
mov cx, 70
mov dx, 60
mov bx, 60
Call mid_line
mov cx, 170
mov dx, 110
mov bx, 60
Call mid_line
mov si, 2
mov cx, 110
mov dx, 20
mov bx, 30
Call mid_line
mov cx, 160
mov dx, 120
mov bx, 30
Call mid_line
mov si, 3
mov cx, 70
mov dx, 140
mov bx, 60
Call mid_line
mov cx, 170
mov dx, 90
mov bx, 60
Call mid_line
mov si, 4
mov cx, 110
mov dx, 180
mov bx, 30
Call mid_line
mov cx, 160
mov dx, 80
mov bx, 30
Call mid_line
mov di, 0
mov al,1 ;draw the big box again
mov cx, 70
mov dx, 20
mov bx, 160
Call box
mov di, 0
mov al,1 ;draw the small box again
mov cx, 130
mov dx, 80
mov bx, 40
Call box
mov di, 0
mov cx, 95
mov dx, 45
mov al, 1
mov bx, 110
Call box
mov cx, 115
mov dx, 65
mov al, 1
mov bx, 70
Call box
mov di,1 ;fill
Call fill
Call fill_2
Call fill_3
mov cx,149 ;bold
mov dx, 120
mov al, 2
mov bx, 60
mov si, 0
Call draw_line
mov cx, 151
mov dx, 120
mov al, 2
mov bx, 60
mov si, 0
Call draw_line
heart_: ;draw the heart
Call cls_box
Call heart
mov ah, 8
int 21h
cmp al,'q'
jz ok
cmp al,20h
jz heart_
Call Clear
jmp sss
ok:
ret
fill proc near ;the procedure of fill
mov full, 0
mov al, 5
mov cx, 160
mov dx, 121
mov si, 0
mov bx, 60
fill_Y:
push cx
push dx
push bx
Call draw_line
pop bx
pop dx
pop cx
sub bx,2
inc cx
Add dx, 2
inc full
cmp full, 30
jne fill_Y
ret
fill endp
fill_2 proc near
mov full, 0
mov al, 5
mov cx, 140
mov dx, 121
mov si, 0
mov bx, 60
fill_Y1:
push cx
push dx
push bx
Call draw_line
pop bx
pop dx
pop cx
sub bx,2
dec cx
Add dx, 2
inc full
cmp full, 30
jne fill_Y1
ret
fill_2 endp
fill_3 proc near
mov al, 1
mov full, 0
mov si, 0
mov cx, 140
mov dx, 121
mov bx, 60
re_fill:
push bx
push cx
push dx
Call draw_line
pop dx
pop cx
pop bx
inc cx
inc full
cmp full, 9
jne re_fill
mov full, 0
mov cx, 159
mov dx, 121
mov bx, 60
re_fill2:
push bx
push cx
push dx
Call draw_line
pop dx
pop cx
pop bx
dec cx
inc full
cmp full, 9
jne re_fill2
ret
fill_3 endp
draw_Line proc near ;the procedure of draw a line
push bx
cmp si, 0
jz V_line1
Add bx, cx
H_line:
mov ah,0ch
int 10h
cmp di, 0
jz aa0
cmp di, 1
jz aa1
Call delay
aa1:
Call delay
aa0:
inc cx
cmp cx, bx
jne H_line
jmp exit_line
V_line1:
Add bx, dx
V_line:
mov ah,0ch
cmp di, 0
jz bb0
cmp di, 1
jz bb1
Call delay
bb1:
Call delay
bb0:
int 10h
inc dx
cmp dx, bx
jne V_line
exit_line:
pop bx
ret
draw_line endp
xie_line proc near ;the procedure of draw a xie_line
Add bx, cx
cmp si, 1
jz xieline_1
xieline_0:
mov ah,0ch
int 10h
inc dx
inc cx
cmp cx, bx
jne xieline_0
jmp exit_xie
xieline_1:
mov ah,0ch
int 10h
dec dx
inc cx
cmp cx, bx
jne xieline_1
exit_xie:
ret
xie_line endp
Mid_line proc near ;draw a xie_line
Add bx, cx
cmp si, 2
jz midline_2
cmp si, 3
jz midline_3
cmp si, 4
jz midline_4
midline_1:
mov ah,0ch
int 10h
inc dx
Add cx, 2
cmp cx, bx
jne midline_1
jmp exit_lines
midline_2:
mov ah,0ch
int 10h
Add dx, 2
inc cx
cmp cx, bx
jne midline_2
jmp exit_lines
midline_3:
mov ah,0ch
int 10h
dec dx
Add cx, 2
cmp cx, bx
jne midline_3
jmp exit_lines
midline_4:
mov ah,0ch
int 10h
sub dx,2
inc cx
cmp cx, bx
jne midline_4
exit_lines:
ret
mid_line endp
box proc near ;draw a box
push cx
push dx
push cx
push dx
push cx
push dx
push cx
push dx
mov si, 1
call draw_line ;top
pop dx
pop cx
Add cx, bx
mov si, 0
call draw_line ;right
pop dx
pop cx
mov si, 0
call draw_line ;left
pop dx
pop cx
mov si, 1
Add dx, bx
call draw_line ;bottom
pop dx
pop cx
ret
box endp
space proc near ;display a space
mov ah, 2
mov dl,' '
int 21h
ret
Space endp
return proc near ;回车
mov ah, 2
mov dl,0ah
int 21h
mov dl,0dh
int 21h
ret
return endp
text proc near ;显示文本信息
mov bh, 0
mov dh, 0
mov dl, 0
mov ah, 2
int 10h
mov dx,offset buff2
mov ah, 9
int 21h
Text endp
heart proc near
mov cx,136 ;draw_heart
mov dx, 93
mov si, 0
mov bx, 5
mov al, 2
Call draw_line
mov cx,137 ;draw_heart
mov dx, 91
mov si, 0
mov bx, 9
Call draw_line
mov cx,138 ;draw_heart
mov dx, 90
mov si, 0
mov bx, 12
Call draw_line
mov cx,139 ;draw_heart
mov dx, 89
mov si, 0
mov bx, 14
Call draw_line
mov cx,140 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 16
Call draw_line
mov cx,141 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 17
Call draw_line
mov cx,142 ;draw_heart
mov dx, 87
mov si, 0
mov bx, 19
Call draw_line
mov cx,143 ;draw_heart
mov dx, 87
mov si, 0
mov bx, 20
Call draw_line
mov cx,144 ;draw_heart
mov dx, 87
mov si, 0
mov bx, 21
Call draw_line
mov cx,145 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 21
Call draw_line
mov cx,146 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 22
Call draw_line
mov cx,147 ;draw_heart
mov dx, 89
mov si, 0
mov bx, 22
Call draw_line
mov cx,148 ;draw_heart
mov dx, 90
mov si, 0
mov bx, 22
Call draw_line
mov cx,149 ;draw_heart
mov dx, 91
mov si, 0
mov bx, 22
Call draw_line
mov cx,150 ;1draw_heart
mov dx, 91
mov si, 0
mov bx, 22
Call draw_line
mov cx,151 ;draw_heart
mov dx, 90
mov si, 0
mov bx, 22
Call draw_line
mov cx,152 ;draw_heart
mov dx, 89
mov si, 0
mov bx, 22
Call draw_line
mov cx,153 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 22
Call draw_line
mov cx,154 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 21
Call draw_line
mov cx,155 ;draw_heart
mov dx, 87
mov si, 0
mov bx, 21
Call draw_line
mov cx,156 ;draw_heart
mov dx, 87
mov si, 0
mov bx, 20
Call draw_line
mov cx,157 ;draw_heart
mov dx, 87
mov si, 0
mov bx, 19
Call draw_line
mov cx,158 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 17
Call draw_line
mov cx,159 ;draw_heart
mov dx, 88
mov si, 0
mov bx, 16
Call draw_line
mov cx,160 ;draw_heart
mov dx, 89
mov si, 0
mov bx, 14
Call draw_line
mov cx,161 ;draw_heart
mov dx, 90
mov si, 0
mov bx, 12
Call draw_line
mov cx,162 ;draw_heart
mov dx, 91
mov si, 0
mov bx, 9
Call draw_line
mov cx,163 ;draw_heart
mov dx, 93
mov si, 0
mov bx, 5
Call draw_line
ret
heart endp
delay proc near ;the procedure of delay
push cx
push dx
mov dx, 25
dl2:
mov cx, 2801
dl3:
loop dl3
dec dx
jnz dl2
pop dx
pop cx
ret
delay endp
clear proc near ;clear
mov al, 0
mov bx, 0
mov cx, 0
mov dx, 0
line:
mov ah,0ch
int 10h
inc cx
cmp cx, 320
jne line
mov cx, 0
inc dx
cmp dx, 200
jne line
ret
Clear endp
cls_box proc near
mov al, 0
mov bx, 0
mov cx, 131
mov dx, 81
s_line:
mov ah,0ch
int 10h
inc cx
cmp cx, 170
jne s_line
mov cx, 131
inc dx
cmp dx, 120
jne s_line
ret
cls_box endp
code ends
end start
