`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
    generator  gen;
    driver     drv;
    monitor    mon;
    scoreboard scb;

    mailbox gen2drv;
    mailbox drv2scb;
    mailbox mon2scb;

    virtual reg_intf vif;

    function new(virtual reg_intf vif);
        this.vif = vif;
        gen2drv  = new();
        drv2scb  = new();
        mon2scb  = new();

        gen = new(gen2drv);
        drv = new(vif, gen2drv, drv2scb);
        mon = new(vif, mon2scb);
        scb = new(drv2scb, mon2scb);
    endfunction

    task run();
        drv.reset();
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none

        #3000;
    endtask
endclass
