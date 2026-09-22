// ======================================
// 4位二进制全加器模块
// 由4个1位全加器级联组成
// ======================================
module adder_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input        C_in,
    output [3:0] S,
    output       C_out
);
    wire carry0, carry1, carry2;

    // 实例化4个1位全加器
    full_adder fa0 (.in1(A[0]), .in2(B[0]), .carry_in(C_in),  .sum_out(S[0]), .carry_out(carry0));
    full_adder fa1 (.in1(A[1]), .in2(B[1]), .carry_in(carry0), .sum_out(S[1]), .carry_out(carry1));
    full_adder fa2 (.in1(A[2]), .in2(B[2]), .carry_in(carry1), .sum_out(S[2]), .carry_out(carry2));
    full_adder fa3 (.in1(A[3]), .in2(B[3]), .carry_in(carry2), .sum_out(S[3]), .carry_out(C_out));

endmodule