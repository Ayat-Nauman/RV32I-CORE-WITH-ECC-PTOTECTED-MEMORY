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
        ROM1[12] = 4'b0010; //R-Type
        ROM1[4] = 4'b0100;  //I-Type
        ROM1[0] = 4'b0110;  //LW
        ROM1[8] = 4'b0110;  //SW
        ROM1[24] = 4'b1010; //B
        ROM1[13] = 4'b1011; //lui
        ROM1[25] = 4'b1100; //Jalr
        ROM1[27] = 4'b1101; //Jal
        ROM1[5] = 4'b0011; //auipc
    end

    assign nxt = ROM1[opcode[6:2]];
endmodule
