module TRAFFIC_CTRL(
    input  wire        CLK,
    input  wire        RST,
    output reg  [2:0]  MAINLIGHT,
    output reg  [2:0]  ALTERLIGHT
);

    // 状态编码
    localparam [1:0]  
        MAIN_GREEN  = 2'd0,  // 主干道绿灯，支路红灯
        MAIN_YELLOW = 2'd1,  // 主干道黄灯，支路红灯
        ALTER_GREEN = 2'd2,  // 主干道红灯，支路绿灯
        ALTER_YELLOW= 2'd3;  // 主干道红灯，支路黄灯

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [6:0] timer;

    // 计时器逻辑
    always @(posedge CLK or posedge RST) begin
        if (RST) 
            timer <= 7'd0;
        else begin
            if (timer < 7'd68) 
                timer <= timer + 7'd1;
            else 
                timer <= 7'd0;
        end
    end

    // 状态转移逻辑
    always @(current_state or timer) begin
        case (current_state)
            MAIN_GREEN: begin
                MAINLIGHT  <= 3'b010;  // 绿灯
                ALTERLIGHT <= 3'b100;  // 红灯
                next_state = (timer == 7'd39) ? MAIN_YELLOW : MAIN_GREEN;
            end
            MAIN_YELLOW: begin
                MAINLIGHT  <= 3'b001;  // 黄灯
                ALTERLIGHT <= 3'b100;  // 红灯
                next_state = (timer == 7'd43) ? ALTER_GREEN : MAIN_YELLOW;
            end
            ALTER_GREEN: begin
                MAINLIGHT  <= 3'b100;  // 红灯
                ALTERLIGHT <= 3'b010;  // 绿灯
                next_state = (timer == 7'd63) ? ALTER_YELLOW : ALTER_GREEN;
            end
            ALTER_YELLOW: begin
                MAINLIGHT  <= 3'b100;  // 红灯
                ALTERLIGHT <= 3'b001;  // 黄灯
                next_state = (timer == 7'd67) ? MAIN_GREEN : ALTER_YELLOW;
            end
        endcase
    end

    // 状态寄存器更新
    always @(posedge CLK or posedge RST) begin
        if (RST) 
            current_state <= MAIN_GREEN;
        else 
            current_state <= next_state;
    end

endmodule