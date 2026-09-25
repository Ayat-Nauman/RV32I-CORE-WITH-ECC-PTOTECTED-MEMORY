interface ex_intf(input logic clk);    
    logic [31:0] src1, src2;
    logic [1:0]  ALUop;
    logic [2:0]  funct3;
    logic        opcodeb5, funct7b5, PCWriteCond;
        
    logic [31:0] ALUout;
    logic        branch;
        
    logic [2:0]  alu_op_code;
    logic        alu_zero;

    // Assertions

    // Asserting ALU Zero Flag Validity
    // proves the zero flag strictly reflects ALUout regardless of the operation
    property p_alu_zero_flag;
        @(posedge clk) alu_zero == (ALUout == 32'h00000000);
    endproperty
    assert_alu_zero: assert property(p_alu_zero_flag) 
        else $error("[ASSERTION FAULT] ALU Zero flag does not match ALUout!");

    // Asserting ALU Addition Correctness
    property p_alu_add;
        @(posedge clk) (alu_op_code == 3'b011) |-> (ALUout == src1 + src2);
    endproperty
    assert_alu_add: assert property(p_alu_add) 
        else $error("[ASSERTION FAULT] ALU Addition mathematical failure!");

    // Asserting ALU Subtraction Correctness
    property p_alu_sub;
        @(posedge clk) (alu_op_code == 3'b100) |-> (ALUout == src1 - src2);
    endproperty
    assert_alu_sub: assert property(p_alu_sub) 
        else $error("[ASSERTION FAULT] ALU Subtraction mathematical failure!");

    // Assert ALU AND Correctness
    property p_alu_and;
        @(posedge clk) (alu_op_code == 3'b000) |-> (ALUout == (src1 & src2));
    endproperty
    assert_alu_and: assert property(p_alu_and) else $error("[ASSERTION FAULT] ALU AND failure!");

    // Assert ALU OR Correctness
    property p_alu_or;
        @(posedge clk) (alu_op_code == 3'b001) |-> (ALUout == (src1 | src2));
    endproperty
    assert_alu_or: assert property(p_alu_or) else $error("[ASSERTION FAULT] ALU OR failure!");

    // Assert ALU XOR Correctness
    property p_alu_xor;
        @(posedge clk) (alu_op_code == 3'b010) |-> (ALUout == (src1 ^ src2));
    endproperty
    assert_alu_xor: assert property(p_alu_xor) else $error("[ASSERTION FAULT] ALU XOR failure!");

    // Assert ALU SLT Correctness
    property p_alu_slt;
        @(posedge clk) (alu_op_code == 3'b101) |-> (ALUout == ($signed(src1) < $signed(src2) ? 32'd1 : 32'd0));
    endproperty
    assert_alu_slt: assert property(p_alu_slt) 
        else $error("[ASSERTION FAULT] ALU SLT failure! src1: %0d (%08h) | src2: %0d (%08h) | ALUout: %08h", 
                    $signed(src1), src1, $signed(src2), src2, ALUout);

    // Assert ALU SLL Correctness
    property p_alu_sll;
        @(posedge clk) (alu_op_code == 3'b110) |-> (ALUout == (src1 << src2[4:0]));
    endproperty
    assert_alu_sll: assert property(p_alu_sll) else $error("[ASSERTION FAULT] ALU SLL failure!");

    // Assert ALU SRL Correctness
    property p_alu_srl;
        @(posedge clk) (alu_op_code == 3'b111) |-> (ALUout == (src1 >> src2[4:0]));
    endproperty
    assert_alu_srl: assert property(p_alu_srl) else $error("[ASSERTION FAULT] ALU SRL failure!");

    // Asserting Branch BEQ Resolution
    // proves that if we are evaluating a branch and it is BEQ (funct3==000), 
    // the branch decision MUST exactly match the ALU zero flag
    property p_branch_beq;
        @(posedge clk) (PCWriteCond == 1'b1 && funct3 == 3'b000) |-> (branch == alu_zero);
    endproperty
    assert_branch_beq: assert property(p_branch_beq) 
        else $error("[ASSERTION FAULT] Branch BEQ incorrectly resolved!");

    // Asserting Branch BNE Resolution
    property p_branch_bne;
        @(posedge clk) (PCWriteCond == 1'b1 && funct3 == 3'b001) |-> (branch == ~alu_zero);
    endproperty
    assert_branch_bne: assert property(p_branch_bne) 
        else $error("[ASSERTION FAULT] Branch BNE incorrectly resolved!");

    // Asserting Branch BLT Resolution
    property p_branch_blt;
        @(posedge clk) (PCWriteCond == 1'b1 && funct3 == 3'b100) |-> (branch == ALUout[31]);
    endproperty
    assert_branch_blt: assert property(p_branch_blt) 
        else $error("[ASSERTION FAULT] Branch BLT incorrectly resolved!");

    // Asserting Branch BGE Resolution
    property p_branch_bge;
        @(posedge clk) (PCWriteCond == 1'b1 && funct3 == 3'b101) |-> (branch == ~ALUout[31]);
    endproperty
    assert_branch_bge: assert property(p_branch_bge) 
        else $error("[ASSERTION FAULT] Branch BGE incorrectly resolved!");

endinterface