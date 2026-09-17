`timescale 1ns/1ps

import ecc_classes::*;

module ecc_top_layered;

    mailbox gen2drv;
    mailbox mon2scb;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    int no_of_inputs = 20;

    ecc_interface intf();
    
    ecc_memory dut (
        .clk        (intf.clk),
        .address    (intf.address),
        .write_data (intf.write_data),
        .mem_read   (intf.mem_read),
        .mem_write  (intf.mem_write),
        .read_data  (intf.read_data)
    );
    initial begin
        intf.clk = 1'b0;
    end

    always #5 intf.clk = ~intf.clk;

    initial begin
        gen2drv = new();
        mon2scb = new();

        gen = new(gen2drv);
        drv = new(gen2drv, intf.driver);
        mon = new(mon2scb, intf.monitor);
        scb = new(mon2scb);

        drv.reset();

        fork
            gen.main(no_of_inputs);
            drv.main(no_of_inputs);
            mon.main(no_of_inputs);
            scb.main(no_of_inputs);
        join    // Waits for all tasks inside the fork to complete

        #1;
        scb.display();

        $finish;
    end

endmodule
