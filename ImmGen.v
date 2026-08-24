`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 04:10:57 PM
// Design Name: 
// Module Name: ImmGen
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


module ImmGen(
    input [31:0] inst,
    output [31:0] imm
    );
    reg [31:0] immediate;
    assign imm = immediate;
    
    wire [4:0] opcode;
    assign opcode = inst[6:2];
    
    always @(inst) begin
        case (opcode)
            5'b01000: immediate = { {20{inst[31]}}, inst[31:25], inst[11:7]}; //S - Format
            5'b11000: immediate = { {19{inst[31]}}, inst[31], inst[7], inst[30:25] ,inst[11:8], 1'b0}; //B - Format
            5'b11011: immediate = { {11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0}; //J - Format
            5'b01101, 5'b00101: immediate = {inst[31:12], 12'b0}; // U - Format
            default:  immediate = { {20{inst[31]}}, inst[31:20]}; //I - Format
        endcase
    end
endmodule
