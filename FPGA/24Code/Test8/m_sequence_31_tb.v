`timescale 1ns / 1ps

module tb_m_sequence_31;

    reg clk;
    reg rst_n;
    wire m_out;
    wire [4:0] q;

    m_sequence_31 uut (
        .clk(clk),
        .rst_n(rst_n),
        .m_out(m_out),
        .q(q)
    );

    // 产生时钟，周期20ns
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // 复位信号
    initial begin
        rst_n = 1'b0;
        #25;
        rst_n = 1'b1;

        #700;
        $stop;
    end

endmodule