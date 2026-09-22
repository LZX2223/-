;开始定义栈段
STACKS  SEGMENT STACK;这一行是栈段开始标签，格式形似于c#中定义类的时候会写为“class Program”，其中SEGMENT STACK定位和class一样都是关键字，而STACKS和Program一样都作为标识名称。若删去会提示no stack segment。
 DW  256 DUP(?);DW意为“Define Word”，即定义字，而一个字在汇编语言里由两个字节组成。256指的是定义了256个字，DUP用于批量分配对应字段的数值，而（？）类似NaN，是一个未指定且未初始化的数值。整句意思即为：批量分配256个未定义初始值的字的空间。
STACKS  ENDS;结束栈段的标签。 

DATAS  SEGMENT;这一行开始定义数据段，意为到datas end为止的部分都是数据段。
STRINGS  DB  13,10,'Hello World!',13,10,'$' ;定义字符串，在ASCII码中，13、10、$分别表示换行、回车和字符串结束的标签，Hello World!则是字符串的内容。这一串字符串的开始位置被STRING标签指向。
DATAS  ENDS;结束数据段的标签。

CODES  SEGMENT;定义代码段，意为到codes end为止的部分都是代码段。
START: ;程序开始执行的位置。
ASSUME CS:CODES,DS:DATAS ;ASSUME是段寻址伪指令，说明了将哪个被定义的段设定为程序意义上的对应段落，其中CS:CODES表示将CODES段落设定为代码段，由CS（代码段寄存器）指向；DS：DATAS表示将DATAS段落设定为数据段，由DS（数据段寄存器）指向；此处可以加SS:STACKS，但由于程序并未对栈段落进行操作，因此仅需声明一下栈段落确保完整性即可，不需要设定。
MOV AX,DATAS;将DATAS数据段的地址赋值给寄存器AX。
MOV DS,AX;将寄存器AX赋值给段寄存器DS，AX起转接作用。
LEA DX,STRINGS ;LEA用于将内存地址赋值给寄存器，DX是任意一个寄存器，而STRING指向了之前定义过的'Hello World!'，因而执行后寄存器DX内的值是'Hello World!'这一字符串开始位置的内存物理地址。
MOV AH,9 ;将9赋值给AX的高地址内存单元AH，9在中断21H的服务号执行输出字符串的功能。
INT 21H ;INT 21H为固定搭配，用于根据上一步命令中AH的内容执行对应的功能。
MOV AH,4CH ;将4C赋值给AX的高地址内存单元AH，4C在中断21H的服务号执行结束程序和返回操作系统的功能。
INT 21H ;INT 21H为固定搭配，用于根据上一步命令中AH的内容执行对应的功能。
CODES ENDS ;结束代码段的标签。
END START;程序整体结束的标签。

