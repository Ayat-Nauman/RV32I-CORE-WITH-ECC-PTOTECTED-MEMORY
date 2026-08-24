`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2025 10:45:51 PM
// Design Name: 
// Module Name: reg32b
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


module reg32b(
    input clk,
    input R,
    input WE,
    input [31:0] D,
    output reg [31:0] Q
    );
    
    initial Q = 32'h00000000; // non synthesizable should be removed
       
    always @(posedge clk) begin
        if (R)
            Q <= 32'h0000000;
        else if (WE)
            Q <= D;
    end
endmodule
