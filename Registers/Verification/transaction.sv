class transaction;
    // reg32b stimulus
    rand bit        r32_R;
    rand bit        r32_WE;
    rand bit [31:0] r32_D;

    // regfile stimulus
    rand bit        rf_RegWrite;
    rand bit [4:0]  rf_WriteReg;
    rand bit [31:0] rf_WriteData;
    rand bit [4:0]  rf_ReadReg1;
    rand bit [4:0]  rf_ReadReg2;

    // captured outputs (filled in by monitor)
    bit [31:0] r32_Q;
    bit [31:0] rf_ReadData1;
    bit [31:0] rf_ReadData2;

    // keep reset rare so we mostly exercise write/hold behaviour
    constraint c_reset { r32_R dist {0 :/ 90, 1 :/ 10}; }

    // bias write-enable / regwrite high so registers actually get loaded
    constraint c_we      { r32_WE      dist {0 :/ 30, 1 :/ 70}; }
    constraint c_regwrite{ rf_RegWrite dist {0 :/ 30, 1 :/ 70}; }

    // occasionally force a same-cycle write/read hazard on the same register
    constraint c_hazard {
        rf_ReadReg1 dist { [0:31] :/ 90, rf_WriteReg :/ 10 };
        rf_ReadReg2 dist { [0:31] :/ 90, rf_WriteReg :/ 10 };
    }

    function void display(string name);
        $display("\n---- %s ----", name);
        $display("r32: R=%0b WE=%0b D=%0h Q=%0h", r32_R, r32_WE, r32_D, r32_Q);
        $display("rf : RegWrite=%0b WriteReg=%0d WriteData=%0h ReadReg1=%0d ReadReg2=%0d -> RD1=%0h RD2=%0h",
                   rf_RegWrite, rf_WriteReg, rf_WriteData, rf_ReadReg1, rf_ReadReg2,
                   rf_ReadData1, rf_ReadData2);
        $display("----------------------");
    endfunction
endclass
