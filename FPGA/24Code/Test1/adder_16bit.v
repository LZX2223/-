// ======================================
// 16位二进制全加器模块（顶层模块）
// 采用层次化设计：半加器 → 或门 → 1位全加器 → 4位全加器 → 16位全加器
// ======================================
module adder_16bit (
    input  [15:0] A,        // 16位加数A
    input  [15:0] B,        // 16位加数B
    input         C_in,     // 最低位进位输入
    output [15:0] Sum,      // 16位加和输出
    output        C_out     // 最终进位输出
);
    wire carry0, carry1, carry2;

    // 实例化4个4位全加器，逐级传递进位信号
    adder_4bit fa0 (.A(A[3:0]),   .B(B[3:0]),   .C_in(C_in),  .S(Sum[3:0]),   .C_out(carry0));
    adder_4bit fa1 (.A(A[7:4]),   .B(B[7:4]),   .C_in(carry0), .S(Sum[7:4]),   .C_out(carry1));
    adder_4bit fa2 (.A(A[11:8]),  .B(B[11:8]),  .C_in(carry1), .S(Sum[11:8]),  .C_out(carry2));
    adder_4bit fa3 (.A(A[15:12]), .B(B[15:12]), .C_in(carry2), .S(Sum[15:12]), .C_out(C_out));

endmodule