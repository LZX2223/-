`timescale 1ns/1ps

module TRAFFIC_TESTBENCH;
    // 信号声明
    reg CLK_SIG;
    reg RST_SIG;  
    wire [1:0] MAIN;
    wire [1:0] ALTER;
    
    parameter CLK_PERIOD = 1;  // 时钟周期
    
    // 实例化交通灯控制模块
    TRAFFIC_CTRL dut (
        .CLK(CLK_SIG),
        .RST(RST_SIG),
        .MAINLIGHTS(MAIN),
        .ALTERLIGHTS(ALTER)
    );
    
    // 生成时钟信号
    always begin
        CLK_SIG = 0;
        #CLK_PERIOD;
        CLK_SIG = 1;
        #CLK_PERIOD;
    end
    
    // 生成复位信号
    initial begin
        #2 RST_SIG = 1;
        #2 RST_SIG = 0;
    end
    
endmodule