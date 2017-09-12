module PWM
(
	input clk_10k,
	input [7:0] speed,
	input direction,
	output reg PWML,
	output reg PWMR
);
reg [7:0] cnt;


always @(posedge clk_10k) begin
	if (cnt>=100) cnt =0; 
	else begin
	cnt=cnt+1;
	if (direction==1) begin
		if(cnt<speed) begin
			PWML=1;
			PWMR=0;
		end
		else begin
			PWML=0;
			PWMR=0;
		end
	end
	else begin
		if(cnt<speed) begin
			PWML=0;
			PWMR=1;
		end
		else begin
			PWML=0;
			PWMR=0;
		end
	end
	end
end

endmodule