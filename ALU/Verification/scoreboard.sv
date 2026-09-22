class scoreboard;
    mailbox mon2scb;
    int pass_count = 0;
    int fail_count = 0;

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task run();
        ex_transaction tr;
        forever begin
            mon2scb.get(tr);
            verify_cluster(tr);
        end
    endtask

    function void verify_cluster(ex_transaction tr);
        bit [2:0] exp_op;
        bit [31:0] exp_aluout;
        bit exp_zero;
        bit exp_branch;

        // simulating ALUcu        
        case(tr.ALUop)
            2'b00: exp_op = 3'b011; 
            2'b01: exp_op = 3'b100; 
            2'b10: begin
                case (tr.funct3)
                    3'b000: exp_op = (tr.funct7b5 == 1'b0 || ~tr.opcodeb5) ? 3'b011 : 3'b100;
                    3'b001: exp_op = 3'b110;
                    3'b010: exp_op = 3'b101;
                    3'b100: exp_op = 3'b010;
                    3'b101: exp_op = 3'b111;
                    3'b110: exp_op = 3'b001;
                    3'b111: exp_op = 3'b000;
                    default: exp_op = 3'b000;
                endcase
            end
            default: exp_op = 3'b000;
        endcase

        // Simulating ALU
        case (exp_op)
            3'b000: exp_aluout = tr.src1 & tr.src2;
            3'b001: exp_aluout = tr.src1 | tr.src2;
            3'b010: exp_aluout = tr.src1 ^ tr.src2;
            3'b011: exp_aluout = tr.src1 + tr.src2;
            3'b100: exp_aluout = tr.src1 - tr.src2;
            3'b101: begin 
                exp_aluout = tr.src1 - tr.src2; 
                exp_aluout = {31'b0, exp_aluout[31]}; 
            end 
            3'b110: exp_aluout = tr.src1 << tr.src2[4:0];
            3'b111: exp_aluout = tr.src1 >> tr.src2[4:0]; 
        endcase
        exp_zero = (exp_aluout == 0);

        // Simulating Branch Evaluator
        if(tr.PCWriteCond) begin
            case (tr.funct3)
                3'b000: exp_branch = exp_zero;
                3'b001: exp_branch = ~exp_zero;
                3'b100: exp_branch = (exp_aluout[31] == 1'b1);
                3'b101: exp_branch = (exp_aluout[31] == 1'b0);
                default: exp_branch = 1'b0;
            endcase        
        end else begin
            exp_branch = 1'b0;
        end

        // Compare our simulated result (expected) with actual pin outputs
        if (exp_aluout === tr.ALUout && exp_branch === tr.branch) begin
            pass_count++;
        end else begin
            fail_count++;
            $display("[FAIL] ALUop:%b f3:%b opb5:%b f7b5:%b | Src1:%08h Src2:%08h | EXP_OUT:%08h ACT_OUT:%08h | EXP_BR:%b ACT_BR:%b", 
                tr.ALUop, tr.funct3, tr.opcodeb5, tr.funct7b5, tr.src1, tr.src2, exp_aluout, tr.ALUout, exp_branch, tr.branch);
        end
    endfunction

    function void report();
        $display("\n=========================================");
        $display("[SCOREBOARD] Execution Verified");
        $display(" Total Transactions Checked : %0d", pass_count + fail_count);
        $display(" Passed                     : %0d", pass_count);
        $display(" Failed                     : %0d", fail_count);
        $display("=========================================\n");
    endfunction
endclass