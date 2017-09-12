module rxd(clk_9600Hz, rxd, c, recieve, err);
	input clk_9600Hz;
	input rxd;
	output reg[7:0] c;
	output reg recieve;//posedge
	output reg err;
	reg[7:0] q;
	reg flag;
	reg[3:0] count;
	always@(posedge clk_9600Hz)
	begin
		if(flag==0) begin //not recieving
			if(rxd==0) begin
				if(recieve==1) begin
					err=1;
				end
				else begin flag=1; count=0; recieve=0; err=0; end
			end
			else begin
				err=0;
				if(recieve==1) recieve=0;
			end
		end
		else begin //recieving
			if(count==8) begin flag<=0; c<=q; recieve<=1; end
			else q[count]<=rxd;
			count<=count+1;
		end
	end
endmodule
