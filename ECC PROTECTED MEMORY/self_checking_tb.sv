`timescale 1ns/1ps

module self_checking_tb;

    logic        clk;
    logic [31:0] address;
    logic [31:0] write_data;
    logic        mem_read;
    logic        mem_write;
    logic [31:0] read_data;

    int pass_count = 0;
    int fail_count = 0;

    ecc_memory uut (
        .clk        (clk),
        .address    (address),
        .write_data (write_data),
        .mem_read   (mem_read),
        .mem_write  (mem_write),
        .read_data  (read_data)
    );

    always #5 clk = ~clk;

    task automatic check_data(input [31:0] expected);
        if (read_data === expected) begin
            pass_count++;
        end else begin
            fail_count++;
            $error("Mismatch: Expected = %h, Got = %h", expected, read_data);
        end
    endtask

    initial begin
        clk = 1'b0;
        address = '0;
        write_data = '0;
        mem_read = 1'b0;
        mem_write = 1'b0;

        // Test 1: Write and Read 32'h1234_5678 at Addr 0x0
        #10;
        address = 32'h0000_0000;
        write_data = 32'h1234_5678;
        mem_write = 1'b1;
        #10;
        mem_write = 1'b0;
        #10;
        mem_read = 1'b1;
        #10;
        check_data(32'h1234_5678);
        mem_read = 1'b0;

        // Test 2: Write and Read 32'hA5A5_A5A5 at Addr 0x4
        #10;
        address = 32'h0000_0004;
        write_data = 32'hA5A5_A5A5;
        mem_write = 1'b1;
        #10;
        mem_write = 1'b0;
        #10;
        mem_read = 1'b1;
        #10;
        check_data(32'hA5A5_A5A5);
        mem_read = 1'b0;

        // Test 3: Write 32'hFFFF_FFFF at Addr 0x8, Inject 1-bit Error, Correct Read
        #10;
        address = 32'h0000_0008;
        write_data = 32'hFFFF_FFFF;
        mem_write = 1'b1;
        #10;
        mem_write = 1'b0;
        #10;
        force uut.memory_unit.ram[2][5] = ~uut.memory_unit.ram[2][5];
        #1;
        release uut.memory_unit.ram[2][5];
        #10;
        mem_read = 1'b1;
        #10;
        check_data(32'hFFFF_FFFF);
        mem_read = 1'b0;

        // Test 4: Write and Read 32'h0000_0000 at Addr 0xC
        #10;
        address = 32'h0000_000C;
        write_data = 32'h0000_0000;
        mem_write = 1'b1;
        #10;
        mem_write = 1'b0;
        #10;
        mem_read = 1'b1;
        #10;
        check_data(32'h0000_0000);
        mem_read = 1'b0;

        // Test 5: Write 32'hCAFE_BABE at Addr 0x10, Inject 1-bit Error, Correct Read
        #10;
        address = 32'h0000_0010;
        write_data = 32'hCAFE_BABE;
        mem_write = 1'b1;
        #10;
        mem_write = 1'b0;
        #10;
        force uut.memory_unit.ram[4][20] = ~uut.memory_unit.ram[4][20];
        #1;
        release uut.memory_unit.ram[4][20];
        #10;
        mem_read = 1'b1;
        #10;
        check_data(32'hCAFE_BABE);
        mem_read = 1'b0;

        #10;
        $display("PASS: %0d | FAIL: %0d", pass_count, fail_count);
        $finish;
    end

endmodule
