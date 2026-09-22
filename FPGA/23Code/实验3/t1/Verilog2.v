`timescale 1 ps/ 1 ps  
module PNGenerator_vlg_tst();  
reg clk;  
reg en;  
reg rst;                                              
wire dout;  
wire [4:0]  y;  
PNGenerator i1 (  
    .clk(clk),  
    .dout(dout),  
    .en(en),  
    .rst(rst),  
    .y(y)  
);  
initial                                                  
begin                                                    
clk<=0;rst<=0;en<=0;  
#17  
    rst<=1;  
#17  
    en<=1;  
#6000 $stop;      
end  
always #5 clk<=~clk;  
endmodule
