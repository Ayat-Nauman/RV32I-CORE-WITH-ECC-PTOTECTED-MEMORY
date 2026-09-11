//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 07:28:34 PM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module datapath(
    input clk,
	 input rst,
	 input rx,
    output [31:0] PC, IR, Aregin, ALUout, Areg, Breg,
    output IorDO, IRwriteO, MemReadO, MemWriteO, ALUsrcAO, PcWriteO, PCsourceO, PCWriteCondO, RegWriteO,    
    output [1:0] ALUsrcBO, SrcRegO,
    output [3:0] state,
	 output tx
    );
      
    reg [31:0] PCin, MemAddress, src1, src2, RegData;
    wire [31:0] PCout, IRin, IRout, MemDatain, MemDataout, MDRin, MDRout, ImmOut, Ain, Aout, Bin, Bout, ALUoutD, ALUoutQ;
    wire IorD, IRwrite, MemRead, MemWrite, ALUsrcA, PcWrite, PCsource, PCWriteCond, PCWriteEnable, RegWrite, branch, zero;
    wire [1:0] ALUsrcB, ALUop, SrcReg; 
    wire [3:0] next;
    wire [2:0] op;
    
    assign PC = PCout;
    assign IR = IRout;
    assign Aregin = Ain;
    assign Areg = Aout;
    assign Breg = Bout;
    assign ALUout = ALUoutQ;
    
    //outputs for verfification
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
              
    //   Instruction Fetch    
  
    //PC Source MuxD
    always @(*) begin
        if(PCsource)
            PCin = ALUoutQ;
        else
            PCin = ALUoutD;            
    end    

    //Program Counter Register                
    reg32b PCreg (.clk(clk), .R(1'b0), .WE(PCWriteEnable), .D(PCin), .Q(PCout));
    
    // Instruction or Data mux
    always @(*) begin
        if(IorD)
            MemAddress = ALUoutQ;
        else
            MemAddress = PCout;            
    end      
       
       
    //Memory Definition            
    assign MemDatain = Bout;
    assign IRin = MemDataout;
    assign MDRin = MemDataout;
	 
	 // memory
	 mem_map_decoder mmap_decoder (
		.clk(clk), 
		.rst(rst),
		.Address(MemAddress), 
		.WriteData(MemDatain),
		.MemRead(MemRead), 
		.MemWrite(MemWrite), 
		.ReadData(MemDataout), 
		.rx(rx), 
		.tx(tx)
	);

//    memory mem(.clk(clk), .Address(MemAddress), .WriteData(MemDatain), .MemRead(MemRead), .MemWrite(MemWrite), .Data(MemDataout));   
      
    //Instruction Register
    reg32b IRreg (.clk(clk), .R(1'b0), .WE(IRwrite), .D(IRin), .Q(IRout));
        
    //   Instruction Decode
        
    CU ctrlunit(.opcode(IRout[6:0]), .clk(clk), .IorD(IorD), .IRwrite(IRwrite), .MemRead(MemRead), .MemWrite(MemWrite),
    .ALUsrcA(ALUsrcA), .ALUsrcB(ALUsrcB), .ALUop(ALUop), .PcWrite(PcWrite), .PCWriteCond(PCWriteCond), .SrcReg(SrcReg), 
    .PCsource(PCsource), .RegWrite(RegWrite), .next(next));
    
    //Memory Data Register
    reg32b MDRreg (.clk(clk), .R(1'b0), .WE(1'b1), .D(MDRin), .Q(MDRout));           
    
    //Immediate Generator
    ImmGen immediateGen (.inst(IRout), .imm(ImmOut));    
    
    //Register File
    regfile Registerfile (.clk(clk), .ReadReg1(IRout[19:15]), .ReadReg2(IRout[24:20]), .WriteReg(IRout[11:7]), .WriteData(RegData), 
                          .RegWrite(RegWrite), .ReadData1(Ain), .ReadData2(Bin));        
    
    //register to hold ALU source A
    reg32b A (.clk(clk), .R(1'b0), .WE(1'b1), .D(Ain), .Q(Aout));
    
    //register to hold ALU source B
    reg32b B (.clk(clk), .R(1'b0), .WE(1'b1), .D(Bin), .Q(Bout)); 
            
    //        Execute    
        
    // ALU source A mux         
    always @(*) begin
        if(ALUsrcA)
            src1 = Aout;
        else
            src1 = PCout;
    end     
            
    // ALU source B mux            
    always @(*) begin
        case (ALUsrcB)
            2'b00: src2 = Bout;
            2'b01: src2 = 32'h00000004;
            default: src2 = ImmOut;
        endcase
    end
            
//    //funct3 setter (removed as it was redundant)          
//    funct3Setter setter (.funct3(IRout[14:12]), .PCWriteCond(PCWriteCond), .Setfunct3(funct3));
	 
    //ALU            
    ALUcu alucu(.funct3(IRout[14:12]), .ALUop(ALUop), .funct7b5(IRout[30]), .op(op));
    ALU alu(.src1(src1), .src2(src2), .op(op), .ALUout(ALUoutD), .zero(zero));
    
    //Bracnh Evaluator as sub is done for all branhces, used to extract the right info from sub result
    branchEvaluator beval(.PCWriteCond(PCWriteCond), .funct3(IRout[14:12]), .sign(ALUoutD[31]), .z(zero), .branch(branch));

    //register to hold ALU results
    reg32b ALUoutReg (.clk(clk), .R(1'b0), .WE(1'b1), .D(ALUoutD), .Q(ALUoutQ));    
        
    //   Write Back    
    
    //Register Source mux
    always @(*) begin
        case (SrcReg)
            2'b00: RegData = ALUoutQ;
            2'b01: RegData = MDRout;
            2'b10: RegData = ImmOut;
            2'b11: RegData = PCout;
        endcase    
    end       
        
endmodule
