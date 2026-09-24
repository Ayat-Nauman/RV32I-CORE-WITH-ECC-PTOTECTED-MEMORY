class generator;
    transaction tr;
    mailbox gen2drv;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        // directed case: try to write register 0, must stay 0
        tr = new();
        tr.r32_R      = 0;
        tr.r32_WE     = 0;
        tr.r32_D      = 0;
        tr.rf_RegWrite  = 1;
        tr.rf_WriteReg  = 0;
        tr.rf_WriteData = 32'hFFFF_FFFF;
        tr.rf_ReadReg1  = 0;
        tr.rf_ReadReg2  = 1;
        gen2drv.put(tr);
        tr.display("generator (directed: write reg0)");

        // random traffic, including same-cycle write/read hazards via constraints
        repeat (100) begin
            tr = new();
            tr.randomize();
            gen2drv.put(tr);
            tr.display("generator");
        end
    endtask
endclass
