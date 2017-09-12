module main
(
	input clk_1,
	input clk_50M,
	input clk_8,
	input receive,//Zigbee
	input [7:0] receiveData,
	input [7:0] button,
	input [7:0] forwardDistance,//超声波前方
	input [3:0] touch,//触碰
	input [3:0] infrared,//红外
	input [3:0] signs,//摄像头
	output reg [7:0] speed,
	output reg [8:0] degree,
	output reg direction,
	output reg beepEnable,
	output reg [13:0] display,
	output reg [7:0] led,
	input [7:0] backDistance,//后方超声波
	input [13:0] inspeed,//测量得到的速度
	input [3:0] downinfrared,//循迹红外
	output reg [23:0] light,//WS2812
	output reg [2:0] lcd_state
);

reg [7:0] command;
reg stop;
reg [5:0] target;//1hz to count;
reg [5:0] target2;//8hz to count;
reg [5:0] cnt;//for clock to count;
reg [5:0] cnt2;//for clock2 to count;
reg Delaying;
reg last;//=Delaying
reg Delaying2;
reg last2;//=Delaying2
reg [1:0] backStatus;//0 正在倒, 1前进, 2继续倒车，3是一开始
reg backdone;
reg [30:0] DelayCnt;//
reg [7:0]initialSpeed;
reg lastsign3;//=sign[3]
reg lastsign2;//=sign[2]
reg [1:0] state;//控制模式
reg [1:0] mystate;//自己的状态
reg resetState;
reg isSet;

initial begin
	speed=28;
	degree=95;
	direction=1;
	display=0;
	led=0;
	beepEnable=0;
	target=0;
	target2=0;
	cnt=0;
	Delaying=0;
	Delaying2=0;
	backStatus=2'b11;
	lastsign3=1;
	lastsign2=1;
	/*color*/
	/*
	5*256*256+167*256+82 紫色
	60*256 红色
	64*256*256+255*256; 橙色
	60*256*256 绿
	60 蓝色
	80*256*256+80 海蓝色
	*/
	light=80*256*256+80;//green*256^2+red*256+blue
	state=3;
	mystate=3;
	initialSpeed=15;
	backdone=0;
	DelayCnt=0;
	isSet=0;
	lcd_state=3'b111;
end

always @ (posedge clk_50M) begin


	//display=inspeed;
	//speed=button;
	led[6:5]=state;
	if(state==0) begin// 完全控制(红色)
		lcd_state=3'b100;
		display=forwardDistance;
		beepEnable=0;
		light=60*256;//红色
		case(command[1:0])//speed
			2'b00: speed=0;
			2'b10: speed=30;
			2'b01: speed=15;
			2'b11: speed=0;
		endcase
		case (command[3:2])//degree
			2'b00: degree=95;
			2'b11: degree=95;
			2'b01: degree=60;
			2'b10: degree=120;
		endcase
		case(command[4])//direction
			1'b0: direction=1;
			1'b1: direction=0;
		endcase
	end
	else if(state==1) begin
		initialSpeed=command[5:0];
		isSet=1;
		resetState=1;
		//beepEnable=1;
	end
	else if(state==2) begin
		mystate=receiveData[1:0];
		resetState=1;
	end

	else begin//自己玩
		led[4:3]=mystate;
		resetState=0;
		if(DelayCnt<20000000) begin
			DelayCnt=DelayCnt+1;
			speed=0;
			degree=95;
			light=60*256;
		end
		else begin
		//mystate 00 走黑线 01 靠墙走 10 自动泊车 11 瞎走
		if(!isSet) begin
			initialSpeed=button;
			display=initialSpeed;
		end
		else 
			display=initialSpeed;
		
		if(signs[3]==1 && lastsign3==0 && !backdone) begin//posedge signs[3] -> start parking
			mystate=2'b10;
			backStatus=0;
			backdone=0;
			speed=0;
			degree=95;
		end
		
		else if(signs[2]==1 && lastsign2==0) begin//posedge signs[2] -> start tracking
			mystate=2'b00;
		end		
		else if(mystate==2'b00) begin//走黑线(蓝色)
			lcd_state=3'b010;
			light=80;//blue
			led[1:0]=downinfrared[2:1];
			speed=initialSpeed;
			direction=1;
			if(!downinfrared[2] && !downinfrared[1]) begin//两个都在黑线外，直走
				degree=95;
				//led[7:2]=6'b000000;
			end
			else if(downinfrared[2] && !downinfrared[1]) begin//
				degree=60;
				//led[7:2]=6'b000000;
			end
			else if(!downinfrared[2] && downinfrared[1]) begin
				degree=120;
				//led[7:2]=6'b000000;
			end
			else begin//两个都没看到
				speed=0;
				degree=95;
				//led[7:2]=6'b111111;
			end
		end
		else if(mystate==2'b10) begin//自动泊车(紫色)
			light=5*256*256+167*256+82;
			led[1:0]=backStatus;
			if(backStatus==0 && backDistance<35)
				backStatus=1;
			else if(backStatus==1 && Delaying2!=last2 && last2==1) begin
				backStatus=2;
				target2=0;
			end
			else if(backStatus==2 && backDistance<9 && direction==0) begin
				backStatus=3;
				backdone=1;
				beepEnable=0;
				direction=1;
				speed=5;
				//mystate=3;
			end
			else begin
				if(backStatus==0) begin
					direction=0;
					degree=120;
					speed=initialSpeed+8;
					beepEnable=1;
				end
				else if(backStatus==1) begin
					degree=60;
					speed=initialSpeed+5;
					direction=1;
					target2=11;
					beepEnable=0;
				end
				else if(backStatus==2) begin
					beepEnable=1;
					direction=0;
					if(backDistance<30) begin
						if(!infrared[3]) begin
							degree=110;
							speed=initialSpeed+5;
						end
						else if(!infrared[2])begin
							degree=80;
							speed=initialSpeed+5;
						end
						else begin
							degree=95;
							speed=initialSpeed+5;
						end
					end
					else begin//直行倒车
						speed=initialSpeed+5;
						degree=95;
					end
				end
				else begin//backStatus==3
					speed=0;
					degree=95;
					led[7]=1;
				end
			end
			last=Delaying;
			last2=Delaying2;
		end
		else if(mystate==2'b01) begin//靠墙走?(绿色)
			light=60*256*256;//绿色
			lcd_state=3'b001;
			led[1:0]=touch[1:0];
			if(target2) begin
				light=60*256;
				if(last2!=Delaying2 && Delaying2==0) begin//negedge 
					target2=0;
					beepEnable=0;
				end
				else
					beepEnable=1;
			end
			else if(forwardDistance>20) begin
				speed=initialSpeed;
				case(touch[1:0])
				2'b00: begin
					direction=0;
					degree=98;
				end
				2'b01: begin
					degree=60;
					direction=1;
				end
				2'b10: begin
					degree=120;
					direction=1;
				end
				2'b11: begin
					degree=98;
					direction=1;
				end
				endcase
			end
			else begin
				direction=0;
				speed=initialSpeed+10;
				target2=10;
				if(infrared[2])
					degree=60;
				else if(infrared[3])
					degree=120;
				else 
					degree=98;
			end
			last2=Delaying2;
		end
		else begin //瞎走(黄色)
			lcd_state=3'b111;
			light=80*256+80*256*256;//黄色
			speed=initialSpeed;
			degree=95;
			backdone=0;
		end
		lastsign3=signs[3];
		lastsign2=signs[2];
		end
	end
end


/*
receiveData;
模式1:(完全控制)
1:0 00,11 停, 10高速, 01低速
3:2 00,11向直行, 01右转, 10左转
4 0 正转, 1反转
7:5 001

模式2:(调速模式)
5:0 速度
7:6 01

模式3: (功能模式)
1:0 走黑线00, 靠墙走01, 自动停车10, 11没听懂
7:2 101010

模式4: (自己去玩吧)
7:5 110x
*/ 

always @(posedge receive or posedge resetState) begin
	if(resetState==1) begin
		state=3;
	end
	else if(receiveData[7:5]==3'b001) begin
		command=receiveData;
		state=0;
	end
	else if(receiveData[7:6]==2'b01) begin
		command=receiveData;
		state=1;
	end
	else if(receiveData[7:2]==6'b101010) begin
		command=receiveData;
		state=2;
	end
	else if(receiveData[7:5]==3'b110) begin
		command=receiveData;
		state=3;
	end
	else
		;
end

//延时模块
always@(posedge clk_1) begin
	if(cnt>=target) begin
		Delaying=0;
		cnt=0;
	end
	else begin
		cnt=cnt+1;
		Delaying=1;
	end
end

//延时模块2
always@(posedge clk_8) begin
	if(cnt2>=target2) begin
		Delaying2=0;
		cnt2=0;
	end
	else begin
		cnt2=cnt2+1;
		Delaying2=1;
	end
end


//舵机测试
/*always @ (posedge clk_1) begin
	
	if(degree>=180)
		degree=0;
	else
		degree=degree+20;
end*/

//红外测试
/*if(!infrared[1]) begin
	speed=0;
	degree=90;
end
else begin
	if(!infrared[0])//left，有东西是0
		degree=60;
	else
		degree=120;
		
	if(button>=60)
		speed=60;
	else
		speed=button;
end*/


endmodule
