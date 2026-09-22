// ======================================
// 半加器模块（最底层）
// ======================================
module half_adder (
    input  wire in1,
    input  wire in2,
    output wire sum_out,
    output wire carry_out
);
    assign sum_out   = in1 ^ in2;   // 异或得到本位和
    assign carry_out = in1 & in2;   // 与运算得到进位

endmodule