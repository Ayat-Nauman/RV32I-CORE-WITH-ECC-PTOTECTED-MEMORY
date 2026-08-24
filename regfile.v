`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2025 07:49:49 PM
// Design Name: 
// Module Name: regfile
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
module regfile(
    input clk,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input RegWrite,
    output [31:0] ReadData1,
    output [31:0] ReadData2
    );
    
    reg [31:0] mem[0:31];
    assign ReadData1 = mem[ReadReg1];
    assign ReadData2 = mem[ReadReg2];
    
    //initializing the reg file
    integer i;
    initial begin
        for(i = 0; i < 32; i = i+1)
            mem[i] = 0;
    end
    
    always @(posedge clk) begin    
        if (RegWrite && WriteReg != 0)
            mem[WriteReg] <= WriteData;
    end   
endmodule
