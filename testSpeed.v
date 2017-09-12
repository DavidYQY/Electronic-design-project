module testSpeed
(
	input clk_50Mhz,
	input speedInfrac,
	output reg [13:0] outSpeed
);

reg [26:0] cnt;
reg [6:0] circleCnt;
reg last;//=speedInfrac;

initial begin
	last=1;
	outSpeed=9999;
end

always@(posedge clk_50Mhz) begin
	if(speedInfrac!=last && speedInfrac) begin//posedge speedInfrac
		circleCnt=circleCnt+1;
	end
	else if(circleCnt>30) begin
		circleCnt=0;
		outSpeed=172787/cnt;//pi*d*10=172787,d=5.5cm,cm/s
		cnt=0;
	end
	else if(cnt < 50000) begin//50s
		cnt=cnt+1;
	end
	else begin
		cnt=0;
		outSpeed=0;
	end
	last=speedInfrac;
end


endmodule



