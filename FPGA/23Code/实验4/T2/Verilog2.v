`timescale 1ns / 1ps
module TRAFFIC_CTRL_TB;

    // 测试信号声明
    reg         CLK_TB;    // 测试时钟
    reg         RST_TB;    // 测试复位（必须为reg类型）
    wire [2:0]  MAIN_TB;   // 监测主干道信号灯输出
    wire [2:0]  ALTER_TB;  // 监测支路信号灯输出

    parameter CLK_PERIOD = 2;  // 时钟周期2ns（1ns高电平+1ns低电平）

    // 实例化被测模块
    TRAFFIC_CTRL uut (
        .CLK(CLK_TB),
        .RST(RST_TB),
        .MAINLIGHT(MAIN_TB),
        .ALTERLIGHT(ALTER_TB)
    );

    // 生成50MHz时钟（周期2ns）
    always begin
        CLK_TB = 1'b0;
        #(CLK_PERIOD/2);
        CLK_TB = 1'b1;
        #(CLK_PERIOD/2);
    end

    // 复位控制序列
    initial begin
        RST_TB = 1'b1;     // 上电立即复位
        #2 RST_TB = 1'b0;  // 2ns后释放复位
        // 可在此添加更多测试激励
    end

endmodule