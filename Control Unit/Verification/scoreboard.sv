class scoreboard;
    mailbox mon2scb;
    int pass_count = 0;
    int fail_count = 0;

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task run();
        cu_transaction tr;
        bit [16:0] expected_ctrls;
        bit [16:0] actual_ctrls;
        
        forever begin
            mon2scb.get(tr);
                        
            case(tr.state)
                4'd0:  expected_ctrls = 17'h02013;
                4'd1:  expected_ctrls = 17'h00213;
                4'd2:  expected_ctrls = 17'h10121;
                4'd3:  expected_ctrls = 17'h0008B;
                4'd4:  expected_ctrls = 17'h00004;
                4'd5:  expected_ctrls = 17'h000AB;
                4'd6:  expected_ctrls = 17'h00004;
                4'd7:  expected_ctrls = 17'h0002A;
                4'd8:  expected_ctrls = 17'h06003;
                4'd9:  expected_ctrls = 17'h00003;
                4'd10: expected_ctrls = 17'h00404;
                4'd11: expected_ctrls = 17'h05000;
                4'd12: expected_ctrls = 17'h08148;
                4'd13: expected_ctrls = 17'h00804;
                4'd14: expected_ctrls = 17'h10C2C;
                4'd15: expected_ctrls = 17'h10D04;
                default: expected_ctrls = 17'h00000;
            endcase

            // Combine actual signals back into a 17-bit vector to compare
            actual_ctrls = {tr.PcWrite, tr.PCWriteCond, tr.IorD, tr.MemRead, tr.MemWrite, 
                            tr.SrcReg, tr.IRwrite, tr.PCsource, tr.ALUop, tr.ALUsrcB, 
                            tr.ALUsrcA, tr.RegWrite, 2'b00}; // Bottom 2 bits are nextstate logic, ignored here

            // Since bottom 2 bits dictate next state, we mask them out (bitwise AND with 17'h1FFFC)
            if ((actual_ctrls & 17'h1FFFC) == (expected_ctrls & 17'h1FFFC)) begin
                pass_count++;
            end else begin
                fail_count++;
                $display("[FAIL] State: %0d | Expected: %05x | Actual: %05x", tr.state, expected_ctrls, actual_ctrls);
            end
        end
    endtask

    function void report();        
        $display("\n[SCOREBOARD] Control Unit Verification");
        $display(" Total Cycles Checked : %0d", pass_count + fail_count);
        $display(" Cycles Passed        : %0d", pass_count);
        $display(" Cycles Failed        : %0d", fail_count);        
    endfunction
endclass