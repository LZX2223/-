`timescale 1ns/1ps

module tb_traffic_light;

    reg clk;
    reg rst_n;
    wire [2:0] main_light;
    wire [2:0] side_light;

    traffic_light uut (
        .clk(clk),
        .rst_n(rst_n),
        .main_light(main_light),
        .side_light(side_light)
    );

    // 10ns 时钟周期
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #20;
        rst_n = 1;

        #300;
        $stop;
    end

endmodule