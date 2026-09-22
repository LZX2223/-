// 16-bit Carry Lookahead Adder (Structural Design)
module BINARY_ADDER_16BIT(
    input wire [15:0] data_x,       // Primary input operand
    input wire [15:0] data_y,       // Secondary input operand  
    input wire initial_carry,       // Initial carry input
    output reg [15:0] result_sum,   // Computed sum output
    output reg final_carry         // Final carry output
);

    // Internal carry propagation wires
    wire [16:0] sum_with_carry;

    // Sign-extended addition with carry
    always @(*) begin
        sum_with_carry = {1'b0, data_x} + {1'b0, data_y} + {16'b0, initial_carry};
        result_sum = sum_with_carry[15:0];
        final_carry = sum_with_carry[16];
    end

endmodule