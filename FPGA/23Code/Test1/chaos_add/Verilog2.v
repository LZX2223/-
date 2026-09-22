`timescale 1ns / 1ps
module add16_head_tb;
   reg [15:0] A;
   reg [15:0] B;
   reg      CIN;
   wire [15:0] DOUT1;
   wire        COUT1;
   parameter   clk_period = 5;
	
   ADD16 U1(.A(A), .B(B), .CIN(CIN), .DOUT(DOUT1), .COUT(COUT1));
	always
	begin:pr1
A <= 16'b0101010101010010;
      B <= 16'b0100101010000100;
      CIN <= 1'b1;
      #(clk_period);
      A <= 16'b0111011011110010;
      B <= 16'b0111101010000100;
      CIN <= 1'b0;
      #(clk_period);
      A <= 16'b1001011011110010;
      B <= 16'b1001101000000100;
      CIN <= 1'b1;
      #(clk_period);
      A <= 16'b1101011011110010;
      B <= 16'b1011101001110100;
      CIN <= 1'b1;
      #(clk_period);
   end
endmodule
