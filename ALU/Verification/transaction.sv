class ex_transaction;
    rand bit [31:0] src1, src2;
    rand bit [1:0]  ALUop;
    rand bit [2:0]  funct3;
    rand bit        opcodeb5, funct7b5, PCWriteCond;
    
    // constraints to explicitly force edge cases
    constraint operand_edge_cases {
        src1 dist {
            32'h00000000 := 5,       // 5% chance to hit pure Zero
            32'hFFFFFFFF := 5,       // 5% chance to hit All Ones
            [32'h00000001 : 32'hFFFFFFFE] :/ 90  // 90% chance to be anything else
        };
        
        src2 dist {
            32'h00000000 := 5,
            32'hFFFFFFFF := 5,
            [32'h00000001 : 32'hFFFFFFFE] :/ 90
        };
    }
        
    bit [31:0] ALUout;
    bit        branch;
        
    function string get_aluop_name();
        case(ALUop)
            2'b00: return "LW/SW (+)";
            2'b01: return "BRANCH (-)";
            2'b10: return "R/I-TYPE";
            default: return "UNUSED";
        endcase
    endfunction
endclass