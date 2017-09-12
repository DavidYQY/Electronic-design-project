module lcd(
        clk_LCD,
		  inputstate,
		  rst,
        en,
        RS,
        RW,
        data
);
input clk_LCD;//250Hz
input [2:0] inputstate;
input rst;     
output   en,RS,RW;
output   reg  [7:0]  data;
reg      RS,en_sel;
reg      [4:0]    disp_count;
reg      [3:0]   state;
parameter   clear_lcd=4'b0000,//清屏并光标复位
            set_disp_mode=4'b0001,//设置显示模式：8位2行5x7点阵   
            disp_on=4'b0010,//显示器开、光标不显示、光标不允许闪烁
            shift_down=4'b0011,//文字不动，光标自动右移 
            write_data_first=4'b0101,//写入第一行显示的数据
            write_data_second=4'b0110,//写入第二行显示的数据
            idel=4'b0111;//空闲状态   
assign  RW = 1'b0;//RW=0时对LCD模块执行写操作
assign  en = en_sel ? clk_LCD : 1'b0;

reg [7:0]     data_first_line  [15:0];  //第一行数据
reg [7:0]     data_second_line [15:0];  //第二行数据

/*****************LSS改的部分**********************/
reg[2:0] RGY;//当前红绿灯
reg[2:0] RGYmid;//延时中间变量
reg[2:0] RGYbefore;//延时前一时钟变量
reg RGYrst;
always//实时更新当前信号
begin
RGY=inputstate;
end
always@(posedge clk_LCD)//延时
begin
//延时赋值
RGYmid<=RGY;
RGYbefore<=RGYmid;
end
always//“同或”对比等变了没？变了（或rst变0）RGYrst变量就变0，否则是1，下边的rst变成RGYrst
begin
RGYrst=(RGYbefore[0]^~RGY[0])&(RGYbefore[1]^~RGY[1])&(RGYbefore[2]^~RGY[2])&rst;
end
/***********************************************/

always @(negedge clk_LCD )
begin
if(inputstate==3'b001)
begin// Light is my strength
   data_first_line[0] <= 8'h20;
   data_first_line[1] <= 8'h20;
   data_first_line[2] <= 8'h20;
   data_first_line[3] <= 8'h20;
   data_first_line[4] <= 8'b01001100;//L
   data_first_line[5] <= 8'b01101001;//i
   data_first_line[6] <= 8'b01100111;//g
   data_first_line[7] <= 8'b01101000;//h
   data_first_line[8] <= 8'b01110100;//t
   data_first_line[9] <= 8'h20;
   data_first_line[10] <= 8'b01101001;//i
   data_first_line[11] <= 8'b01110011;//s
   data_first_line[12] <= 8'h20;
   data_first_line[13] <= 8'h20;
	data_first_line[14] <= 8'h20;
   data_first_line[15] <= 8'h20;
	
	data_second_line[0] <= 8'h20;
   data_second_line[1] <= 8'h20;
   data_second_line[2] <= 8'b01101101;//m
   data_second_line[3] <= 8'b01111001;//y
   data_second_line[4] <= 8'h20;
   data_second_line[5] <= 8'b01110011;//s
   data_second_line[6] <= 8'b01110100;//t
   data_second_line[7] <= 8'b01110010;//r
   data_second_line[8] <= 8'b01100101;//e
   data_second_line[9] <= 8'b01101110;//n
   data_second_line[10] <= 8'b01100111;//g
   data_second_line[11] <= 8'b01110100;//t
   data_second_line[12] <= 8'b01101000;//h
   data_second_line[13] <= 8'h20;
   data_second_line[14] <= 8'h20;
   data_second_line[15] <= 8'h20;
end
else if(inputstate==3'b010)
begin//day walker ,night stalker
   data_first_line[0] <= 8'h20;
   data_first_line[1] <= 8'h20;
   data_first_line[2] <= 8'h20;
   data_first_line[3] <= 8'b01100100;//d
   data_first_line[4] <= 8'b01100001;//a
	data_first_line[5] <= 8'b01111001;//y
   data_first_line[6] <= 8'h20;
   data_first_line[7] <= 8'b01110111;//w
   data_first_line[8] <= 8'b01100001;//a
   data_first_line[9] <= 8'b01101100;//l
   data_first_line[10] <= 8'b01101011;//k
   data_first_line[11] <= 8'b01100101;//e
   data_first_line[12] <= 8'b01110010;//r
   data_first_line[13] <= 8'h20;
   data_first_line[14] <= 8'h20;
	data_first_line[15] <= 8'h20;
	
	data_second_line[0] <= 8'h20;
   data_second_line[1] <= 8'h20;
   data_second_line[2] <= 8'b01101110;//n
   data_second_line[3] <= 8'b01101001;//i
   data_second_line[4] <= 8'b01100111;//g
   data_second_line[5] <= 8'b01101000;//h
   data_second_line[6] <= 8'b01110100;//t
   data_second_line[7] <= 8'h20;
   data_second_line[8] <= 8'b01110011;//s
	
   data_second_line[9] <= 8'b01110100;//t
   data_second_line[10] <= 8'b01100001;//a
   data_second_line[11] <= 8'b01101100;//l
   data_second_line[12] <= 8'b01101011;//k
   data_second_line[13] <= 8'b01100101;//e
   data_second_line[14] <= 8'b01110010;//r
   data_second_line[15] <= 8'h20;
end
else if(inputstate==3'b100) begin//controlled
   data_first_line[0] <= 8'h20;
   data_first_line[1] <= 8'h20;
   data_first_line[2] <= 8'h20;
   data_first_line[3] <= 8'b01100011;//c
   data_first_line[4] <= 8'b01101111;//o
	data_first_line[5] <= 8'b01101110;//n
	data_first_line[6] <= 8'b01110100;//t
   data_first_line[7] <= 8'b01110010;//r
   data_first_line[8] <= 8'b01101111;//o
   data_first_line[9] <= 8'b01101100;//l
   data_first_line[10] <= 8'b01101100;//l
   data_first_line[11] <= 8'b01100101;//e
   data_first_line[12] <= 8'b01100100;//d
   data_first_line[13] <= 8'h20;
   data_first_line[14] <= 8'h20;
   data_first_line[15] <= 8'h20;
	
	data_second_line[0] <= 8'b00100001;
   data_second_line[1] <= 8'b00100001;
   data_second_line[2] <= 8'b00100001;
   data_second_line[3] <= 8'b00100001;
   data_second_line[4] <=8'b00100001;
   data_second_line[5] <= 8'b00100001;
   data_second_line[6] <= 8'b00100001;
   data_second_line[7] <= 8'b00100001;
   data_second_line[8] <= 8'b00100001;//!
   data_second_line[9] <= 8'b00100001;
   data_second_line[10] <= 8'b00100001;
   data_second_line[11] <= 8'b00100001;
   data_second_line[12] <= 8'b00100001;
   data_second_line[13] <= 8'b00100001;
   data_second_line[14] <= 8'b00100001;
   data_second_line[15] <= 8'b00100001;
end

else begin
	data_first_line[0]=8'h20;
	data_first_line[1]=8'h20;
	data_first_line[2]=8'h20;
	data_first_line[3]=8'h20;
	data_first_line[4]=8'h20;
	data_first_line[5]=8'h20;
	data_first_line[6]=8'h20;
	data_first_line[7]=8'h20;
	data_first_line[8]=8'h20;
	data_first_line[9]=8'h20;
	data_first_line[10]=8'h20;
	data_first_line[11]=8'h20;
	data_first_line[12]=8'h20;
	data_first_line[13]=8'h20;
	data_first_line[14]=8'h20;
	data_first_line[15]=8'h20;
	
	data_second_line[0] <= 8'h20;
   data_second_line[1] <= 8'h20;
   data_second_line[2] <= 8'h20;
   data_second_line[3] <= 8'h20;
   data_second_line[4] <= 8'h20;
   data_second_line[5] <= 8'h20;
   data_second_line[6] <= 8'h20;
   data_second_line[7] <= 8'h20;
   data_second_line[8] <= 8'h20;//!
   data_second_line[9] <= 8'h20;
   data_second_line[10] <= 8'h20;
   data_second_line[11] <= 8'h20;
   data_second_line[12] <= 8'h20;
   data_second_line[13] <= 8'h20;
   data_second_line[14] <= 8'h20;
   data_second_line[15] <= 8'h20;
end
end

always @(posedge clk_LCD or negedge RGYrst)
begin
   if(!RGYrst)
      begin
          state<= clear_lcd;//复位：清屏并光标复位  
          RS<=1'b0;//复位：RS=0时为写指令；                      
          data<=8'b0;//复位：使DB8总线输出全0
          en_sel<=1'b1;//复位：开启夜晶使能信号
          disp_count<=5'b0;
      end
   else
      case(state)
      clear_lcd://初始化LCD模块
             begin//清屏并光标复位
                state  <= set_disp_mode;
                data  <= 8'h01;               
             end
      set_disp_mode://设置显示模式：8位2行5x8点阵 
             begin
                state<= disp_on;
                data<= 8'h38;                              
             end
      disp_on://显示器开、光标不显示、光标不允许闪烁
             begin
                state<= shift_down;
                data<= 8'h0c;                           
             end
      shift_down:        //文字不动，光标自动右移 
            begin
                state<= write_data_first;
                data<= 8'h06;                         
            end
      write_data_first:              //显示第一行                         
            begin
                if(disp_count == 16)                      
                    begin
                        data    <= 8'hc2;               
                        RS     <= 1'b0;
                        disp_count   <= 4'b0;
                        state    <= write_data_second;        
                    end
                else
                    begin
                        data    <= data_first_line[disp_count];
                        RS     <= 1'b1;                  
                        disp_count   <= disp_count + 1'b1;
                        state    <= write_data_first;
                    end
            end
      write_data_second:                      //显示第二行
            begin
                if(disp_count == 16)
                    begin
                        en_sel   <= 1'b0;
                        RS    <= 1'b0;
                        disp_count  <= 4'b0;
                        state   <= idel;                     
                    end
                else
                    begin
                        data    <= data_second_line[disp_count+1];
                        RS     <= 1'b1;
                        disp_count   <= disp_count + 1'b1;
                        state    <= write_data_second;
                    end             
            end
      idel:            //写完进入空闲状态
            begin
                state <=  idel;             //在Idel状态循环 
            end
      default:  state <= clear_lcd;         //若state为其他值，则将state置为Clear_Lcd
      endcase
end
endmodule
