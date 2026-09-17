interface ecc_interface;

logic               clk;
logic [31:0]    address;
logic [31:0] write_data;
logic          mem_read;
logic         mem_write;
logic [31:0]  read_data;


modport dut(
input clk, address, write_data, mem_read, mem_write,
output read_data
);

modport driver(
output clk, address, write_data, mem_read, mem_write
);

modport monitor(
input clk, address, write_data, mem_read, mem_write,read_data
);


endinterface
