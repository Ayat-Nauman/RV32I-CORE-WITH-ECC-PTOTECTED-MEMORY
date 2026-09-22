`timescale 1ns / 1ps

`include "interface.sv"

module top_tb();
    import ex_pkg::*;
    
    logic clk;
    ex_intf u_intf(clk);

    wire [2:0] alu_op_code;
    wire       alu_zero;
    wire       alu_sign;
    
    // assigning probes to interface for coverage/debug
    assign u_intf.alu_op_code = alu_op_code;
    assign u_intf.alu_zero    = alu_zero;
    assign alu_sign           = u_intf.ALUout[31];
    
    ALUcu dut_alucu (
        .funct3(u_intf.funct3),
        .ALUop(u_intf.ALUop),
        .opcodeb5(u_intf.opcodeb5),
        .funct7b5(u_intf.funct7b5),
        .op(alu_op_code)
    );
    
    ALU dut_alu (
        .src1(u_intf.src1),
        .src2(u_intf.src2),
        .op(alu_op_code),
        .ALUout(u_intf.ALUout),
        .zero(alu_zero)
    );
    
    branchEvaluator dut_branch (
        .PCWriteCond(u_intf.PCWriteCond),
        .funct3(u_intf.funct3),
        .sign(alu_sign),
        .z(alu_zero),
        .branch(u_intf.branch)
    );

    // clock generation (ALU is purely combinational this clock is just for monitor and driver)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    environment env;
    initial begin
        env = new(u_intf);
        env.run();
        $stop;
    end
endmodule