interface cu_intf(input logic clk);
    logic [6:0] opcode;
    logic IorD, IRwrite, MemRead, MemWrite, ALUsrcA, PcWrite, PCWriteCond, PCsource, RegWrite;
    logic [1:0] ALUsrcB, ALUop, SrcReg;
    
    // internal state for verification
    logic [3:0] stateReg; 

    // Assertions
    
    // bundling the signals to match the 17-bit vector format used in the Scoreboard
    wire [16:0] actual_ctrls;
    assign actual_ctrls = {PcWrite, PCWriteCond, IorD, MemRead, MemWrite, 
                               SrcReg, IRwrite, PCsource, ALUop, ALUsrcB, 
                               ALUsrcA, RegWrite, 2'b00};

    // Asserting Fetch State Correctness
    property p_cu_state_fetch;
        @(posedge clk) (stateReg == 4'd0) |-> ((actual_ctrls & 17'h1FFFC) == (17'h02013 & 17'h1FFFC));
    endproperty
    assert_cu_fetch: assert property(p_cu_state_fetch) 
        else $error("[ASSERTION] CU Fetch (State 0) control signals incorrect!");

    // Asserting Decode State Correctness
    property p_cu_state_decode;
        @(posedge clk) (stateReg == 4'd2) |-> ((actual_ctrls & 17'h1FFFC) == (17'h10121 & 17'h1FFFC));
    endproperty
    assert_cu_decode: assert property(p_cu_state_decode) 
        else $error("[ASSERTION] CU Decode (State 2) control signals incorrect!");

    // Asserting R-Type Execution Correctness
    property p_cu_state_rtype_exec;
        @(posedge clk) (stateReg == 4'd3) |-> ((actual_ctrls & 17'h1FFFC) == (17'h0008B & 17'h1FFFC));
    endproperty
    assert_cu_rtype_exec: assert property(p_cu_state_rtype_exec) 
        else $error("[ASSERTION] CU R-Type Exec (State 3) control signals incorrect!");

    // Asserting R-Type Write Back Correctness
    property p_cu_state_rtype_wb;
        @(posedge clk) (stateReg == 4'd4) |-> ((actual_ctrls & 17'h1FFFC) == (17'h00004 & 17'h1FFFC));
    endproperty
    assert_cu_state_rtype_wb: assert property(p_cu_state_rtype_wb) 
        else $error("[ASSERTION] CU R-Type WB (State 4) control signals incorrect!");

    // Asserting I-Type Execution Correctness
    property p_cu_state_itype_exec;
        @(posedge clk) (stateReg == 4'd5) |-> ((actual_ctrls & 17'h1FFFC) == (17'h000AB & 17'h1FFFC));
    endproperty
    assert_cu_state_itype_exec: assert property(p_cu_state_itype_exec) 
        else $error("[ASSERTION] CU I-Type Exec (State 5) control signals incorrect!");

    // Asserting I-Type Write Back Correctness
    property p_cu_state_itype_wb;
        @(posedge clk) (stateReg == 4'd6) |-> ((actual_ctrls & 17'h1FFFC) == (17'h00004 & 17'h1FFFC));
    endproperty
    assert_cu_state_itype_wb: assert property(p_cu_state_itype_wb) 
        else $error("[ASSERTION] CU I-Type Write Back (State 6) control signals incorrect!");

    // Asserting LW/SW Execution i.e Address Generation Correctness
    property p_cu_state_mem_exec;
        @(posedge clk) (stateReg == 4'd7) |-> ((actual_ctrls & 17'h1FFFC) == (17'h0002A & 17'h1FFFC));
    endproperty
    assert_cu_state_mem_exec: assert property(p_cu_state_mem_exec) 
        else $error("[ASSERTION] CU LW/SW Exec (State 7) control signals incorrect!");

    // Asserting LW Memory Access Correctness
    property p_cu_state_lw_mem;
        @(posedge clk) (stateReg == 4'd8) |-> ((actual_ctrls & 17'h1FFFC) == (17'h06003 & 17'h1FFFC));
    endproperty
    assert_cu_state_lw_mem: assert property(p_cu_state_lw_mem) 
        else $error("[ASSERTION] CU LW Memory Access (State 8) control signals incorrect!");

    // Asserting LW Write Back Correctness
    property p_cu_state_lw_wb;
        @(posedge clk) (stateReg == 4'd10) |-> ((actual_ctrls & 17'h1FFFC) == (17'h00404 & 17'h1FFFC));
    endproperty
    assert_cu_state_lw_wb: assert property(p_cu_state_lw_wb) 
        else $error("[ASSERTION] CU LW Write Back (State 10) control signals incorrect!");

    // Asserting SW Memory Access Correctness
    property p_cu_state_sw_mem;
        @(posedge clk) (stateReg == 4'd11) |-> ((actual_ctrls & 17'h1FFFC) == (17'h05000 & 17'h1FFFC));
    endproperty
    assert_cu_state_sw_mem: assert property(p_cu_state_sw_mem) 
        else $error("[ASSERTION] CU SW Memory Access (State 11) control signals incorrect!");

    // Asserting Branch Execute
    property p_cu_state_branch_ex;
        @(posedge clk) (stateReg == 4'd12) |-> ((actual_ctrls & 17'h1FFFC) == (17'h08148 & 17'h1FFFC));
    endproperty
    assert_cu_state_branch_ex: assert property(p_cu_state_branch_ex) 
        else $error("[ASSERTION] CU Branch EX (State 12) control signals incorrect!");

    // Asserting LUI Execute Correctness
    property p_cu_state_lui_ex;
        @(posedge clk) (stateReg == 4'd13) |-> ((actual_ctrls & 17'h1FFFC) == (17'h00804 & 17'h1FFFC));
    endproperty
    assert_cu_state_lui_ex: assert property(p_cu_state_lui_ex) 
        else $error("[ASSERTION] CU LUI EX (State 13) control signals incorrect!");            

    // Asserting Jalr Execute
    property p_cu_state_jalr_ex;
        @(posedge clk) (stateReg == 4'd14) |-> ((actual_ctrls & 17'h1FFFC) == (17'h10C2C & 17'h1FFFC));
    endproperty
    assert_cu_state_jalr_ex: assert property(p_cu_state_jalr_ex) 
        else $error("[ASSERTION] CU Jalr EX (State 14) control signals incorrect!");

    // Asserting Jal Execute Correctness
    property p_cu_state_jal_ex;
        @(posedge clk) (stateReg == 4'd15) |-> ((actual_ctrls & 17'h1FFFC) == (17'h10D04 & 17'h1FFFC));
    endproperty
    assert_cu_state_jal_ex: assert property(p_cu_state_jal_ex) 
        else $error("[ASSERTION] CU Jal EX (State 15) control signals incorrect!");            

endinterface