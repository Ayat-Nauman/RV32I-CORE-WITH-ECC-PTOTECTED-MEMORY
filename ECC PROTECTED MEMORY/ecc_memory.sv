module ecc_memory (
    input  logic               clk,
    input  logic [31:0]    address,
    input  logic [31:0] write_data,
    input  logic          mem_read,
    input  logic         mem_write,
    output logic [31:0]  read_data
);
    logic [7:0]  word_index;
    logic [38:1] encoded_write_codeword;
    logic [38:1] ram_read_codeword;

    assign word_index = address[9:2];

    ecc_encoder encoder_unit (
        .data_in  (write_data),
        .codeword (encoded_write_codeword)
    );

    data_memory memory_unit (
        .clk            (clk),
        .word_index     (word_index),
        .mem_write      (mem_write),
        .mem_read       (mem_read),
        .write_codeword (encoded_write_codeword),
        .read_codeword  (ram_read_codeword)
    );

    ecc_decoder decoder_unit (
        .codeword_in (ram_read_codeword),
        .data_out    (read_data)
    );

endmodule