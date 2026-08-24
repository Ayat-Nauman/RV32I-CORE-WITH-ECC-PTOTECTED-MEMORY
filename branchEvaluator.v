`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2025 09:48:05 PM
// Design Name: 
// Module Name: branchEvaluator
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


module branchEvaluator(
    input PCWriteCond,
    input [2:0] funct3,
    input [31:0] x,
    input z,
    output reg branch
    );
    
    always @(*) begin
        if(PCWriteCond) begin
            case (funct3)
                3'b000: branch = z;  // a == b
                3'b001: branch = ~z; // a != b
                3'b100: branch = x[31] == 1'b1; //sign(a - b) = 1 (-ve)
                3'b101: branch = x[31] == 1'b0; //sign(a - b) = 0 (+ve)
                default: branch = 1'b0;
            endcase        
        end
        else
            branch = 1'b0;
    end
endmodule
