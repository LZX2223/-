module top_add(a, b, cin, dout, cout); // 顶层模块名改为 top_add
   input [15:0]  a; // 16位加数输入
   input [15:0]  b; // 16位被加数输入
   input         cin; // 进位输入
   output [15:0] dout; // 16位加法结果输出
   output        cout; // 进位输出

   // 实例化子模块 add
   add add_inst (
      .a(a),      // 将顶层模块的输入 a 连接到子模块的输入 a
      .b(b),      // 将顶层模块的输入 b 连接到子模块的输入 b
      .cin(cin),  // 将顶层模块的输入 cin 连接到子模块的输入 cin
      .dout(dout), // 将子模块的输出 dout 连接到顶层模块的输出 dout
      .cout(cout) // 将子模块的输出 cout 连接到顶层模块的输出 cout
   );
endmodule