class driver;
    virtual uart_intf vif;
    mailbox gen2drv;
    mailbox drv2scb;

    function new(virtual uart_intf vif, mailbox gen2drv, mailbox drv2scb);
        this.vif     = vif;
        this.gen2drv = gen2drv;
        this.drv2scb = drv2scb;
    endfunction

    task reset();
        vif.rst      <= 0;
        vif.tx_start <= 0;
        vif.tx_data  <= 0;
        repeat (2) @(posedge vif.clk);
        vif.rst <= 1;
        $display("reset done");
    endtask

    task run();
        transaction tr;
        forever begin
            gen2drv.get(tr);

            @(posedge vif.clk);
            vif.tx_data  <= tr.tx_data;
            vif.tx_start <= 1;
            @(posedge vif.clk);
            vif.tx_start <= 0;

            // wait for the transmitter to finish sending this frame
            @(posedge vif.tx_done);
            repeat (5) @(posedge vif.clk); // small guard so receiver settles too

            tr.display("driver");
            drv2scb.put(tr);
        end
    endtask
endclass
