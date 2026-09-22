`timescale 1ns / 1ps
module adder_8bit_en_rst_tb;

    reg        clk, rst, en;
    reg [7:0]  A, B;
    reg        Cin;
    wire [7:0] Sum;
    wire       Cout;

    // 实例化模块
    adder_8bit_en_rst uut (
        .clk(clk), .rst(rst), .en(en),
        .A(A), .B(B), .Cin(Cin),
        .Sum(Sum), .Cout(Cout)
    );

    // 时钟生成
    initial clk = 0;
    always #10 clk = ~clk;   // 20ns周期

    initial begin
        $display("========== 8位带使能复位全加器仿真开始 ==========");

        rst = 1; en = 0; A = 0; B = 0; Cin = 0; 
        #30 rst = 0; en = 1;     // 解除复位，使能打开

        // 测试1：普通加法
        A = 8'h05; B = 8'h0A; Cin = 0; #40;

        // 测试2：带进位加法
        A = 8'hFF; B = 8'h01; Cin = 1; #40;

        // 测试3：使能关闭（保持输出）
        en = 0; A = 8'hAA; B = 8'h55; #40;

        // 测试4：使能重新打开
        en = 1; A = 8'h0F; B = 8'hF0; Cin = 1; #40;

        // 测试5：复位测试
        rst = 1; #30; rst = 0; #40;

        $display("========== 仿真结束 ==========");
        #100;
        $finish;
    end

endmodule