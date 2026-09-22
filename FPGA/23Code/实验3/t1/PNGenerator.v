module PNGenerator(clk,rst,en,dout,y);  
input clk;  
input rst;  
input en;  
output dout;  
output reg [4:0] y;  
  
assign dout=y[0];  
  
always@(posedge clk or negedge rst) begin  
    if(~rst) begin  
        y<=5'b00001;  
    end  
    else if(en) begin  
        y[0]<=y[1];  
        y[1]<=y[2];  
        y[2]<=y[3];  
        y[3]<=y[4];  
        y[4]<=y[0]^y[1]^y[2]^y[3];  
    end  
    else begin  
        y<=y;  
    end  
end  
  
endmodule
