`timescale 1ns / 1ps
module error_status_reg(
    input clk,
    input clear,
    input single_bit_error,
    input double_bit_error,
    output reg sbe_sticky,
    output reg dbe_sticky,
    output reg [7:0] sbe_count,
    output reg [7:0] dbe_count
    );

    always @(posedge clk) begin
        if (clear) begin
            sbe_sticky <= 0;
            dbe_sticky <= 0;
            sbe_count  <= 0;
            dbe_count  <= 0;
        end
        else begin
            if (single_bit_error) begin
                sbe_sticky <= 1;
                sbe_count  <= sbe_count + 1;
            end
            if (double_bit_error) begin
                dbe_sticky <= 1;
                dbe_count  <= dbe_count + 1;
            end
        end
    end
endmodule
