class driver;
    virtual ex_intf vif;
    mailbox gen2drv;

    function new(virtual ex_intf vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task run();
        ex_transaction tr;
        forever begin
            gen2drv.get(tr);
                        
            @(negedge vif.clk); 
            vif.src1        <= tr.src1;
            vif.src2        <= tr.src2;
            vif.ALUop       <= tr.ALUop;
            vif.funct3      <= tr.funct3;
            vif.opcodeb5    <= tr.opcodeb5;
            vif.funct7b5    <= tr.funct7b5;
            vif.PCWriteCond <= tr.PCWriteCond;
        end
    endtask
endclass