class monitor;
    virtual cu_intf vif;
    mailbox mon2scb;
    mailbox mon2cov; // ADDED

    function new(virtual cu_intf vif, mailbox mon2scb, mailbox mon2cov);
        this.vif = vif;
        this.mon2scb = mon2scb;
        this.mon2cov = mon2cov;
    endfunction

    task run();
        cu_transaction tr;
        forever begin
            @(posedge vif.clk);
            #1; // Wait 1ns for combinational outputs to settle
            
            tr = new();
            tr.opcode      = vif.opcode;
            tr.state       = vif.stateReg;
            tr.IorD        = vif.IorD;
            tr.IRwrite     = vif.IRwrite;
            tr.MemRead     = vif.MemRead;
            tr.MemWrite    = vif.MemWrite;
            tr.ALUsrcA     = vif.ALUsrcA;
            tr.PcWrite     = vif.PcWrite;
            tr.PCWriteCond = vif.PCWriteCond;
            tr.PCsource    = vif.PCsource;
            tr.RegWrite    = vif.RegWrite;
            tr.ALUsrcB     = vif.ALUsrcB;
            tr.ALUop       = vif.ALUop;
            tr.SrcReg      = vif.SrcReg;

            mon2scb.put(tr);
            mon2cov.put(tr);
        end
    endtask
endclass