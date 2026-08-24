`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2025 09:43:41 PM
// Design Name: 
// Module Name: funct3Setter
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


module funct3Setter(
    input [2:0] funct3,
    input PCWriteCond,
    output reg [2:0] Setfunct3
    );
    
    always @(funct3) begin
        if(PCWriteCond)         //if it is a branch (PCWriteCond = 1) then funct3 = 0, as operation will be done by ALUop = 01 
            Setfunct3 = 3'b000;
        else                    //else leave funct3 as it is
            Setfunct3 = funct3;
    end
endmodule
