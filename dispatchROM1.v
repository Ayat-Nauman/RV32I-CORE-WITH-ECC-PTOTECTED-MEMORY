`timescale 1ns / 1ps

module dispatchROM1(
    input [6:0] opcode,
    output reg [3:0] nxt
    );      
	 
	 always @(*) begin
		case(opcode[6:2]) 
			5'd12: nxt =  4'b0011;
			5'd4: nxt = 4'b0101;  //I-Type
			5'd0: nxt = 4'b0111;  //LW
			5'd8: nxt = 4'b0111;  //SW
			5'd24: nxt = 4'b1100; //B
			5'd13: nxt = 4'b1101; //lui
			5'd25: nxt = 4'b1110; //Jalr
			5'd27: nxt = 4'b1111; //Jal
			5'd5: nxt = 4'b0100; //auipc
			default: nxt = 4'b0000;
		endcase
	 end    
endmodule
