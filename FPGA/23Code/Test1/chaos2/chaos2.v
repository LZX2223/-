// 1位全加器模块
module Add1 (
    input a,       // 加数a
    input b,       // 加数b
    input C_in,    // 输入进位信号
    output f,      // 和输出
    output g,      // 生成信号 g = a & b
    output p       // 传播信号 p = a | b
);
    assign f = a ^ b ^ C_in;  // 计算和
    assign g = a & b;        // 生成信号
    assign p = a | b;        // 传播信号
endmodule

// 4位CLA（超前进位）模块，用于计算生成信号和传播信号，并提前计算进位
module CLA_4 (
    input [3:0] P,   // 4位传播信号
    input [3:0] G,   // 4位生成信号
    input C_in,      // 输入进位信号
    output [4:1] Ci, // 4位进位信号输出
    output Gm,       // 组生成信号
    output Pm        // 组传播信号
);
    assign Ci[1] = G[0] | (P[0] & C_in);  // 第1位进位
    assign Ci[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C_in);  // 第2位进位
    assign Ci[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C_in);  // 第3位进位
    assign Ci[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C_in);  // 第4位进位

    assign Gm = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);  // 组生成信号
    assign Pm = P[3] & P[2] & P[1] & P[0];  // 组传播信号
endmodule

// 4位超前进位加法器模块
module Add4_head (
    input [3:0] A,    // 4位加数A
    input [3:0] B,    // 4位加数B
    input C_in,       // 输入进位信号
    output [3:0] F,   // 4位和输出
    output Gm,        // 组生成信号
    output Pm,        // 组传播信号
    output C_out      // 输出进位信号
);
    wire [3:0] G;  // 生成信号
    wire [3:0] P;  // 传播信号
    wire [4:1] C;  // 进位信号

    // 实例化4个1位全加器
    Add1 u1 (.a(A[0]), .b(B[0]), .C_in(C_in), .f(F[0]), .g(G[0]), .p(P[0]));
    Add1 u2 (.a(A[1]), .b(B[1]), .C_in(C[1]), .f(F[1]), .g(G[1]), .p(P[1]));
    Add1 u3 (.a(A[2]), .b(B[2]), .C_in(C[2]), .f(F[2]), .g(G[2]), .p(P[2]));
    Add1 u4 (.a(A[3]), .b(B[3]), .C_in(C[3]), .f(F[3]), .g(G[3]), .p(P[3]));

    // 实例化4位CLA模块
    CLA_4 uut (.P(P), .G(G), .C_in(C_in), .Ci(C), .Gm(Gm), .Pm(Pm));

    assign C_out = C[4];  // 输出进位信号
endmodule

// 16位超前进位加法器模块
module chaos2 (
    input [15:0] A,    // 16位加数A
    input [15:0] B,    // 16位加数B
    input C_in,        // 输入进位信号
    output [15:0] F,   // 16位和输出
    output Gm,         // 组生成信号
    output Pm,         // 组传播信号
    output C_out       // 输出进位信号
);
    wire [3:0] G;  // 组生成信号
    wire [3:0] P;  // 组传播信号
    wire [4:1] C;  // 进位信号

    // 实例化4个4位超前进位加法器模块
    Add4_head A0 (.A(A[3:0]), .B(B[3:0]), .C_in(C_in), .F(F[3:0]), .Gm(G[0]), .Pm(P[0]));
    Add4_head A1 (.A(A[7:4]), .B(B[7:4]), .C_in(C[1]), .F(F[7:4]), .Gm(G[1]), .Pm(P[1]));
    Add4_head A3 (.A(A[11:8]), .B(B[11:8]), .C_in(C[2]), .F(F[11:8]), .Gm(G[2]), .Pm(P[2]));
    Add4_head A4 (.A(A[15:12]), .B(B[15:12]), .C_in(C[3]), .F(F[15:12]), .Gm(G[3]), .Pm(P[3]));

    // 实例化4位CLA模块，用于计算16位加法器的进位
    CLA_4 AAt (.P(P), .G(G), .C_in(C_in), .Ci(C), .Gm(Gm), .Pm(Pm));

    assign C_out = C[4];  // 输出进位信号
endmodule