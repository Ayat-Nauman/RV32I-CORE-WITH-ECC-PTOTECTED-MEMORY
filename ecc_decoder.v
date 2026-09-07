`timescale 1ns / 1ps
module ecc_decoder(
    input [38:0] codeword_in,
    output reg [31:0] data_out,
    output reg single_bit_error,
    output reg double_bit_error
    );

    reg [38:0] ham;
    reg [5:0] syndrome;
    reg overall_calc;
    integer i, j, k, d_idx;
    reg p;

    always @(*) begin
        ham = codeword_in;
        syndrome = 6'b0;
        for (j = 0; j < 6; j = j + 1) begin
            p = 0;
            for (k = 1; k <= 38; k = k + 1) begin
                if ((k & (1<<j)) != 0)
                    p = p ^ ham[k];
            end
            syndrome[j] = p;
        end
        overall_calc = ^ham[38:0];

        single_bit_error = 0;
        double_bit_error = 0;

        if (syndrome == 0 && overall_calc == 0) begin
        end
        else if (syndrome != 0 && overall_calc == 1) begin
            single_bit_error = 1;
            if (syndrome <= 38)
                ham[syndrome] = ~ham[syndrome];
        end
        else begin
            double_bit_error = 1;
        end

        d_idx = 0;
        for (i = 1; i <= 38; i = i + 1) begin
            if (i!=1 && i!=2 && i!=4 && i!=8 && i!=16 && i!=32) begin
                data_out[d_idx] = ham[i];
                d_idx = d_idx + 1;
            end
        end
    end
endmodule
