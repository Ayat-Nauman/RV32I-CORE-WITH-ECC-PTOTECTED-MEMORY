module ecc_encoder (
    input  logic [31:0] data_in,
    output logic [38:1] codeword
);
    logic p1, p2, p4, p8, p16, p32;

    assign p1  = data_in[0]  ^ data_in[1]  ^ data_in[3]  ^ data_in[4]  ^ data_in[6]  ^ data_in[8]  ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[21] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[30];
    assign p2  = data_in[0]  ^ data_in[2]  ^ data_in[3]  ^ data_in[5]  ^ data_in[6]  ^ data_in[9]  ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[21] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[31];
    assign p4  = data_in[1]  ^ data_in[2]  ^ data_in[3]  ^ data_in[7]  ^ data_in[8]  ^ data_in[9]  ^ data_in[10] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[30] ^ data_in[31];
    assign p8  = data_in[4]  ^ data_in[5]  ^ data_in[6]  ^ data_in[7]  ^ data_in[8]  ^ data_in[9]  ^ data_in[10] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25];
    assign p16 = data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25];
    assign p32 = data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[30] ^ data_in[31];

    assign codeword[1]  = p1;
    assign codeword[2]  = p2;
    assign codeword[3]  = data_in[0];
    assign codeword[4]  = p4;
    assign codeword[5]  = data_in[1];
    assign codeword[6]  = data_in[2];
    assign codeword[7]  = data_in[3];
    assign codeword[8]  = p8;
    assign codeword[9]  = data_in[4];
    assign codeword[10] = data_in[5];
    assign codeword[11] = data_in[6];
    assign codeword[12] = data_in[7];
    assign codeword[13] = data_in[8];
    assign codeword[14] = data_in[9];
    assign codeword[15] = data_in[10];
    assign codeword[16] = p16;
    assign codeword[17] = data_in[11];
    assign codeword[18] = data_in[12];
    assign codeword[19] = data_in[13];
    assign codeword[20] = data_in[14];
    assign codeword[21] = data_in[15];
    assign codeword[22] = data_in[16];
    assign codeword[23] = data_in[17];
    assign codeword[24] = data_in[18];
    assign codeword[25] = data_in[19];
    assign codeword[26] = data_in[20];
    assign codeword[27] = data_in[21];
    assign codeword[28] = data_in[22];
    assign codeword[29] = data_in[23];
    assign codeword[30] = data_in[24];
    assign codeword[31] = data_in[25];
    assign codeword[32] = p32;
    assign codeword[33] = data_in[26];
    assign codeword[34] = data_in[27];
    assign codeword[35] = data_in[28];
    assign codeword[36] = data_in[29];
    assign codeword[37] = data_in[30];
    assign codeword[38] = data_in[31];

endmodule