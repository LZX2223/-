module decoder_74LS138 (
    input G1, G2A, G2B, // 控制信号
    input C, B, A,       // 3 位二进制输入
    output reg [7:0] Y   // 8 位低电平有效输出
);

always @ (*) begin
    if (G1 && !G2A && !G2B) begin
        // 译码器处于工作状态
        case ({C, B, A})
            3'b000: Y = 8'b11111110; // Y0 = 0
            3'b001: Y = 8'b11111101; // Y1 = 0
            3'b010: Y = 8'b11111011; // Y2 = 0
            3'b011: Y = 8'b11110111; // Y3 = 0
            3'b100: Y = 8'b11101111; // Y4 = 0
            3'b101: Y = 8'b11011111; // Y5 = 0
            3'b110: Y = 8'b10111111; // Y6 = 0
            3'b111: Y = 8'b01111111; // Y7 = 0
            default: Y = 8'b11111111; // 默认情况
        endcase
    end else begin
        // 译码器被禁止，所有输出为高电平
        Y = 8'b11111111;
    end
end
endmodule