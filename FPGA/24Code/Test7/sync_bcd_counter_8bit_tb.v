`timescale 1ns / 1ps

module tb_sync_bcd_counter_8bit;

    reg clk;
    reg rst_n;
    reg en;
    wire [7:0] bcd_out;
    wire COUT;

    sync_bcd_counter_8bit uut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .bcd_out(bcd_out),
        .COUT(COUT)
    );

    // 产生时钟，周期20ns
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // 产生复位和使能信号
    initial begin
        rst_n = 1'b0;
        en    = 1'b0;

        #25;
        rst_n = 1'b1;
        en    = 1'b1;

        #2500;

        en = 1'b0;      // 暂停计数
        #100;

        en = 1'b1;      // 继续计数
        #1000;

        $stop;
    end

endmodule