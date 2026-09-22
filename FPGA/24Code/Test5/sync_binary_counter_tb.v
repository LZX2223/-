`timescale 1ns / 1ps

module tb_sync_binary_counter;

    reg clk;
    reg rst_n;
    wire [7:0] count_out;
    wire COUT;

    sync_binary_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .count_out(count_out),
        .COUT(COUT)
    );

    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst_n = 1'b0;
        #25;
        rst_n = 1'b1;

        #5000;
        $stop;
    end

endmodule