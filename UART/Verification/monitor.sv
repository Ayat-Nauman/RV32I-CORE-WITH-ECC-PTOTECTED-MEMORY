class monitor;
    virtual uart_intf vif;
    mailbox mon2scb;

    function new(virtual uart_intf vif, mailbox mon2scb);
        this.vif     = vif;
        this.mon2scb = mon2scb;
    endfunction

    task run();
        transaction tr;
        forever begin
            @(posedge vif.rx_done);
            tr = new();
            tr.rx_data    = vif.rx_data;
            tr.error_flag = vif.error_flag;
            tr.display("monitor");
            mon2scb.put(tr);
        end
    endtask
endclass
