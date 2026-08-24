`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 06:37:58 PM
// Design Name: 
// Module Name: Alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [31:0] src1,
    input [31:0] src2,
    input [2:0] op,    
    output reg [31:0] ALUout,
    output reg zero
    );
       
    always @(src1 or src2 or op) begin
        case (op)
            3'b000: ALUout = src1 & src2;
            3'b001: ALUout = src1 | src2;
            3'b010: ALUout = src1 ^ src2;
            3'b011: ALUout = src1 + src2;
            3'b100: ALUout = src1 - src2;
            3'b101: begin ALUout = src1 - src2; ALUout = {31'b0, ALUout[31]}; end  //slti                            
            3'b110: ALUout = src1 << src2;
            3'b111: ALUout = src1 >> src2;  
        endcase
        zero = (ALUout == 0);
    end
endmodule
