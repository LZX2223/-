// 4位BCD全加器模块
module BCD_adder4 (
    input [3:0] a,        // 输入的4位BCD数a
    input [3:0] b,        // 输入的4位BCD数b
    input cin,            // 低位的进位输入
    output reg [3:0] c,   // 输出的4位BCD结果数
    output reg cout       // 向高位的进位输出
);
    wire [4:0] c1;        // 用于存储5位加和结果（包括可能的进位）
    assign c1 = {1'b0, a} + {1'b0, b} + cin; // 将a、b和cin相加，得到5位结果

    always @(c1) begin
        if (c1 > 5'd9) begin // 如果加和大于9，需要进行修正
            c = c1[3:0] + 4'b0110; // 加6进行修正
            cout = 1'b1;           // 产生进位
        end else begin
            c = c1[3:0]; // 加和小于等于9，直接输出结果
            cout = 1'b0; // 不产生进位
        end
    end
endmodule

// 16位BCD全加器模块
module BCD_Adder16 (
    input [15:0] a,       // 输入的16位BCD数a
    input [15:0] b,       // 输入的16位BCD数b
    input cin,            // 低位的进位输入
    output wire [15:0] c, // 输出的16位BCD结果数
    output wire cout      // 向更高位的进位输出
);
    wire [3:0] couts;     // 用于存储中间进位信号

    // 实例化4个4位BCD全加器，级联实现16位BCD全加器
    BCD_adder4 u0 (.a(a[3:0]), .b(b[3:0]), .cin(cin), .c(c[3:0]), .cout(couts[0]));
    BCD_adder4 u1 (.a(a[7:4]), .b(b[7:4]), .cin(couts[0]), .c(c[7:4]), .cout(couts[1]));
    BCD_adder4 u2 (.a(a[11:8]), .b(b[11:8]), .cin(couts[1]), .c(c[11:8]), .cout(couts[2]));
    BCD_adder4 u3 (.a(a[15:12]), .b(b[15:12]), .cin(couts[2]), .c(c[15:12]), .cout(couts[3]));

    assign cout = couts[3]; // 将最后一个4位BCD全加器的进位作为16位全加器的进位输出
endmodule