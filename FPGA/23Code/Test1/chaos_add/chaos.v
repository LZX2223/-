//一位加法器
module Add1
(
		input a,		//加数
		input b,		//加数
		input C_in,	//进位信号
		output f,		//和输出
		output g,	//生成信号g=ab
		output p		//传播信号p=a+b
		);
assign f=a^b^C_in;
assign g=a&b;
assign p=a|b;
endmodule
//4位CLA部件		//用来计算生成信号和传播信号,提前算出是否有进位，module CLA_4(
		input [3:0]P,
		input [3:0]G,
		input C_in,
		output [4:1]Ci,
		output Gm,
		output Pm
	);
assign Ci[1]=G[0]|P[0]&C_in;		//Ci+1=Gi+PiCi
assign Ci[2]=G[1]|P[1]&G[0]|P[1]&P[0]&C_in;
assign Ci[3]=G[2]|P[2]&G[1]|P[2]&P[1]&G[0]|P[2]&P[1]&P[0]&C_in;
assign Ci[4]=G[3]|P[3]&G[2]|P[3]&P[2]&G[1]|P[3]&P[2]&P[1]&G[0]|P[3]&P[2]&P[1]&P[0]&C_in;

assign Gm=G[3]|P[3]&G[2]|P[3]&P[2]&G[1]|P[3]&P[2]&P[1]&G[0];
assign Pm=P[3]&P[2]&P[1]&P[0];
endmodule
//四位超前进位加法器
module Add4_head
(
	input [3:0]A,
	input [3:0]B,
	input C_in,
	output [3:0]F,
	output Gm,
	output Pm,
	output C_out
);
	wire [3:0] G;
	wire [3:0] P;
	wire [4:1] C;
 Add1 u1
 (	.a(A[0]),
	.b(B[0]),
	.C_in(C_in),
	.f(F[0]),
	.g(G[0]),
	.p(P[0])
 );
  Add1 u2
 (	.a(A[1]),
	.b(B[1]),
	.C_in(C[1]),
	.f(F[1]),
	.g(G[1]),
	.p(P[1])
 );
   Add1 u3
 (	.a(A[2]),
	.b(B[2]),
	.C_in(C[2]),
	.f(F[2]),
	.g(G[2]),
	.p(P[2])
 );
   Add1 u4
 (	.a(A[3]),
	.b(B[3]),
	.C_in(C[3]),
	.f(F[3]),
	.g(G[3]),
	.p(P[3])
 );
 CLA_4 uut
 (
	.P(P),
	.G(G),
	.C_in(C_in),
	.Ci(C),
	.Gm(Gm),
	.Pm(Pm)
 );
  assign C_out=C[4];
 endmodule
 //16位
 module Add16_head
 (
	input [15:0]A,
	input [15:0]B,
	input C_in,
	output [15:0] F,
	output Gm,
	output Pm,
	output C_out
 );
 wire [3:0]G;
 wire [3:0]P;
 wire [4:1]C;
Add4_head A0
 (
	.A(A[3:0]),
	.B(B[3:0]),
	.C_in(C_in),
	.F(F[3:0]),
	.Gm(G[0]),
	.Pm(P[0])
 );
 Add4_head A1
 (
	.A(A[7:4]),
	.B(B[7:4]),
	.C_in(C[1]),
	.F(F[7:4]),
	.Gm(G[1]),
	.Pm(P[1])
 );
 Add4_head A3
 (
	.A(A[11:8]),
	.B(B[11:8]),
	.C_in(C[2]),
	.F(F[11:8]),
	.Gm(G[2]),
	.Pm(P[2])
 );
 Add4_head A4
 (
	.A(A[15:12]),
	.B(B[15:12]),
	.C_in(C[3]),
	.F(F[15:12]),
	.Gm(G[3]),
	.Pm(P[3])
 );
  CLA_4 AAt
 (
	.P(P),
	.G(G),
	.C_in(C_in),
	.Ci(C),
	.Gm(Gm),
	.Pm(Pm)
 );
 assign C_out=C[4];
 endmodule
