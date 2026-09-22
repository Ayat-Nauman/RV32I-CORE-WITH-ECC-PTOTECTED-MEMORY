interface cu_intf(input logic clk);
    logic [6:0] opcode;
    logic IorD, IRwrite, MemRead, MemWrite, ALUsrcA, PcWrite, PCWriteCond, PCsource, RegWrite;
    logic [1:0] ALUsrcB, ALUop, SrcReg;
    
    // internal state for verification
    logic [3:0] stateReg; 
endinterface