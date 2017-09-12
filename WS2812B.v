module WS2812B
(
	input write0,
	input write1,
	input reset,
	input clk_50Mhz,//0.02us
	output reg LED,
	output reg ready
);

reg [12:0] count;
reg resetStatus;
reg write1Status;
reg write0Status;
reg clear;

initial begin
	count=0;
	resetStatus=0;
	write1Status=0;
	write0Status=0;
	clear=0;
	ready<=1;
end

always @ (posedge reset or posedge clear) begin
	if (clear==1)
		resetStatus=0;
	else
		resetStatus=1;
end

always @ (posedge write0 or posedge clear) begin
	if (clear==1)
		write0Status=0;
	else
		write0Status=1;
end

always @ (posedge write1 or posedge clear) begin
	if (clear==1)
		write1Status=0;
	else
		write1Status=1;
end


always @ (posedge clk_50Mhz) begin
	if (resetStatus==1) begin//reseting
		if (count==4000) begin
			clear=1;
			count=0;
			ready<=1;
		end
		else begin
			ready<=0;	
			count=count+1;//reseting
			LED=0;
		end
	end
	else if (write1Status==1) begin //writing 1
		if (count==62) begin
			count=0;
			clear=1;
			ready<=1;
		end
		else begin
			ready<=0;
			count=count+1;
			if (count<50)
				LED=1;
			else
				LED=0;
		end
	end
	else if (write0Status==1) begin //writing 0
		if (count==62) begin
			count=0;
			clear=1;
			ready<=1;
		end
		else begin
			ready<=0;
			count=count+1;
			if (count<12)
				LED=1;
			else
				LED=0;
		end
	end
	else begin
		clear=0;
		count=0;
	end
end

endmodule
