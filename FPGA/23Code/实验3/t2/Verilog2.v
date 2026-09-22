`timescale 1 ns/ 1 ps
module count_vt();

reg clk;
reg rst_n;
wire COUT;                                            
wire [7:0]  count_out;
                         
ripple_counter_1 i1 (.clk(clk),.CQ(count_out),.RST(rst_n),.COUT(COUT));

initial                                                
begin                                                                           
	clk = 0;
	rst_n= 0;
	
	#20;
	rst_n= 1;

	#600;
	$stop;                                                                  
end    
                                                
always                                                               
begin                                                                       
	#5 clk = ~clk;                                            
end   
                                                 
endmodule