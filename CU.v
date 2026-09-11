`timescale 1ns / 1ps

module CU(
    input [6:0] opcode,
    input clk,
    output IorD,
    output IRwrite,
    output MemRead,
    output MemWrite,
    output ALUsrcA,
    output [1:0] ALUsrcB,
    output [1:0] ALUop,
    output PcWrite,
    output PCWriteCond,
    output [1:0] SrcReg,
    output PCsource,
    output RegWrite,
    output [3:0] next
    ); 
        
    reg [3:0] stateReg = 4'b1111, nextstate;
    reg [16:0] ctrls;
    wire [3:0] rom1_nxt, rom2_nxt;
    assign next = stateReg;    
    
    dispatchROM1 rom1 (.opcode(opcode), .nxt(rom1_nxt));
    dispatchROM2 rom2 (.opcode(opcode), .nxt(rom2_nxt));
 
    always @(*) begin
			
			case(stateReg)
				4'd0: ctrls = 17'h02013; // fetch
				4'd1: ctrls = 17'h00213; // Wait State (all ctrl zeroed)
				4'd2: ctrls = 17'h10121; // decode
				4'd3: ctrls = 17'h0008B; // R-Type Execute
				4'd4: ctrls = 17'h00004; // R-Type/auipc Write Back
				4'd5: ctrls = 17'h000AB; // I-Type Execute
				4'd6: ctrls = 17'h00004; // I-Type Write Back
				4'd7: ctrls = 17'h0002A; // lw/sw Execute (address generation)
				4'd8: ctrls = 17'h06003; // lw Memory Access
				4'd9: ctrls = 17'h00003; // Wait State
				4'd10: ctrls = 17'h00404; // lw Write Back
				4'd11: ctrls = 17'h05000; // sw Memory Access
				4'd12: ctrls = 17'h08148; // Branch Execute
				4'd13: ctrls = 17'h00804; // lui Execute
				4'd14: ctrls = 17'h10C2C; // Jalr Execute
				4'd15: ctrls = 17'h10D04; // Jal Execute	
				default: ctrls = 17'h00000; // unused
		  endcase
        
		  
        case (ctrls[1:0])
            2'b00: nextstate = 4'b0000;
            2'b01: nextstate = rom1_nxt;
            2'b10: nextstate = rom2_nxt;
            2'b11: nextstate = stateReg + 4'b0001;
        endcase
    end
        
    always @(posedge clk) stateReg <= nextstate;
    
    assign IorD = ctrls[14];
    assign IRwrite = ctrls[9];
    assign MemRead = ctrls[13];
    assign MemWrite = ctrls[12];
    assign ALUsrcA = ctrls[3];
    assign ALUsrcB = ctrls[5:4];
    assign ALUop = ctrls[7:6];
    assign PcWrite = ctrls[16];
    assign PCWriteCond = ctrls[15];
    assign SrcReg = ctrls[11:10];
    assign PCsource = ctrls[8];
    assign RegWrite = ctrls[2];
endmodule
