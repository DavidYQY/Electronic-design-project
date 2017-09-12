module txd(clk_9600Hz, c, send, txd, avail);
	input clk_9600Hz;
	input [7:0] c;
	input send;//posedge
	output reg txd;
	output reg avail;//ready
	
	reg flag;
	reg[3:0] count;
	reg last_send;
	
initial begin
	last_send=0;
	flag=0;
	count=0;
end
	
always@(posedge clk_9600Hz)
begin
	if(flag==0) begin
		if(send!=last_send&&send==1) begin
			 txd=0;
			 count=0;
			 flag=1;
		end
		else 
			txd=1;
	end
	else begin
		if(count>=8) begin
			txd=1;
			count=0;
			flag=0;
		end
		else begin
			txd<=c[count];
			count<=count+1;
		end
	end
	last_send<=send;
	avail<=!flag;
end
endmodule
