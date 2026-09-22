module add(a, b, cin, dout, cout); // 子模块名保持为 add
   input [15:0]  a; // 16位加数输入
   input [15:0]  b; // 16位被加数输入
   input         cin; // 进位输入
   output [15:0] dout; // 16位加法结果输出
   output        cout; // 进位输出

   wire [16:0]   dout17; // 17位中间结果，用于存储加法和进位
   wire [16:0]   a17;    // 17位扩展的加数
   wire [16:0]   b17;    // 17位扩展的被加数

   // 将 16 位输入扩展为 17 位，高位补 0
   assign a17 = {1'b0, a}; // a17 = {0, a[15:0]}
   assign b17 = {1'b0, b}; // b17 = {0, b[15:0]}

   // 执行 17 位加法，包括进位输入
   assign dout17 = a17 + b17 + cin;

   // 输出低 16 位作为加法结果
   assign dout = dout17[15:0];

   // 输出最高位作为进位
   assign cout = dout17[16];
endmodule