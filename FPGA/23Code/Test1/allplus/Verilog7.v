`timescale 1ns / 1ps

module BCD_add16_tb;
    reg [15:0] A;        // 测试用的输入16位BCD数A
    reg [15:0] B;        // 测试用的输入16位BCD数B
    reg CIN;             // 测试用的进位输入
    wire [15:0] DOUT1;   // 测试用的输出16位BCD结果数
    wire COUT1;          // 测试用的进位输出
    parameter clk_period = 5; // 时钟周期参数

    // 实例化16位BCD全加器
    BCD_Adder16 U1 (
        .a(A),
        .b(B),
        .cin(CIN),
        .c(DOUT1),
        .cout(COUT1)
    );

    initial begin
        // 测试用例1
        A = 16'b0101010101010010;
        B = 16'b0100101010000100;
        CIN = 1'b1;
        #(clk_period);

        // 测试用例2
        A = 16'b0111011011110010;
        B = 16'b0111101010000100;
        CIN = 1'b0;
        #(clk_period);

        // 测试用例3
        A = 16'b1001011011110010;
        B = 16'b1001101000000100;
        CIN = 1'b1;
        #(clk_period);

        // 测试用例4
        A = 16'b1101011011110010;
        B = 16'b1011101001110100;
        CIN = 1'b1;
        #(clk_period);

        $stop; // 停止仿真
    end
endmodule