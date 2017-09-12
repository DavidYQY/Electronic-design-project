module Correspond
(
	input clk_1,
	input clk_9600,
	input ready,
	input [7:0] speed,//1
	input [7:0] distance,//2
	input [3:0] signs,//3
	input [8:0] degree,//3
	output reg send,
	output reg [7:0] data,
	input direction
);

reg status;
reg resetStatus;
reg resetSend;
reg [3:0] byteCount;
reg [7:0] third;
reg [1:0] temp;

always @(posedge clk_1 or posedge resetStatus) begin
	if(resetStatus==1)
		status=0;
	else
		status=1;
end

always @(posedge clk_9600) begin
	if(resetSend==1) begin
		send=0;
		resetSend=0;
	end
	else if(status==1) begin
		byteCount=8;
		resetStatus=1;
	end
	else if(ready==1) begin
		resetStatus=0;
		if(byteCount==0)
			send=0;
		else begin
			if(degree>100) temp=2;
			else if(degree>80) temp=1;
			else temp=0;
			third[7:0]={1'b0,direction,temp,4'b1010};//{2'b01,temp,signs}
			case(byteCount)
				8: data=speed;
				7: data=distance;
				6: data=third;
				2: data=8'b00001101;//0D,DEC 13
				1: data=8'b00001010;//0A,DEC 10
				default: data=0;
			endcase
			send=1;
			resetSend=1;
			byteCount=byteCount-1;
		end
	end
	else begin
		send=0;
		resetStatus=0;
	end
end


endmodule
