// ======================================
// 1位全加器模块（使用两个半加器 + 一个或门实现）
// ======================================
module full_adder (
    input  wire in1,
    input  wire in2,
    input  wire carry_in,
    output wire sum_out,
    output wire carry_out
);
    wire temp_sum;     // 第一个半加器的和
    wire carry1;       // 第一个半加器的进位
    wire carry2;       // 第二个半加器的进位

    // 第一个半加器：in1 + in2
    half_adder ha1 (
        .in1(in1),
        .in2(in2),
        .sum_out(temp_sum),
        .carry_out(carry1)
    );

    // 第二个半加器：temp_sum + carry_in
    half_adder ha2 (
        .in1(temp_sum),
        .in2(carry_in),
        .sum_out(sum_out),
        .carry_out(carry2)
    );

    // 或门合并两个进位，得到最终进位
    or_gate og (
        .in1(carry1),
        .in2(carry2),
        .out(carry_out)
    );

endmodule