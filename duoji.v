module duoji
(
	input clk_10k,//0.1ms
	input [8:0] degree,
	output reg steer
);

reg [8:0] count;
reg [4:0] target;


always @ (posedge clk_10k) begin
	if (count>=199) 
		count=0;
	else
		count=count+1;
	
	target=13+degree/10;
	
	if (count<target)
		steer=1;
	else
		steer=0;
end

endmodule