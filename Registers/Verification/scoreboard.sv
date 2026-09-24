class scoreboard;
    mailbox drv2scb;
    mailbox mon2scb;

    int pass, fail;

    // reference models
    bit [31:0] shadow_Q;
    bit [31:0] shadow_mem[0:31];

    transaction exp_q[$];   // stimulus, from driver
    transaction act_q[$];   // actual outputs, from monitor

    function new(mailbox drv2scb, mailbox mon2scb);
        this.drv2scb = drv2scb;
        this.mon2scb = mon2scb;
        pass = 0;
        fail = 0;
        shadow_Q = 0;
        for (int i = 0; i < 32; i++)
            shadow_mem[i] = 0;
    endfunction

    task compare();
        bit [31:0] exp_rd1, exp_rd2;
        bit ok;

        if (exp_q.size() > 0 && act_q.size() > 0) begin
            transaction e = exp_q.pop_front();
            transaction a = act_q.pop_front();

            // ---- reg32b reference model ----
            if (e.r32_R)
                shadow_Q = 0;
            else if (e.r32_WE)
                shadow_Q = e.r32_D;

            // ---- regfile reference model ----
            if (e.rf_RegWrite && e.rf_WriteReg != 0)
                shadow_mem[e.rf_WriteReg] = e.rf_WriteData;

            exp_rd1 = shadow_mem[e.rf_ReadReg1];
            exp_rd2 = shadow_mem[e.rf_ReadReg2];

            ok = (shadow_Q == a.r32_Q) &&
                 (exp_rd1  == a.rf_ReadData1) &&
                 (exp_rd2  == a.rf_ReadData2);

            if (ok) begin
                pass++;
                $display("[PASS] r32_Q=%0h (exp %0h) | rf_RD1=%0h (exp %0h) rf_RD2=%0h (exp %0h)",
                          a.r32_Q, shadow_Q, a.rf_ReadData1, exp_rd1, a.rf_ReadData2, exp_rd2);
            end else begin
                fail++;
                $display("[FAIL] r32_Q=%0h (exp %0h) | rf_RD1=%0h (exp %0h) rf_RD2=%0h (exp %0h)",
                          a.r32_Q, shadow_Q, a.rf_ReadData1, exp_rd1, a.rf_ReadData2, exp_rd2);
            end
            $display("Pass cases = %0d, Fail cases = %0d", pass, fail);
        end
    endtask

    task run();
        fork
            forever begin
                transaction tr;
                drv2scb.get(tr);
                exp_q.push_back(tr);
                compare();
            end
            forever begin
                transaction tr;
                mon2scb.get(tr);
                act_q.push_back(tr);
                compare();
            end
        join_none
    endtask
endclass
