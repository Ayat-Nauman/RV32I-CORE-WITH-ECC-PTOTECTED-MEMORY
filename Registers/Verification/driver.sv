class driver;
    virtual reg_intf vif;
    mailbox gen2drv;
    mailbox drv2scb;

    function new(virtual reg_intf vif, mailbox gen2drv, mailbox drv2scb);
        this.vif     = vif;
        this.gen2drv = gen2drv;
        this.drv2scb = drv2scb;
    endfunction

    task reset();
        vif.r32_R      <= 1;
        vif.r32_WE     <= 0;
        vif.r32_D      <= 0;
        vif.rf_RegWrite  <= 0;
        vif.rf_WriteReg  <= 0;
        vif.rf_WriteData <= 0;
        vif.rf_ReadReg1  <= 0;
        vif.rf_ReadReg2  <= 0;
        repeat (2) @(posedge vif.clk);
        vif.r32_R <= 0;
        $display("reset done");
    endtask

    task run();
        transaction tr;
        forever begin
            gen2drv.get(tr);
            @(posedge vif.clk);
            vif.r32_R        <= tr.r32_R;
            vif.r32_WE       <= tr.r32_WE;
            vif.r32_D        <= tr.r32_D;
            vif.rf_RegWrite  <= tr.rf_RegWrite;
            vif.rf_WriteReg  <= tr.rf_WriteReg;
            vif.rf_WriteData <= tr.rf_WriteData;
            vif.rf_ReadReg1  <= tr.rf_ReadReg1;
            vif.rf_ReadReg2  <= tr.rf_ReadReg2;

            tr.display("driver");
            drv2scb.put(tr);
        end
    endtask
endclass
