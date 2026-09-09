module data_memory (
    input  logic 	           clk,
    input  logic       [7:0]word_index,
    input  logic             mem_write,
    input  logic              mem_read,
    input  logic [38:1] write_codeword,
    output logic   [38:1] read_codeword
);
    (* ramstyle = "block" *) logic [38:1] ram [0:255];

    always_ff @(negedge clk) begin
        if (mem_write) begin
            ram[word_index] <= write_codeword;
        end
        else if (mem_read) begin
            read_codeword <= ram[word_index];
        end
    end

endmodule