package ecc_classes;

class trans;
    rand logic [31:0] address;
    rand logic [31:0] write_data;
    rand logic        mem_read;
    rand logic        mem_write;
    logic [31:0]      read_data;

    constraint rw_c {
        mem_read != mem_write;
    }

    constraint addr_c {
        address[1:0] == 2'b00;
        address[31:10] == 22'h0;
    }
endclass

class generator;
    mailbox gen2drv;
    trans T;

    function new(mailbox gen2drv_arg);
        gen2drv = gen2drv_arg;
    endfunction

    task main(int no_of_inputs);
        for (int i = 0; i < no_of_inputs; i++) begin
            T = new();
            if (!T.randomize()) begin
                $error("Randomization failed in generator");
            end
            gen2drv.put(T);
        end
    endtask
endclass

class driver;
    mailbox gen2drv;
    virtual ecc_interface.driver vif;

    function new(mailbox gen2drv_arg, virtual ecc_interface.driver drv_vif);
        gen2drv = gen2drv_arg;
        vif     = drv_vif;
    endfunction

    task reset();
        vif.address    <= '0;
        vif.write_data <= '0;
        vif.mem_read   <= 1'b0;
        vif.mem_write  <= 1'b0;

        repeat(2) @(posedge vif.clk);

        $display("Reset Completed");
    endtask

    task main(int no_of_inputs);
        for (int i = 0; i < no_of_inputs; i++) begin
            trans T;
            gen2drv.get(T);
            @(negedge vif.clk);
            vif.address    <= T.address;
            vif.write_data <= T.write_data;
            vif.mem_read   <= T.mem_read;
            vif.mem_write  <= T.mem_write;
        end
    endtask
endclass

class monitor;
    mailbox mon2scb;
    virtual ecc_interface.monitor vif;

    function new(mailbox mon2scb_arg, virtual ecc_interface.monitor mon_vif);
        mon2scb = mon2scb_arg;
        vif     = mon_vif;
    endfunction

    task main(int no_of_inputs);
        int count = 0;
        while (count < no_of_inputs) begin
            @(posedge vif.clk);
            #1;
            if (vif.mem_read || vif.mem_write) begin
                trans T = new();
                T.address    = vif.address;
                T.write_data = vif.write_data;
                T.mem_read   = vif.mem_read;
                T.mem_write  = vif.mem_write;
                T.read_data  = vif.read_data;
                mon2scb.put(T);
		#1;
                count++;
            end
        end
    endtask
endclass

class scoreboard;
    logic [31:0] ref_mem [0:255];
    int pass_count = 0;
    int fail_count = 0;
    mailbox mon2scb;

    function new(mailbox mon2scb_arg);
        mon2scb = mon2scb_arg;
        foreach (ref_mem[i]) begin
            ref_mem[i] = '0;
        end
    endfunction

    task main(int no_of_inputs);
        for (int i = 0; i < no_of_inputs; i++) begin
            trans T;
            logic [7:0] idx;
            mon2scb.get(T);
            idx = T.address[9:2];

            if (T.mem_write) begin
                ref_mem[idx] = T.write_data;
            end 
            else if (T.mem_read) begin
                $display("SCOREBOARD: Addr = 0x%0h | Read Data = 0x%0h | Expected Data = 0x%0h", T.address, T.read_data, ref_mem[idx]);
                if (T.read_data === ref_mem[idx]) begin
                    pass_count = pass_count + 1;
                end else begin
                    fail_count = fail_count + 1;
                    $error("SCOREBOARD MISMATCH!");
                end
            end
        end
    endtask

    function void display();
        if (fail_count > 0)
            $display("Simulation Failed - %0d Test cases failed, %0d Passed", fail_count, pass_count);
        else
            $display("Simulation Successful - %0d Test cases Failed and %0d Test cases passed", fail_count, pass_count);
    endfunction
endclass

endpackage