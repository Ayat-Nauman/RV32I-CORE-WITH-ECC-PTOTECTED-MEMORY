`timescale 1ns / 1ps
module ecc_encoder(
    input [31:0] data_in,
    output [38:0] codeword
    );

    reg [38:0] ham;
    integer i, j, k, d_idx;
    reg p;

    always @(*) begin
        d_idx = 0;
        for (i = 1; i <= 38; i = i + 1) begin
            if (i!=1 && i!=2 && i!=4 && i!=8 && i!=16 && i!=32) begin
                ham[i] = data_in[d_idx];
                d_idx = d_idx + 1;
            end
        end
        for (j = 0; j < 6; j = j + 1) begin
            p = 0;
            for (k = 1; k <= 38; k = k + 1) begin
                if ((k & (1<<j)) != 0 && k != (1<<j))
                    p = p ^ ham[k];
            end
            ham[(1<<j)] = p;
        end
        ham[0] = ^ham[38:1];
    end

    assign codeword = ham;
endmodule
