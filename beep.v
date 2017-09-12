module beep(clk,enable,beep);

input clk;
input enable;

output beep;

reg beep;

reg[27:0]tone;

reg[14:0]counter;

always@(posedge clk)

begin

if(enable==1)
	tone<=tone+1;

else
	tone=0;

end

wire[6:0]fastsweep=(tone[22]?tone[21:15]:~tone[21:15]);

wire[6:0]slowsweep=(tone[25]?tone[24:18]:~tone[24:18]);

wire[14:0]clkdivider={2'b01,(tone[27]?slowsweep:fastsweep),6'b000000};
always@(posedge clk)

begin

if(enable==1)
	if(counter==0) counter<=clkdivider;

	else counter<=counter-1;
else
	;

end

always@(posedge clk)

begin


if(enable==0)

beep=0;

else if(counter==0)

beep<=~beep;

end




endmodule
