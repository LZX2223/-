`timescale 1ns / 1ps
module decoder_74LS138_tb;
    reg G1, G2A, G2B; // 控制信号
    reg C, B, A;      // 3 位二进制输入
    wire [7:0] Y;     // 8 位低电平有效输出

    // 实例化主模块
    decoder_74LS138 U1 (
        .G1(G1),
        .G2A(G2A),
        .G2B(G2B),
        .C(C),
        .B(B),
        .A(A),
        .Y(Y)
    );

    initial begin
        // 测试用例
        // 译码器被禁止的情况
        G1 = 0; G2A = 0; G2B = 0; C = 0; B = 0; A = 0; #10;
        G1 = 0; G2A = 1; G2B = 0; C = 1; B = 1; A = 1; #10;
        G1 = 1; G2A = 1; G2B = 0; C = 0; B = 0; A = 0; #10;

        // 译码器处于工作状态
        G1 = 1; G2A = 0; G2B = 0; C = 0; B = 0; A = 0; #10; // Y0 = 0
        G1 = 1; G2A = 0; G2B = 0; C = 0; B = 0; A = 1; #10; // Y1 = 0
        G1 = 1; G2A = 0; G2B = 0; C = 0; B = 1; A = 0; #10; // Y2 = 0
        G1 = 1; G2A = 0; G2B = 0; C = 1; B = 0; A = 0; #10; // Y3 = 0
        G1 = 1; G2A = 0; G2B = 0; C = 1; B = 0; A = 1; #10; // Y4 = 0
        G1 = 1; G2A = 0; G2B = 0; C = 1; B = 1; A = 0; #10; // Y5 = 0
        G1 = 1; G2A = 0; G2B = 0; C = 1; B = 1; A = 1; #10; // Y6 = 0

        // 结束仿真
        $stop;
    end
endmodule