`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 07:05:39 PM
// Design Name: 
// Module Name: ALUcu
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


module ALUcu(
    input [2:0] funct3,
    input [1:0] ALUop,
    input funct7b5,
    output reg [2:0] op
    );
    
    always @(*) begin
        case(ALUop)
            2'b00: op = 3'b011; // lw/sw then add
            2'b01: op = 3'b100; // branch then sub
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if(funct7b5 == 1'b0)
                            op = 3'b011; // add/addi
                        else
                            op = 3'b100; // sub
                    end

                    3'b001: op = 3'b110; //sll / slli
                    3'b010: op = 3'b101; //slt / slti
                    3'b100: op = 3'b010; //xor / xori
                    3'b101: op = 3'b111; //srl / srli
                    3'b110: op = 3'b001; //or / ori
                    3'b111: op = 3'b000; //and / andi
                    default: op = 3'b000; //treating it as don't care 
                endcase
               end
            default: op = 3'b000;
        endcase    
    end
endmodule
