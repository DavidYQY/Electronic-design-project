module divider(clk,out_1,out_8,out_400,out_1k,out_9600,out_16k,out_10k,out_1M,out_250);
input clk;
output reg out_1;
output reg out_9600;
output reg out_8;
output reg out_400;
output reg out_16k;
output reg out_1k;
output reg out_10k;
output reg out_1M;
output reg out_250;

reg[26:0] cnt1;//24999999
reg[21:0] cnt9600;//2603
reg[11:0] cnt16k;//1491
reg[24:0] cnt8;//3125000
reg[16:0] cnt400;//62500

reg[14:0] cnt1k;//24999
reg[11:0] cnt10k;//2499
reg[4:0] cnt1M;//24
reg[16:0] cnt250;//99999

always @(posedge clk)
begin
	//1hz
	if(cnt1<24999999)  
		cnt1<=cnt1+1; // (50mHz/1Hz)/2-1=1249999
	else  
	begin  
		cnt1<=0; 
		out_1=~out_1;
	end

	//9600hz
	if(cnt9600<2603) 
		cnt9600<=cnt9600+1; //(50mHz/9600Hz)/2-1=2603
	else  
	begin  
		cnt9600<=0; 
		out_9600 =! out_9600; 
	end
	
	//16k
	if(cnt16k<1491) 
		cnt16k<=cnt16k+1; //(50mHz/9600Hz)/2-1=2603
	else  
	begin  
		cnt16k<=0; 
		out_16k =! out_16k; 
	end
	
	//8hz
	if(cnt8<3125000) 
		cnt8<=cnt8+1; //(50mHz/9600Hz)/2-1=2603
	else  
	begin  
		cnt8<=0; 
		out_8 =! out_8; 
	end
	
	//400hz
	if(cnt400<62500)
		cnt400<=cnt400+1;
	else
	begin
		cnt400<=0;
		out_400=~out_400;
	end
	
	//1k
	if(cnt1k<24999)
		cnt1k<=cnt1k+1;
	else
	begin
		cnt1k<=0;
		out_1k=~out_1k;
	end
	
	//10k
	if(cnt10k<2499)
		cnt10k<=cnt10k+1;
	else
	begin
		cnt10k<=0;
		out_10k=~out_10k;
	end
	
	//1M
	if(cnt1M<24)
		cnt1M<=cnt1M+1;
	else
	begin
		cnt1M<=0;
		out_1M=~out_1M;
	end
	
	//250
	if(cnt250<99999)
		cnt250<=cnt250+1;
	else
	begin
		cnt250<=0;
		out_250=~out_250;
	end

end
endmodule
