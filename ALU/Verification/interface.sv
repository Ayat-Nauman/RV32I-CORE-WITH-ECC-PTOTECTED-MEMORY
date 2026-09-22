interface ex_intf(input logic clk);    
    logic [31:0] src1, src2;
    logic [1:0]  ALUop;
    logic [2:0]  funct3;
    logic        opcodeb5, funct7b5, PCWriteCond;
        
    logic [31:0] ALUout;
    logic        branch;
        
    logic [2:0]  alu_op_code;
    logic        alu_zero;
endinterface