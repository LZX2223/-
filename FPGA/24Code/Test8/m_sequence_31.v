module m_sequence_31 (
    input  wire clk,
    input  wire rst_n,
    output wire m_out,
    output reg  [4:0] q
);

    wire feedback;

    // 75(8) = 111101(2)
    // 对应反馈：q[4] ^ q[3] ^ q[2] ^ q[0]
    assign feedback = q[4] ^ q[3] ^ q[2] ^ q[0];

    assign m_out = q[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 5'b11111;          // 初始状态不能为全0
        else
            q <= {feedback, q[4:1]}; // 右移，反馈送入最高位
    end

endmodule