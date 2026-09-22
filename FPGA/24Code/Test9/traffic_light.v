module traffic_light (
    input  wire clk,
    input  wire rst_n,
    output reg  [2:0] main_light,   // 主干道灯：{红, 黄, 绿}
    output reg  [2:0] side_light    // 支路灯：{红, 黄, 绿}
);

    // one-hot 状态编码
    localparam S_MAIN_GREEN = 4'b0001;
    localparam S_MAIN_YELLOW = 4'b0010;
    localparam S_SIDE_GREEN = 4'b0100;
    localparam S_SIDE_YELLOW = 4'b1000;

    // 为了仿真方便，时间设置得较短
    parameter MAIN_GREEN_TIME = 5;
    parameter YELLOW_TIME     = 2;
    parameter SIDE_GREEN_TIME = 4;

    reg [3:0] state;
    reg [3:0] next_state;
    reg [7:0] cnt;

    // 状态寄存器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S_MAIN_GREEN;
        else
            state <= next_state;
    end

    // 计数器
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 8'd0;
        else if (state != next_state)
            cnt <= 8'd0;
        else
            cnt <= cnt + 8'd1;
    end

    // 下一状态逻辑
    always @(*) begin
        next_state = state;

        case (state)
            S_MAIN_GREEN: begin
                if (cnt >= MAIN_GREEN_TIME - 1)
                    next_state = S_MAIN_YELLOW;
            end

            S_MAIN_YELLOW: begin
                if (cnt >= YELLOW_TIME - 1)
                    next_state = S_SIDE_GREEN;
            end

            S_SIDE_GREEN: begin
                if (cnt >= SIDE_GREEN_TIME - 1)
                    next_state = S_SIDE_YELLOW;
            end

            S_SIDE_YELLOW: begin
                if (cnt >= YELLOW_TIME - 1)
                    next_state = S_MAIN_GREEN;
            end

            default: begin
                next_state = S_MAIN_GREEN;
            end
        endcase
    end

    // 输出逻辑
    always @(*) begin
        case (state)
            S_MAIN_GREEN: begin
                main_light = 3'b001;   // 主干道绿
                side_light = 3'b100;   // 支路红
            end

            S_MAIN_YELLOW: begin
                main_light = 3'b010;   // 主干道黄
                side_light = 3'b100;   // 支路红
            end

            S_SIDE_GREEN: begin
                main_light = 3'b100;   // 主干道红
                side_light = 3'b001;   // 支路绿
            end

            S_SIDE_YELLOW: begin
                main_light = 3'b100;   // 主干道红
                side_light = 3'b010;   // 支路黄
            end

            default: begin
                main_light = 3'b100;
                side_light = 3'b100;
            end
        endcase
    end

endmodule