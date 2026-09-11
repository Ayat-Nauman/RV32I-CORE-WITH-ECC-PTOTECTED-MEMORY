`timescale 1ns / 1ps

module dispatchROM1(
    input [6:0] opcode,
    output [3:0] nxt
    );
    reg [3:0] ROM1 [0:31];
    integer i;
        
    initial begin
        //initializing ROM with zero
        for (i=0; i<32; i = i+1) begin
            ROM1[i] = 4'b0000;
        end      
        
        //writing to desired locations   
        ROM1[12] = 4'b0011; //R-Type
        ROM1[4] = 4'b0101;  //I-Type
        ROM1[0] = 4'b0111;  //LW
        ROM1[8] = 4'b0111;  //SW
        ROM1[24] = 4'b1100; //B
        ROM1[13] = 4'b1101; //lui
        ROM1[25] = 4'b1110; //Jalr
        ROM1[27] = 4'b1111; //Jal
        ROM1[5] = 4'b0100; //auipc
    end

    assign nxt = ROM1[opcode[6:2]];
endmodule
