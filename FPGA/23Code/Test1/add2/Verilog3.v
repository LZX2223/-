module testbench;
   reg [15:0]  a;    // 加数输入
   reg [15:0]  b;    // 被加数输入
   reg         cin;  // 进位输入
   wire [15:0] dout; // 加法结果输出
   wire        cout; // 进位输出

   // 实例化顶层模块
   top_add uut (
      .a(a),      // 连接测试平台的 a 到顶层模块的 a
      .b(b),      // 连接测试平台的 b 到顶层模块的 b
      .cin(cin),  // 连接测试平台的 cin 到顶层模块的 cin
      .dout(dout), // 连接顶层模块的 dout 到测试平台的 dout
      .cout(cout) // 连接顶层模块的 cout 到测试平台的 cout
   );

   initial begin
      // 初始化输入信号
      a = 16'h0001;   // 设置 a = 1
      b = 16'h0002;   // 设置 b = 2
      cin = 1'b0;     // 设置 cin = 0

      // 延迟 10 个时间单位，等待计算结果
      #10;

      // 检查输出结果
      if (dout === 16'h0003 && cout === 1'b0) begin
         $display("Test passed! dout = %h, cout = %b", dout, cout);
      end else begin
         $display("Test failed! dout = %h, cout = %b", dout, cout);
      end

      // 测试带进位的加法
      a = 16'hFFFF;   // 设置 a = 65535
      b = 16'h0001;   // 设置 b = 1
      cin = 1'b0;     // 设置 cin = 0

      // 延迟 10 个时间单位，等待计算结果
      #10;

      // 检查输出结果
      if (dout === 16'h0000 && cout === 1'b1) begin
         $display("Test passed! dout = %h, cout = %b", dout, cout);
      end else begin
         $display("Test failed! dout = %h, cout = %b", dout, cout);
      end
   end
endmodule