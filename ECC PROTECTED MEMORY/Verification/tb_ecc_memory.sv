`timescale 1ns/1ps

module tb_ecc_memory;

    logic        clk;
    logic [31:0] address;
    logic [31:0] write_data;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] read_data;

    ecc_memory uut (
        .clk        (clk),
        .address    (address),
        .write_data (write_data),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .read_data  (read_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        address = '0;
        write_data = '0;
        mem_read = 1'b0;
        mem_write = 1'b0;

        #10;
        address = 32'd0000_0001;
        write_data = 32'd1;
        mem_write = 1'b1;

        #10;
        mem_write = 1'b0;

        #10;
        mem_read = 1'b1;

        #10;
        mem_read = 1'b0;

        #20;
        $stop;
    end

endmodule