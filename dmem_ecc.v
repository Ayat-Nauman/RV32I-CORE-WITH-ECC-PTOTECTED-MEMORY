`timescale 1ns / 1ps
module dmem_ecc(
    input clk,
    input [31:0] Address,
    input [31:0] WriteData,
    input MemRead,
    input MemWrite,
    input fault_en,
    input [1:0] fault_mode,
    input [5:0] fault_bit1,
    input [5:0] fault_bit2,
    input error_clear,
    output reg [31:0] Data,
    output single_bit_error,
    output double_bit_error,
    output sbe_sticky,
    output dbe_sticky,
    output [7:0] sbe_count,
    output [7:0] dbe_count
    );

    reg [38:0] dmem [0:255];
    wire [7:0] word_index = Address[9:2];

    wire [38:0] enc_codeword;
    reg  [38:0] read_codeword;
    wire [38:0] faulty_codeword;
    wire [31:0] dec_data;
    wire dec_sbe, dec_dbe;

    ecc_encoder u_enc (.data_in(WriteData), .codeword(enc_codeword));

    fault_injector u_finj (.codeword_in(read_codeword), .fault_en(fault_en),
                            .fault_mode(fault_mode), .bit_sel1(fault_bit1),
                            .bit_sel2(fault_bit2), .codeword_out(faulty_codeword));

    ecc_decoder u_dec (.codeword_in(faulty_codeword), .data_out(dec_data),
                        .single_bit_error(dec_sbe), .double_bit_error(dec_dbe));

    error_status_reg u_errreg (.clk(clk), .clear(error_clear),
                                .single_bit_error(single_bit_error),
                                .double_bit_error(double_bit_error),
                                .sbe_sticky(sbe_sticky), .dbe_sticky(dbe_sticky),
                                .sbe_count(sbe_count), .dbe_count(dbe_count));

    assign single_bit_error = dec_sbe;
    assign double_bit_error = dec_dbe;

    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1)
            dmem[i] = 39'b0;
        dmem[50] = 39'h00F;
        dmem[51] = 39'h033;
        dmem[52] = 39'h03C;
        dmem[53] = 39'h055;
        dmem[54] = 39'h05A;
        dmem[55] = 39'h066;
        dmem[56] = 39'h069;
        dmem[57] = 39'h096;
        dmem[58] = 39'h099;
        dmem[59] = 39'h0A5;
        dmem[60] = 39'h0AA;
        dmem[61] = 39'h0C3;
        dmem[62] = 39'h0CC;
        dmem[63] = 39'h0F0;
        dmem[64] = 39'h0FF;
        dmem[65] = 39'h303;
    end

    always @(negedge clk) begin
        if (MemWrite) begin
            dmem[word_index] <= enc_codeword;
        end
        else if (MemRead) begin
            read_codeword <= dmem[word_index];
            Data <= dec_data;
        end
    end
endmodule
