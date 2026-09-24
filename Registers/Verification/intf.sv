interface reg_intf (input logic clk);
    // reg32b signals
    logic        r32_R;
    logic        r32_WE;
    logic [31:0] r32_D;
    logic [31:0] r32_Q;

    // regfile signals
    logic        rf_RegWrite;
    logic [4:0]  rf_WriteReg;
    logic [31:0] rf_WriteData;
    logic [4:0]  rf_ReadReg1;
    logic [4:0]  rf_ReadReg2;
    logic [31:0] rf_ReadData1;
    logic [31:0] rf_ReadData2;
endinterface
