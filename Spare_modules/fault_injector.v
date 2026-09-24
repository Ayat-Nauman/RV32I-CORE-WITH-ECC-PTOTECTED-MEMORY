`timescale 1ns / 1ps
module fault_injector(
    input [38:0] codeword_in,
    input fault_en,
    input [1:0] fault_mode,
    input [5:0] bit_sel1,
    input [5:0] bit_sel2,
    output [38:0] codeword_out
    );

    wire [38:0] mask_single = (39'b1 << bit_sel1);
    wire [38:0] mask_double = (39'b1 << bit_sel1) | (39'b1 << bit_sel2);

    assign codeword_out = (!fault_en) ? codeword_in :
                           (fault_mode == 2'b01) ? (codeword_in ^ mask_single) :
                           (fault_mode == 2'b10) ? (codeword_in ^ mask_double) :
                           codeword_in;
endmodule
