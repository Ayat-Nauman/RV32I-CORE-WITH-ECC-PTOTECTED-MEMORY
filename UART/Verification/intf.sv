interface uart_intf (input logic clk);
    logic       rst;
    logic       tx_start;
    logic [7:0] tx_data;
    logic       tx_done;
    logic       tx;

    logic       rx;          // wired back to tx below (loopback)
    logic       rx_done;
    logic       error_flag;
    logic [7:0] rx_data;

    assign rx = tx;          // loopback: uart's tx line feeds its own rx input
endinterface
