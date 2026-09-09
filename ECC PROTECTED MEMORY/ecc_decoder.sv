module ecc_decoder (
    input  logic [38:1] codeword_in,
    output logic [31:0] data_out
);
    logic [5:0] syndrome;
    logic  [38:1] corrected_codeword;

    assign syndrome[0] = codeword_in[1]  ^ codeword_in[3]  ^ codeword_in[5]  ^ codeword_in[7]  ^ codeword_in[9]  ^ codeword_in[11] ^ codeword_in[13] ^ codeword_in[15] ^ codeword_in[17] ^ codeword_in[19] ^ codeword_in[21] ^ codeword_in[23] ^ codeword_in[25] ^ codeword_in[27] ^ codeword_in[29] ^ codeword_in[31] ^ codeword_in[33] ^ codeword_in[35] ^ codeword_in[37];
    assign syndrome[1] = codeword_in[2]  ^ codeword_in[3]  ^ codeword_in[6]  ^ codeword_in[7]  ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[30] ^ codeword_in[31] ^ codeword_in[34] ^ codeword_in[35] ^ codeword_in[38];
    assign syndrome[2] = codeword_in[4]  ^ codeword_in[5]  ^ codeword_in[6]  ^ codeword_in[7]  ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[20] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30] ^ codeword_in[31] ^ codeword_in[36] ^ codeword_in[37] ^ codeword_in[38];
    assign syndrome[3] = codeword_in[8]  ^ codeword_in[9]  ^ codeword_in[10] ^ codeword_in[11] ^ codeword_in[12] ^ codeword_in[13] ^ codeword_in[14] ^ codeword_in[15] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30] ^ codeword_in[31];
    assign syndrome[4] = codeword_in[16] ^ codeword_in[17] ^ codeword_in[18] ^ codeword_in[19] ^ codeword_in[20] ^ codeword_in[21] ^ codeword_in[22] ^ codeword_in[23] ^ codeword_in[24] ^ codeword_in[25] ^ codeword_in[26] ^ codeword_in[27] ^ codeword_in[28] ^ codeword_in[29] ^ codeword_in[30] ^ codeword_in[31];
    assign syndrome[5] = codeword_in[32] ^ codeword_in[33] ^ codeword_in[34] ^ codeword_in[35] ^ codeword_in[36] ^ codeword_in[37] ^ codeword_in[38];

    always_comb begin
        corrected_codeword = codeword_in;
        if (syndrome != 6'b000000 && syndrome <= 6'd38) begin
            corrected_codeword[syndrome] = ~codeword_in[syndrome];
        end
    end

    assign data_out[0]  = corrected_codeword[3];
    assign data_out[1]  = corrected_codeword[5];
    assign data_out[2]  = corrected_codeword[6];
    assign data_out[3]  = corrected_codeword[7];
    assign data_out[4]  = corrected_codeword[9];
    assign data_out[5]  = corrected_codeword[10];
    assign data_out[6]  = corrected_codeword[11];
    assign data_out[7]  = corrected_codeword[12];
    assign data_out[8]  = corrected_codeword[13];
    assign data_out[9]  = corrected_codeword[14];
    assign data_out[10] = corrected_codeword[15];
    assign data_out[11] = corrected_codeword[17];
    assign data_out[12] = corrected_codeword[18];
    assign data_out[13] = corrected_codeword[19];
    assign data_out[14] = corrected_codeword[20];
    assign data_out[15] = corrected_codeword[21];
    assign data_out[16] = corrected_codeword[22];
    assign data_out[17] = corrected_codeword[23];
    assign data_out[18] = corrected_codeword[24];
    assign data_out[19] = corrected_codeword[25];
    assign data_out[20] = corrected_codeword[26];
    assign data_out[21] = corrected_codeword[27];
    assign data_out[22] = corrected_codeword[28];
    assign data_out[23] = corrected_codeword[29];
    assign data_out[24] = corrected_codeword[30];
    assign data_out[25] = corrected_codeword[31];
    assign data_out[26] = corrected_codeword[33];
    assign data_out[27] = corrected_codeword[34];
    assign data_out[28] = corrected_codeword[35];
    assign data_out[29] = corrected_codeword[36];
    assign data_out[30] = corrected_codeword[37];
    assign data_out[31] = corrected_codeword[38];

endmodule