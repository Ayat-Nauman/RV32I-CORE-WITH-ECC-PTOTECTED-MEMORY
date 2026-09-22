class environment;
    generator          gen;
    driver             drv;
    monitor            mon;
    scoreboard         scb;
    coverage_collector cov;

    mailbox gen2drv;
    mailbox mon2scb;
    mailbox mon2cov;

    virtual cu_intf vif;

    function new(virtual cu_intf vif);
        this.vif = vif;
        gen2drv = new();
        mon2scb = new();
        mon2cov = new();
        
        gen = new(gen2drv);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2scb, mon2cov);
        scb = new(mon2scb);
        cov = new(mon2cov);
    endfunction

    task run();
        drv.reset();
        
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
            cov.run(); // ADDED
        join_none
        
        wait(gen.gen_done.triggered);
        wait(gen2drv.num() == 0);
        wait(vif.stateReg == 4'd0);
        
        #50; 
        scb.report();
                        
        $display("\n[COVERAGE] Functional Coverage Score: %0.2f%%", cov.cg_cu_opcodes.get_coverage());        
    endtask
endclass