class monitor;
    virtual reg_intf vif;
    mailbox mon2scb;

    function new(virtual reg_intf vif, mailbox mon2scb);
        this.vif     = vif;
        this.mon2scb = mon2scb;
    endfunction

    task run();
        transaction tr;
        forever begin
            @(posedge vif.clk);
            #1; // let combinational reads / NBA updates settle after this edge
            tr = new();
            tr.r32_Q       = vif.r32_Q;
            tr.rf_ReadData1 = vif.rf_ReadData1;
            tr.rf_ReadData2 = vif.rf_ReadData2;
            tr.display("monitor");
            mon2scb.put(tr);
        end
    endtask
endclass
