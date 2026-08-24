`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2025 09:07:52 PM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional C omments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory(
    input clk,
    input [31:0] Address,
    input [31:0] WriteData,
    input MemRead,
    input MemWrite,
    output reg [31:0] Data
    );
    
    (* ramstyle = "block" *) reg [31:0] mem [0:255]; //byte addressable memory	
	 
	 wire [7:0] word_index = Address[9:2];
    
    //initializing the memory
    integer i;
    initial begin
        for(i = 0; i < 256; i = i+1)
            mem[i] = 0;
            
        //writing program instructions
        
        // addi x4, x0, 64  #terminating condition i>=64
        mem[0] = 32'h04000213;                           
       
        // addi x6, x0, 10  #a = 10
        mem[1] = 32'h00A00313;                    
                
        // addi x7, x0, x0 # i = 0        
        mem[2] = 32'h000003B3;              
        
        // addi x5, x0, 200  #base address  = 200        
        mem[3] = 32'h0C800293;      
                        
        // loop: bge x7, x4, exit # i >= 64
        mem[4] = 32'h0043DE63;
        
        // add x9, x5, x7    # address = base addr + i(offset)
        mem[5] = 32'h007284B3;

        // lw x8, 0(x9)    # loading array[i}        
        mem[6] = 32'h0004A403;
        
        // add x8, x8, x6 # array[i] = array[i] + a        
        mem[7] = 32'h00640433;      
        
        // sw x8, 0(x9)   # storing array[i]        
        mem[8] = 32'h0084A023;        
        
        // addi x7, x7, 4  # i = i+4        
        mem[9] = 32'h00438393;        
        
        // jal x0, loop
        mem[10] = 32'hFE9FF06F;
                               
        //exit: add x0, x0, x0 #dummy instructions
        mem[11] = 32'h00000033;
        
        //writing data
        mem[50] = 32'h01;
        mem[51] = 32'h02;
        mem[52] = 32'h03;
        mem[53] = 32'h04;
        mem[54] = 32'h05;
        mem[55] = 32'h06;
        mem[56] = 32'h07;
        mem[57] = 32'h08;
        mem[58] = 32'h09;
        mem[59] = 32'h0A;
        mem[60] = 32'h0B;
        mem[61] = 32'h0C;
        mem[62] = 32'h0D;
        mem[63] = 32'h0E;
        mem[64] = 32'h0F;
        mem[65] = 32'h10;                                            
    end
        
    always @(negedge clk) begin        
        if (MemWrite) begin
                mem[word_index] <= WriteData;
            end
        else if (MemRead)
            Data <= mem[word_index];
    end
endmodule
