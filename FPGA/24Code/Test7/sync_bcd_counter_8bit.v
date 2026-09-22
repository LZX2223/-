module sync_bcd_counter_8bit (
    input  wire       clk,        // 时钟输入
    input  wire       rst_n,      // 异步复位，低电平有效
    input  wire       en,         // 计数使能
    output reg  [7:0] bcd_out,    // 8位BCD输出，高4位十位，低4位个位
    output reg        COUT        // 进位输出，计数到99时置1
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bcd_out <= 8'b0000_0000;
            COUT    <= 1'b0;
        end
        else if (en) begin
            COUT <= 1'b0;

            // 当计数到99时，下一个时钟回到00，并产生进位
            if (bcd_out == 8'b1001_1001) begin
                bcd_out <= 8'b0000_0000;
                COUT    <= 1'b1;
            end
            // 个位为9时，个位清零，十位加1
            else if (bcd_out[3:0] == 4'b1001) begin
                bcd_out[3:0] <= 4'b0000;
                bcd_out[7:4] <= bcd_out[7:4] + 1'b1;
            end
            // 普通情况，个位加1
            else begin
                bcd_out[3:0] <= bcd_out[3:0] + 1'b1;
                bcd_out[7:4] <= bcd_out[7:4];
            end
        end
        else begin
            bcd_out <= bcd_out;
            COUT    <= COUT;
        end
    end

endmodule