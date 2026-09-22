`timescale 1ns / 1ps
module coder_tb;
    reg [7:0] I;    // 8位输入信号
    reg EI;         // 使能信号
    wire [2:0] A;   // 3位编码输出
    wire GS;        // 组选择信号
    wire EO;        // 使能输出信号

    parameter clk_period = 5; // 时钟周期

    // 实例化主模块
    coder U1 (
        .I(I),
        .EI(EI),
        .A(A),
        .GS(GS),
        .EO(EO)
    );

    initial begin
        // 测试用例
        EI <= 1; I <= 8'b10000001; #clk_period; // 使能有效，输出全高
        EI <= 1; I <= 8'b11000011; #clk_period; // 使能有效，输出全高
        EI <= 0; I <= 8'b11100111; #clk_period; // 编码输入，优先级最高的I[7]为0
        EI <= 0; I <= 8'b11111111; #clk_period; // 输入全为1，GS为1，EO为0
        EI <= 0; I <= 8'b01111110; #clk_period; // 优先级最高的I[6]为0
        EI <= 0; I <= 8'b00111100; #clk_period; // 优先级最高的I[5]为0
        EI <= 0; I <= 8'b00011000; #clk_period; // 优先级最高的I[4]为0
        EI <= 0; I <= 8'b00000000; #clk_period; // 优先级最高的I[7]为0
        EI <= 0; I <= 8'b11111111; #clk_period; // 输入全为1，GS为1，EO为0
        $stop; // 停止仿真
    end
endmodule