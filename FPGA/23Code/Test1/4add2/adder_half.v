// ① 半加器模块
module adder_half(input wire a, input wire b, output reg sum, output reg cout);
    always @(*)
    begin
        sum = a ^ b;  // 半加器加和计算：a 和 b 的异或结果
        cout = a & b; // 半加器进位信号计算：a 和 b 的与结果
    end
endmodule

// ② 或门模块
module or_gate(input wire a, input wire b, output reg y);
    always @(*)
        y = a | b;  // 或门逻辑：a 和 b 的或结果
endmodule

// ③ 1位全加器模块
module Adder1(input wire A, input wire B, input wire cin, output wire sum, output wire cout);
    wire temp;  // 临时变量，用于存储第一个半加器的加和结果
    wire c1, c2; // 临时变量，用于存储两个半加器的进位信号

    // 实例化第一个半加器，计算 A 和 B 的加和
    adder_half adder_half_inst1(.a(A), .b(B), .sum(temp), .cout(c1));

    // 实例化第二个半加器，计算 temp（第一个半加器的加和）与 cin（低位进位）的加和
    adder_half adder_half_inst2(.a(temp), .b(cin), .sum(sum), .cout(c2));

    // 实例化或门，计算最终进位信号：c1 或 c2
    or_gate or_gate_inst(.a(c1), .b(c2), .y(cout));
endmodule

// ④ 4位二进制全加器模块
module Fplus_loader(S, C3, A, B, C_1);
    input [3:0] A, B;  // 两个4位加数输入
    input C_1;         // 低位进位输入
    output [3:0] S;    // 4位加和输出
    output C3;         // 最终进位输出
    wire C0, C1, C2;   // 用于存储各加法器之间的进位信号

    // 实例化四个1位全加器，依次计算每一位的加和和进位
    Adder U1(.sum(S[0]), .cout(C0), .A(A[0]), .B(B[0]), .cin(C_1)); // 第0位
    Adder U2(.sum(S[1]), .cout(C1), .A(A[1]), .B(B[1]), .cin(C0));  // 第1位
    Adder U3(.sum(S[2]), .cout(C2), .A(A[2]), .B(B[2]), .cin(C1));  // 第2位
    Adder U4(.sum(S[3]), .cout(C3), .A(A[3]), .B(B[3]), .cin(C2));  // 第3位
endmodule

// ⑤ 16位二进制全加器模块
module Sbit_adder(COUT3, DOUT, A, B, CIN);
    input [15:0] A, B;  // 两个16位加数输入
    input CIN;          // 低位进位输入
    output [15:0] DOUT; // 16位加和输出
    output COUT3;       // 最终进位输出
    wire COUT0, COUT1, COUT2; // 用于存储各4位加法器之间的进位信号

    // 实例化四个4位全加器，依次计算每4位的加和和进位
    Fplus_loader U1(.S(DOUT[3:0]), .C3(COUT0), .A(A[3:0]), .B(B[3:0]), .C_1(CIN));  // 第0-3位
    Fplus_loader U2(.S(DOUT[7:4]), .C3(COUT1), .A(A[7:4]), .B(B[7:4]), .C_1(COUT0)); // 第4-7位
    Fplus_loader U3(.S(DOUT[11:8]), .C3(COUT2), .A(A[11:8]), .B(B[11:8]), .C_1(COUT1)); // 第8-11位
    Fplus_loader U4(.S(DOUT[15:12]), .C3(COUT3), .A(A[15:12]), .B(B[15:12]), .C_1(COUT2)); // 第12-15位
endmodule

`timescale 1ns / 1ps  // 设置仿真时间单位为1纳秒，时间精度为1皮秒

module add16_tb;  // 定义16位加法器测试模块
    // 定义输入信号
    reg [15:0] A;   // 16位加数A
    reg [15:0] B;   // 16位加数B
    reg CIN;        // 进位输入信号

    // 定义输出信号
    wire [15:0] DOUT1;  // 16位加和输出
    wire COUT1;         // 进位输出信号

    parameter clk_period = 5;  // 定义时钟周期为5个时间单位

    // 实例化16位加法器模块
    ADD16 U1(.A(A), .B(B), .CIN(CIN), .DOUT(DOUT1), .COUT(COUT1));

    // 测试逻辑
    always begin: pr1  // 定义一个名为pr1的always块
        // 测试用例1
        A <= 16'b0101010101010010;  // 设置加数A
        B <= 16'b0100101010000100;  // 设置加数B
        CIN <= 1'b1;                // 设置进位输入为1
        #(clk_period);              // 等待一个时钟周期

        // 测试用例2
        A <= 16'b0111011011110010;  // 设置加数A
        B <= 16'b0111101010000100;  // 设置加数B
        CIN <= 1'b0;                // 设置进位输入为0
        #(clk_period);              // 等待一个时钟周期

        // 测试用例3
        A <= 16'b1001011011110010;  // 设置加数A
        B <= 16'b1001101000000100;  // 设置加数B
        CIN <= 1'b1;                // 设置进位输入为1
        #(clk_period);              // 等待一个时钟周期

        // 测试用例4
        A <= 16'b1101011011110010;  // 设置加数A
        B <= 16'b1011101001110100;  // 设置加数B
        CIN <= 1'b1;                // 设置进位输入为1
        #(clk_period);              // 等待一个时钟周期
    end
endmodule