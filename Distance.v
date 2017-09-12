module Distance//超声波测距模块
(
	input clk_16k,//根据理论计算，当频率为16.775kHz时，计数器计数值即为距离数（单位：cm），简化算法
	input recieve,//超声波模块接收回的反射信号,其高电平持续时间即为超声波往返时间
	output reg[7:0] dis
);

	reg [7:0]cnt = 0;//计数值
	always@ (posedge clk_16k) 
	begin
		if(recieve==1)
		begin
			if(cnt<99) cnt=cnt+1;
		end
		else
		begin
			cnt=0;//为下次计数清零
		end
	end
	always@ (negedge recieve) begin
		dis=cnt;
	end
endmodule
