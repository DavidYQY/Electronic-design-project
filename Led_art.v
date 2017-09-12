module Led_art
(
	input clk_50Mhz,//1.25us
	input ready,
	input led_begin,
	input [23:0] input_grb,
	output reg write0,
	output reg write1,
	//output reg [5:0] digit,
	output reg reset
);

reg [7:0] digit;
reg [23:0] grb;
reg [23:0] tempgrb;
reg [11:0] count;
reg clkOut;
reg status;

initial begin
	write0<=0;
	write1<=0;
	reset<=0;
	digit<=0;
	//clkOut<=1;
end
	
	
always @ (posedge clk_50Mhz)
begin
	if (count< 1)
		count=count+1;
	else
	begin
		clkOut=~clkOut;
		count=0;
	end
end


always @ (posedge clkOut) begin
	if (led_begin==1 && digit==0) begin
		digit=193;
		grb=input_grb;
		tempgrb=input_grb;
		write1=0;
		write0=0;
		reset=0;
	end
	
	else if(digit==0) begin
		write1=0;
		write0=0;
		reset=0;
	end
	
	else begin
		if(status==1) begin
			write1=0;
			write0=0;
			reset=0;
			status<=0;
			if(digit % 24==0) 
				grb=tempgrb;
		end
		else if (ready==1) begin
			if (digit==193) begin
				reset<=1;
				write1<=0;
				write0<=0;
				digit<=digit-1;
			end
			else begin
				if (grb & 8388608) begin
					reset<=0;
					write1<=1;
					write0<=0;
					grb = grb << 1;
				end
				else begin
					reset<=0;
					write1<=0;
					write0<=1;
					grb = grb <<  1;
				end
				digit<=digit-1;
				status<=1;
			end
		end
	end
end

endmodule




