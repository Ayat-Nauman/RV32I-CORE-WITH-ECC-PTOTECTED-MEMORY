`timescale 1ns / 1ps
module datapath(
    input clk,
    output [31:0] PC, IR, Aregin, ALUout, Areg, Breg,
    output IorDO, IRwriteO, MemReadO, MemWriteO, ALUsrcAO, PcWriteO, PCsourceO, PCWriteCondO, RegWriteO,
    output [1:0] ALUsrcBO, SrcRegO,
    output [3:0] state,
    input fault_en,
    input [1:0] fault_mode,
    input [5:0] fault_bit1,
    input [5:0] fault_bit2,
    input error_clear,
    output single_bit_error,
    output double_bit_error,
    output sbe_sticky,
    output dbe_sticky,
    output [7:0] sbe_count,
    output [7:0] dbe_count
    );

    reg [31:0] PCin, MemAddress, src1, src2, RegData;
    wire [31:0] PCout, IRin, IRout, MemDatain, MemDataout, MDRin, MDRout, ImmOut, Ain, Aout, Bin, Bout, ALUoutD, ALUoutQ;
    wire IorD, IRwrite, MemRead, MemWrite, ALUsrcA, PcWrite, PCsource, PCWriteCond, PCWriteEnable, RegWrite, branch, zero;
    wire [1:0] ALUsrcB, ALUop, SrcReg;
    wire [3:0] next;
    wire [2:0] funct3, op;
    wire [31:0] InstrOut, DmemOut;

    assign PC = PCout;
    assign IR = IRout;
    assign Aregin = Ain;
    assign Areg = Aout;
    assign Breg = Bout;
    assign ALUout = ALUoutQ;

    assign IorDO = IorD;
    assign IRwriteO = IRwrite;
    assign MemReadO = MemRead;
    assign MemWriteO = MemWrite;
    assign ALUsrcAO = ALUsrcA;
    assign PcWriteO = PcWrite;
    assign PCsourceO = PCsource;
    assign PCWriteCondO = PCWriteCond;
    assign RegWriteO = RegWrite;
    assign ALUsrcBO = ALUsrcB;
    assign SrcRegO = SrcReg;
    assign state = next;

    assign PCWriteEnable = PcWrite | (PCWriteCond & branch);

    always @(*) begin
        if (PCsource)
            PCin = ALUoutQ;
        else
            PCin = ALUoutD;
    end

    reg32b PCreg (.clk(clk), .R(1'b0), .WE(PCWriteEnable), .D(PCin), .Q(PCout));

    always @(*) begin
        if (IorD)
            MemAddress = ALUoutQ;
        else
            MemAddress = PCout;
    end

    assign MemDatain = Bout;
    assign IRin = MemDataout;
    assign MDRin = MemDataout;

    instr_mem imem (.clk(clk), .Address(MemAddress), .MemRead(MemRead & ~IorD), .Instr(InstrOut));

    dmem_ecc dmem (.clk(clk), .Address(MemAddress), .WriteData(MemDatain),
                   .MemRead(MemRead & IorD), .MemWrite(MemWrite),
                   .fault_en(fault_en), .fault_mode(fault_mode),
                   .fault_bit1(fault_bit1), .fault_bit2(fault_bit2),
                   .error_clear(error_clear), .Data(DmemOut),
                   .single_bit_error(single_bit_error), .double_bit_error(double_bit_error),
                   .sbe_sticky(sbe_sticky), .dbe_sticky(dbe_sticky),
                   .sbe_count(sbe_count), .dbe_count(dbe_count));

    assign MemDataout = IorD ? DmemOut : InstrOut;

    reg32b IRreg (.clk(clk), .R(1'b0), .WE(IRwrite), .D(IRin), .Q(IRout));

    CU ctrlunit(.opcode(IRout), .clk(clk), .IorD(IorD), .IRwrite(IRwrite), .MemRead(MemRead), .MemWrite(MemWrite),
    .ALUsrcA(ALUsrcA), .ALUsrcB(ALUsrcB), .ALUop(ALUop), .PcWrite(PcWrite), .PCWriteCond(PCWriteCond), .SrcReg(SrcReg),
    .PCsource(PCsource), .RegWrite(RegWrite), .next(next));

    reg32b MDRreg (.clk(clk), .R(1'b0), .WE(1'b1), .D(MDRin), .Q(MDRout));

    ImmGen immediateGen (.inst(IRout), .imm(ImmOut));

    regfile Registerfile (.clk(clk), .ReadReg1(IRout[19:15]), .ReadReg2(IRout[24:20]), .WriteReg(IRout[11:7]), .WriteData(RegData),
                          .RegWrite(RegWrite), .ReadData1(Ain), .ReadData2(Bin));

    reg32b A (.clk(clk), .R(1'b0), .WE(1'b1), .D(Ain), .Q(Aout));

    reg32b B (.clk(clk), .R(1'b0), .WE(1'b1), .D(Bin), .Q(Bout));

    always @(*) begin
        if (ALUsrcA)
            src1 = Aout;
        else
            src1 = PCout;
    end

    always @(*) begin
        case (ALUsrcB)
            2'b00: src2 = Bout;
            2'b01: src2 = 32'h00000004;
            default: src2 = ImmOut;
        endcase
    end

    funct3Setter setter (.funct3(IRout[14:12]), .PCWriteCond(PCWriteCond), .Setfunct3(funct3));

    ALUcu alucu(.funct3(funct3), .ALUop(ALUop), .funct7b5(IRout[30]), .op(op));
    ALU alu(.src1(src1), .src2(src2), .op(op), .ALUout(ALUoutD), .zero(zero));

    branchEvaluator beval(.PCWriteCond(PCWriteCond), .funct3(IRout[14:12]), .x(ALUoutD), .z(zero), .branch(branch));

    reg32b ALUoutReg (.clk(clk), .R(1'b0), .WE(1'b1), .D(ALUoutD), .Q(ALUoutQ));

    always @(*) begin
        case (SrcReg)
            2'b00: RegData = ALUoutQ;
            2'b01: RegData = MDRout;
            2'b10: RegData = ImmOut;
            2'b11: RegData = PCout;
        endcase
    end

endmodule
