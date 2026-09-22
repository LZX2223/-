// ======================================
// 8位二进制全加器（带使能和异步复位）
// ======================================
module adder_8bit_en_rst (
    input wire        clk,      // 时钟信号
    input wire        rst,      // 异步高电平复位
    input wire        en,       // 高电平使能
    input wire [7:0]  A,        // 8位加数 A
    input wire [7:0]  B,        // 8位加数 B
    input wire        Cin,      // 最低位进位输入
    output reg [7:0]  Sum,      // 8位加和输出
    output reg        Cout      // 最终进位输出
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Sum  <= 8'b0000_0000;
            Cout <= 1'b0;
        end
        else if (en) begin
            {Cout, Sum} <= A + B + Cin;   // 8位加法，自动处理进位
        end
        // en = 0 时保持当前输出不变
    end

endmodule