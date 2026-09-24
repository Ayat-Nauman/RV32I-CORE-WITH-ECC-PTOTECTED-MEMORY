`include "intf.sv"
`include "test.sv"

module top_tb();

    bit clk;

    reg_intf vif(clk);
    test tst(vif);

    reg32b dut1(
        .clk(vif.clk),
        .R(vif.r32_R),
        .WE(vif.r32_WE),
        .D(vif.r32_D),
        .Q(vif.r32_Q)
    );

    regfile dut2(
        .clk(vif.clk),
        .ReadReg1(vif.rf_ReadReg1),
        .ReadReg2(vif.rf_ReadReg2),
        .WriteReg(vif.rf_WriteReg),
        .WriteData(vif.rf_WriteData),
        .RegWrite(vif.rf_RegWrite),
        .ReadData1(vif.rf_ReadData1),
        .ReadData2(vif.rf_ReadData2)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, top_tb);
    end

endmodule
