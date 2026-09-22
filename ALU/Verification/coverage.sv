class coverage_collector;
    ex_transaction tr;
    mailbox mon2cov;
    virtual ex_intf vif;

    covergroup cg_ex;
        option.per_instance = 1;

        // Operand 1 Bins
        cp_src1: coverpoint tr.src1 {
            bins zero     = {32'h00000000};
            bins all_ones = {32'hFFFFFFFF};
            bins positive = {[32'h00000001 : 32'h7FFFFFFF]};
            bins negative = {[32'h80000000 : 32'hFFFFFFFE]};
        }

        // Operand 2 Bins
        cp_src2: coverpoint tr.src2 {
            bins zero     = {32'h00000000};
            bins all_ones = {32'hFFFFFFFF};
            bins positive = {[32'h00000001 : 32'h7FFFFFFF]};
            bins negative = {[32'h80000000 : 32'hFFFFFFFE]};
        }

        // ALU Operations (proves the ALUcu generated all 8 operations)
        cp_alu_op: coverpoint vif.alu_op_code {
            bins op_and = {3'b000};
            bins op_or  = {3'b001};
            bins op_xor = {3'b010};
            bins op_add = {3'b011};
            bins op_sub = {3'b100};
            bins op_slt = {3'b101};
            bins op_sll = {3'b110};
            bins op_srl = {3'b111};
        }

        // Branch Evaluator Coverage (to check if all B-Type inst were covered) 
        // Only sample when PCWriteCond is active
        cp_branch_type: coverpoint tr.funct3 iff (tr.PCWriteCond == 1'b1) {
            bins beq = {3'b000};
            bins bne = {3'b001};
            bins blt = {3'b100};
            bins bge = {3'b101};
        }

        cp_branch_taken: coverpoint tr.branch iff (tr.PCWriteCond == 1'b1) {
            bins not_taken = {1'b0};
            bins taken     = {1'b1};
        }

        // CROSS COVERAGE: checking if every branch type evaluated to both True AND False
        cross_branch_eval: cross cp_branch_type, cp_branch_taken;
        
        // CROSS COVERAGE: checking if all ALU operations were tested with edge case operands
        cross_alu_src1: cross cp_alu_op, cp_src1;
        cross_alu_src2: cross cp_alu_op, cp_src2;

    endgroup

    function new(virtual ex_intf vif, mailbox mon2cov);
        this.vif = vif;
        this.mon2cov = mon2cov;
        cg_ex = new();
    endfunction

    task run();
        forever begin
            mon2cov.get(tr);
            cg_ex.sample();
        end
    endtask
endclass