module coder (
    input [7:0] I,  // 8位输入信号
    input EI,       // 使能信号，高电平有效
    output reg [2:0] A, // 3位编码输出
    output reg GS,      // 组选择信号，低电平表示有效编码
    output reg EO       // 使能输出信号，用于级联
);

always @ (I or EI) begin
    if (EI) begin
        // 当使能端EI为1时，所有输出均为高电平
        A <= 3'b111;
        GS <= 1;
        EO <= 1;
    end else begin
        // 优先级编码逻辑
        casez (I)
            8'b0???????: begin A <= 3'b000; GS <= 0; EO <= 1; end // I[7]优先级最高
            8'b10??????: begin A <= 3'b001; GS <= 0; EO <= 1; end
            8'b110?????: begin A <= 3'b010; GS <= 0; EO <= 1; end
            8'b1110????: begin A <= 3'b011; GS <= 0; EO <= 1; end
            8'b11110???: begin A <= 3'b100; GS <= 0; EO <= 1; end
            8'b111110??: begin A <= 3'b101; GS <= 0; EO <= 1; end
            8'b1111110?: begin A <= 3'b110; GS <= 0; EO <= 1; end
            8'b11111110: begin A <= 3'b111; GS <= 0; EO <= 1; end
            8'b11111111: begin A <= 3'b111; GS <= 1; EO <= 0; end // 输入全为1时，除EO外，全部输出高电平
            default: begin A <= 3'b111; GS <= 1; EO <= 1; end // 默认情况
        endcase
    end
end
endmodule