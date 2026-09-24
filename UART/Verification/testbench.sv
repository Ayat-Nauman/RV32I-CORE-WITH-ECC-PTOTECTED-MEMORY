`include "intf.sv"
`include "test.sv"

module top_tb();

    bit clk;

    uart_intf vif(clk);
    test tst(vif);

    uart dut(
        .clk(vif.clk),
        .rst(vif.rst),
        .tx_start(vif.tx_start),
        .tx_data(vif.tx_data),
        .rx(vif.rx),
        .tx(vif.tx),
        .rx_done(vif.rx_done),
        .tx_done(vif.tx_done),
        .rx_data(vif.rx_data),
        .error_flag(vif.error_flag)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);
    end

endmodule
