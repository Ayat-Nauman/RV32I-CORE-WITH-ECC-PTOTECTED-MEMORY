`timescale 1ns/1ps

import ecc_classes::*;

module ecc_top_layered;

    int no_of_inputs = 20;

    ecc_interface intf();

    ecc_memory dut (
        .intf (intf.dut)
    );

    initial begin
        intf.clk = 1'b0;
    end

    always #5 intf.clk = ~intf.clk;

    initial begin
        mailbox gen2drv = new();
        mailbox mon2scb = new();

        generator  gen = new(gen2drv);
        driver     drv = new(gen2drv, intf.driver);
        monitor    mon = new(mon2scb, intf.monitor);
        scoreboard scb = new(mon2scb);

        drv.reset();

        fork
    		gen.main(no_of_inputs);
    		drv.main(no_of_inputs);
    		mon.main(no_of_inputs);
    		scb.main(no_of_inputs);
	join_any

        wait(scb.pass_count + scb.fail_count == no_of_inputs);
        #1;
        scb.display();

        $finish;
    end

endmodule
