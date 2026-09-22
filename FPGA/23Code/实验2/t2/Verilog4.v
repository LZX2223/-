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
        // 初始化所有信号
        EI = 1;
        I = 8'b00000000;

        // 测试用例
        #10 EI = 1; I = 8'b10000001; // 使能有效，输出全高
        #10 EI = 1; I = 8'b11000011; // 使能有效，输出全高
        #10 EI = 0; I = 8'b11100111; // 编码输入，优先级最高的I[7]为0
        #10 EI = 0; I = 8'b11111111; // 输入全为1，GS为1，EO为0
        #10 EI = 0; I = 8'b01111110; // 优先级最高的I[6]为0
        #10 EI = 0; I = 8'b00111100; // 优先级最高的I[5]为0
        #10 EI = 0; I = 8'b00011000; // 优先级最高的I[4]为0
        #10 EI = 0; I = 8'b00000000; // 优先级最高的I[7]为0
        #10 EI = 0; I = 8'b11111111; // 输入全为1，GS为1，EO为0
        #10 $stop; // 停止仿真
    end

    // 生成波形文件
    initial begin
        $dumpfile("coder_wave.vcd"); // 波形文件名称
        $dumpvars(0, coder_tb);     // 记录所有信号
    end
endmodule