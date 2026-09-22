module sync_binary_counter(
    input  wire       clk,
    input  wire       rst_n,
    output wire [7:0] count_out,
    output wire       COUT
);

    assign COUT = &count_out;

    T_FF ff0(
        .clk(clk),
        .rst_n(rst_n),
        .Q(count_out[0])
    );

    T_FF ff1(
        .clk(~count_out[0]),
        .rst_n(rst_n),
        .Q(count_out[1])
    );

    T_FF ff2(
        .clk(~count_out[1]),
        .rst_n(rst_n),
        .Q(count_out[2])
    );

    T_FF ff3(
        .clk(~count_out[2]),
        .rst_n(rst_n),
        .Q(count_out[3])
    );

    T_FF ff4(
        .clk(~count_out[3]),
        .rst_n(rst_n),
        .Q(count_out[4])
    );

    T_FF ff5(
        .clk(~count_out[4]),
        .rst_n(rst_n),
        .Q(count_out[5])
    );

    T_FF ff6(
        .clk(~count_out[5]),
        .rst_n(rst_n),
        .Q(count_out[6])
    );

    T_FF ff7(
        .clk(~count_out[6]),
        .rst_n(rst_n),
        .Q(count_out[7])
    );

endmodule


module T_FF(
    input  wire clk,
    input  wire rst_n,
    output reg  Q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 1'b0;
        else
            Q <= ~Q;
    end

endmodule