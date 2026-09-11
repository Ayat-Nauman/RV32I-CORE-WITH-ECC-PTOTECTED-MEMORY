`timescale 1ns / 1ps

module dispatchROM2(
    input [6:0] opcode,
    output [3:0] nxt
    );
    reg [3:0] ROM2 [0:1];
        
    initial begin
        ROM2[0] = 4'b1000; //LW
        ROM2[1] = 4'b1011; //SW
    end
    assign nxt = ROM2[opcode[5]];    
    
endmodule
