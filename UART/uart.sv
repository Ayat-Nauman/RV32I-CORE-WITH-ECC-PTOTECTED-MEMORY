module uart(
input logic clk, 
input logic rst, 	//Asynchronous Active low reset
input logic tx_start,
input logic [7:0] tx_data,
input logic rx,
output logic tx, 
output logic rx_done,
output logic tx_done,
output logic [7:0] rx_data,
output logic error_flag
);

// Transmit data from transmitter to receiver
transmitter dut1(
.clk(clk), 
.rst(rst), 
.tx_start(tx_start),
.tx_data(tx_data),
.tx_done(tx_done), 
.tx(tx)
);

receiver dut2(
.clk(clk), 
.rst(rst), 
.rx_done(rx_done), 
.error_flag(error_flag),
.rx_data(rx_data),
.rx(rx)
);

endmodule




