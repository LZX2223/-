module sync_binary_counter_8bit (
    input  wire       clk,        // 时钟输入
    input  wire       rst_n,      // 异步复位，低电平有效
    input  wire       en,         // 计数使能信号
    output reg  [7:0] count_out,  // 8位计数输出
    output wire       COUT        // 进位输出
);

    // 当计数器输出为 11111111 且使能有效时，产生进位
    assign COUT = en & (&count_out);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_out <= 8'b00000000;      // 异步清零
        else if (en)
            count_out <= count_out + 1'b1; // 同步加1计数
        else
            count_out <= count_out;        // 保持当前状态
    end

endmodule