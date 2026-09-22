module ripple_counter_1(
    input clk,
    input RST,
    output [7:0] CQ,
    output COUT
);
    assign COUT = &CQ; // 当所有位为1时，COUT=1
    
    // 异步级联：前一级输出作为下一级时钟
    T_FF ff0(.clk(clk),  .RST(RST), .Q(CQ[0]));
    T_FF ff1(.clk(~CQ[0]), .RST(RST), .Q(CQ[1])); // 注意取反
    T_FF ff2(.clk(~CQ[1]), .RST(RST), .Q(CQ[2]));
    // ... 继续级联剩余位
endmodule

module T_FF(input clk, RST, output reg Q);
    always @(posedge clk or negedge RST) begin
        if (!RST) Q <= 0;
        else      Q <= ~Q; // T触发器翻转
    end
endmodule