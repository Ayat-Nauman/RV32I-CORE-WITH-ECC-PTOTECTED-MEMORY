module memoryv2(
    input clk,
    input [31:0] Address,
    input [31:0] WriteData,
    input MemRead,
    input MemWrite,
    output [31:0] Data
    );        
	 
	 wire [7:0] word_index = Address[9:2];
	 wire chip_sel;
	 wire we;
	 
	 assign chip_sel = ~ (MemRead | MemWrite); //only active (low) if we are reading or writing
	 assign we = ~MemWrite; //only active (low) when we are writing
	 
	 ram_256x16A macro_low (.CLK(clk), .CEN(chip_sel), .WEN(we), .A(word_index), .D(WriteData[15:0]), .Q(Data[15:0]));
    ram_256x16A macro_high (.CLK(clk), .CEN(chip_sel), .WEN(we), .A(word_index), .D(WriteData[31:16]), .Q(Data[31:16]));

	 
endmodule
