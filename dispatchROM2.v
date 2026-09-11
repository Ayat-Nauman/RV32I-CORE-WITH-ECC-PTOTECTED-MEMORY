`timescale 1ns / 1ps

module dispatchROM2(
    input [6:0] opcode,
    output reg [3:0] nxt
    );
	 
	 always @(*) begin
		case(opcode[5])
			1'b0: nxt = 4'b1000; // LW
			1'b1: nxt = 4'b1011; // SW
			default: nxt = 4'b0000; //unused
		endcase
	 end    
    
endmodule
