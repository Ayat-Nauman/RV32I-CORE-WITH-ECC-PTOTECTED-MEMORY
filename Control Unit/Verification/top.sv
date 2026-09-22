`include "interface.sv"
`include "cu_package.sv"

module top_tb();
    import cu_pkg::*;
    
    logic clk;
    
    // interface & DUT Instantiation
    cu_intf u_intf(clk);
    
    CU dut (
        .clk(clk),
        .opcode(u_intf.opcode),
        .IorD(u_intf.IorD),
        .IRwrite(u_intf.IRwrite),
        .MemRead(u_intf.MemRead),
        .MemWrite(u_intf.MemWrite),
        .ALUsrcA(u_intf.ALUsrcA),
        .ALUsrcB(u_intf.ALUsrcB),
        .ALUop(u_intf.ALUop),
        .PcWrite(u_intf.PcWrite),
        .PCWriteCond(u_intf.PCWriteCond),
        .SrcReg(u_intf.SrcReg),
        .PCsource(u_intf.PCsource),
        .RegWrite(u_intf.RegWrite)
    );

    // probing the internal state for the scoreboard
    assign u_intf.stateReg = dut.stateReg;

    // clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // test Execution
    environment env;
    initial begin
        env = new(u_intf);
        env.run();
        $stop;
    end
endmodule