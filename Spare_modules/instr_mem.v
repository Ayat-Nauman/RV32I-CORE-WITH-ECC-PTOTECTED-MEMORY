`timescale 1ns / 1ps
module instr_mem(
    input clk,
    input [31:0] Address,
    input MemRead,
    output reg [31:0] Instr
    );

    reg [31:0] imem [0:15];
    wire [3:0] word_index = Address[5:2];

    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            imem[i] = 0;
        imem[0]  = 32'h04000213;
        imem[1]  = 32'h00A00313;
        imem[2]  = 32'h000003B3;
        imem[3]  = 32'h0C800293;
        imem[4]  = 32'h0043DE63;
        imem[5]  = 32'h007284B3;
        imem[6]  = 32'h0004A403;
        imem[7]  = 32'h00640433;
        imem[8]  = 32'h0084A023;
        imem[9]  = 32'h00438393;
        imem[10] = 32'hFE9FF06F;
        imem[11] = 32'h00000033;
    end

    always @(negedge clk) begin
        if (MemRead)
            Instr <= imem[word_index];
    end
endmodule
