module memory (
    input  logic clk,
    input  logic [7:0] word_index,
    input  logic MemRead,
    input  logic MemWrite,
    input  logic [38:1] WriteData,
    output logic   [38:1] Data
);     	 	
	 wire chip_sel;
	 wire we;
	 
	 assign chip_sel = ~ (MemRead | MemWrite); //only active (low) if we are reading or writing
	 assign we = ~MemWrite; //only active (low) when we are writing
	 
	 ram_256x16A macro_low (.CLK(clk), .CEN(chip_sel), .WEN(we), .A(word_index), .D(WriteData[16:1]), .Q(Data[16:1]));
    ram_256x16A macro_middle (.CLK(clk), .CEN(chip_sel), .WEN(we), .A(word_index), .D(WriteData[32:17]), .Q(Data[32:17]));
	 ram_256x16A macro_high (.CLK(clk), .CEN(chip_sel), .WEN(we), .A(word_index), .D(WriteData[38:33]), .Q(Data[38:33]));

endmodule