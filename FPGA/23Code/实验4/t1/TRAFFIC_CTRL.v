module TRAFFIC_CTRL(
    input CLK,
    input RST,
    output reg [1:0] MAINLIGHTS,  // 主干道信号灯
    output reg [1:0] ALTERLIGHTS   // 支路信号灯
);
    // 状态定义
    localparam [1:0] 
        MAIN_GREEN = 0,
        MAIN_YELLOW = 1,
        ALTER_GREEN = 2,
        ALTER_YELLOW = 3;
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [6:0] timer;
    
    // 定时器控制逻辑
    always @(posedge CLK or posedge RST) begin: TIMER_CTRL
        if (RST) 
            timer <= 7'd0;
        else begin
            if (timer < 7'd68)
                timer <= timer + 7'd1;
            else
                timer <= 7'd0;
        end
    end
    
    // 状态转换逻辑
    always @(current_state or timer) begin: STATE_TRANSITION
        case (current_state)
            MAIN_GREEN: begin  // 主干道绿灯，支路红灯
                MAINLIGHTS <= 2'b01;
                ALTERLIGHTS <= 2'b11;
                if (timer == 7'd39)
                    next_state <= MAIN_YELLOW;
                else
                    next_state <= MAIN_GREEN;
            end
            MAIN_YELLOW: begin  // 主干道黄灯，支路红灯
                MAINLIGHTS <= 2'b00;
                ALTERLIGHTS <= 2'b11;
                if (timer == 7'd43)
                    next_state <= ALTER_GREEN;
                else
                    next_state <= MAIN_YELLOW;
            end
            ALTER_GREEN: begin  // 主干道红灯，支路绿灯
                MAINLIGHTS <= 2'b11;
                ALTERLIGHTS <= 2'b01;
                if (timer == 7'd63)
                    next_state <= ALTER_YELLOW;
                else
                    next_state <= ALTER_GREEN;
            end
            ALTER_YELLOW: begin  // 主干道红灯，支路黄灯
                MAINLIGHTS <= 2'b11;
                ALTERLIGHTS <= 2'b00;
                if (timer == 7'd67)
                    next_state <= MAIN_GREEN;
                else
                    next_state <= ALTER_YELLOW;
            end
            default: next_state <= MAIN_GREEN;
        endcase
    end
    
    // 状态寄存器更新
    always @(posedge CLK or posedge RST) begin: STATE_REGISTER
        if (RST)
            current_state <= MAIN_GREEN;
        else 
            current_state <= next_state;
    end
endmodule