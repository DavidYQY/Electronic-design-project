module Digital(clk_16k, A, OL, DIG);
	input clk_16k;
	input [13:0] A;
	output reg [6:0] OL;
	output reg [3:0] DIG;
	reg [1:0] col;
	reg [3:0] out;
	always@ (posedge clk_16k) begin
		col=col+1;
		case(col)
			0: begin out=A/1000;DIG=4'b1000; end
			1: begin out=(A/100)%10; DIG=4'b0100; end
			2: begin out=(A/10)%10; DIG=4'b0010; end
			3: begin out=A%10; DIG=4'b0001; end
		endcase
		case(out)
			0: OL=7'b1111110;
			1: OL=7'b0110000;
			2: OL=7'b1101101;
			3: OL=7'b1111001;
			4: OL=7'b0110011;
			5: OL=7'b1011011;
			6: OL=7'b1011111;
			7: OL=7'b1110000;
			8: OL=7'b1111111;
			9: OL=7'b1111011;
			default: OL=7'b0000000;
		endcase
	end
endmodule