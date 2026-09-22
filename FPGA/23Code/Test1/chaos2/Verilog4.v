`timescale 1ns / 1ps

module add16_head_tb;
    // 输入信号声明
    reg [15:0] A;    // 16位加数A
    reg [15:0] B;    // 16位加数B
    reg CIN;         // 输入进位信号
    // 输出信号声明
    wire [15:0] DOUT1; // 16位和输出
    wire COUT1;        // 输出进位信号

    // 时钟周期参数
    parameter clk_period = 5;

    // 实例化16位加法器模块
    ADD16 U1 (
        .A(A),      // 加数A
        .B(B),      // 加数B
        .CIN(CIN),  // 输入进位
        .DOUT(DOUT1), // 和输出
        .COUT(COUT1)  // 输出进位
    );

    // 测试逻辑
    initial begin
        // 测试用例 1
        A <= 16'b0101010101010010;
        B <= 16'b0100101010000100;
        CIN <= 1'b1;
        #(clk_period); // 等待一个时钟周期

        // 测试用例 2
        A <= 16'b0111011011110010;
        B <= 16'b0111101010000100;
        CIN <= 1'b0;
        #(clk_period); // 等待一个时钟周期

        // 测试用例 3
        A <= 16'b1001011011110010;
        B <= 16'b1001101000000100;
        CIN <= 1'b1;
        #(clk_period); // 等待一个时钟周期

        // 测试用例 4
        A <= 16'b1101011011110010;
        B <= 16'b1011101001110100;
        CIN <= 1'b1;
        #(clk_period); // 等待一个时钟周期

        // 结束仿真
        $stop; // 停止仿真
    end
endmodule