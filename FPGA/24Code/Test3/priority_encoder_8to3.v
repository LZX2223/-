// ======================================
// 8-3线优先编码器（74LS148功能兼容）
// 输入低电平有效，输出低电平有效
// ======================================
module priority_encoder_8to3 (
    input wire EI,           // 使能输入，低电平有效
    input wire [7:0] I,      // 8个编码输入（I7优先级最高）
    output reg [2:0] Y,      // 3位编码输出（低电平有效）
    output reg GS,           // 组信号输出（低电平有效，有输入时为0）
    output reg EO            // 使能输出（用于级联）
);

    always @(*) begin
        if (EI == 1'b1) begin     // 使能无效
            Y  = 3'b111;
            GS = 1'b1;
            EO = 1'b1;
        end
        else begin
            casex(I)              // casex支持X状态，优先级从高到低
                8'b0xxxxxxx: begin Y = 3'b000; GS = 1'b0; EO = 1'b1; end  // I7
                8'b10xxxxxx: begin Y = 3'b001; GS = 1'b0; EO = 1'b1; end  // I6
                8'b110xxxxx: begin Y = 3'b010; GS = 1'b0; EO = 1'b1; end  // I5
                8'b1110xxxx: begin Y = 3'b011; GS = 1'b0; EO = 1'b1; end  // I4
                8'b11110xxx: begin Y = 3'b100; GS = 1'b0; EO = 1'b1; end  // I3
                8'b111110xx: begin Y = 3'b101; GS = 1'b0; EO = 1'b1; end  // I2
                8'b1111110x: begin Y = 3'b110; GS = 1'b0; EO = 1'b1; end  // I1
                8'b11111110: begin Y = 3'b111; GS = 1'b0; EO = 1'b1; end  // I0
                8'b11111111: begin Y = 3'b111; GS = 1'b1; EO = 1'b0; end  // 无输入
                default:     begin Y = 3'b111; GS = 1'b1; EO = 1'b1; end
            endcase
        end
    end

endmodule