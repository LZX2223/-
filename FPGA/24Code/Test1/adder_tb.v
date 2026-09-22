`timescale 1ns / 1ps

module adder_tb;
    reg [15:0] A;
    reg [15:0] B;
    reg C_in;
    wire [15:0] Sum;
    wire C_out;

    // 实例化顶层模块
    adder_16bit uut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .Sum(Sum),
        .C_out(C_out)
    );

    initial begin
        $display("========== 16位层次化全加器仿真开始 ==========");
        
        // 测试用例1：简单加法
        A = 16'h1234; B = 16'h5678; C_in = 0; #40;
        $display("Test1: %h + %h + %b = %h , cout=%b", A, B, C_in, Sum, C_out);
        
        // 测试用例2：带进位溢出
        A = 16'hFFFF; B = 16'h0001; C_in = 1; #40;
        $display("Test2: %h + %h + %b = %h , cout=%b", A, B, C_in, Sum, C_out);
        
        // 测试用例3：全1加法（最大值测试）
        A = 16'hFFFF; B = 16'hFFFF; C_in = 1; #40;
        $display("Test3: %h + %h + %b = %h , cout=%b", A, B, C_in, Sum, C_out);
        
        // 测试用例4：小数加法验证
        A = 16'h0005; B = 16'h000A; C_in = 1; #40;
        $display("Test4: %h + %h + %b = %h , cout=%b", A, B, C_in, Sum, C_out);
        
        $display("========== 仿真结束 ==========");
        #100;
        $finish;
    end
endmodule
