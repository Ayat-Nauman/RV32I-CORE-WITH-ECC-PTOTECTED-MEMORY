class monitor;
    virtual ex_intf vif;
    mailbox mon2scb;
    mailbox mon2cov;

    function new(virtual ex_intf vif, mailbox mon2scb, mailbox mon2cov);
        this.vif = vif;
        this.mon2scb = mon2scb;
        this.mon2cov = mon2cov;
    endfunction

    task run();
        ex_transaction tr;
        forever begin            
            @(posedge vif.clk);
            
            tr = new();
            tr.src1        = vif.src1;
            tr.src2        = vif.src2;
            tr.ALUop       = vif.ALUop;
            tr.funct3      = vif.funct3;
            tr.opcodeb5    = vif.opcodeb5;
            tr.funct7b5    = vif.funct7b5;
            tr.PCWriteCond = vif.PCWriteCond;
            tr.ALUout      = vif.ALUout;
            tr.branch      = vif.branch;
            
            mon2scb.put(tr);
            mon2cov.put(tr);
        end
    endtask
endclass