class cu_transaction;
    rand bit [6:0] opcode;
    
    // outputs for the scoreboard
    bit [3:0] state;
    bit IorD, IRwrite, MemRead, MemWrite, ALUsrcA, PcWrite, PCWriteCond, PCsource, RegWrite;
    bit [1:0] ALUsrcB, ALUop, SrcReg;

    // Constrain to valid RISC-V opcode
    constraint valid_opcodes {
        opcode inside {
            7'b0110011, // R-Type
            7'b0010011, // I-Type
            7'b0000011, // LW
            7'b0100011, // SW
            7'b1100011, // Branch
            7'b0110111, // LUI
            7'b1100111, // JALR
            7'b1101111, // JAL
            7'b0010111  // AUIPC
        };
    }

    function void display(string name);
        $display("[%s] Opcode: %7b | State: %0d | IorD:%b IRwr:%b MRead:%b MWrite:%b RegWr:%b ALUop:%b", 
                 name, opcode, state, IorD, IRwrite, MemRead, MemWrite, RegWrite, ALUop);
    endfunction
endclass