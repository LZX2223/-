`timescale 1ns / 1ps
module decoder_3to8_tb;

    reg G1, G2A, G2B;
    reg [2:0] A;
    wire [7:0] Y;

    // 实例化被测模块
    decoder_3to8 uut (
        .G1(G1), .G2A(G2A), .G2B(G2B),
        .A(A), .Y(Y)
    );

    initial begin
        $display("========== 3-8线译码器仿真开始 ==========");
        
        // 使能无效测试
        G1 = 0; G2A = 0; G2B = 0; A = 0; #20;
        
        // 使能有效，依次测试每个输出
        G1 = 1; G2A = 0; G2B = 0;
        
        A = 3'b000; #20; $display("A=000, Y=%b", Y);
        A = 3'b001; #20; $display("A=001, Y=%b", Y);
        A = 3'b010; #20; $display("A=010, Y=%b", Y);
        A = 3'b011; #20; $display("A=011, Y=%b", Y);
        A = 3'b100; #20; $display("A=100, Y=%b", Y);
        A = 3'b101; #20; $display("A=101, Y=%b", Y);
        A = 3'b110; #20; $display("A=110, Y=%b", Y);
        A = 3'b111; #20; $display("A=111, Y=%b", Y);
        
        // 使能无效测试
        G1 = 0; #20;
        G2A = 1; #20;
        G2B = 1; #20;
        
        $display("========== 仿真结束 ==========");
        $finish;
    end

endmodule