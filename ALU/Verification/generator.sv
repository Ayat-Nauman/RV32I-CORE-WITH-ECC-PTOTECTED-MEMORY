class generator;
    ex_transaction tr;
    mailbox gen2drv;
    int num_transactions = 5000;
    event gen_done;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        for (int i = 0; i < num_transactions; i++) begin
            tr = new();
            // edge case constraint to check zero flag
            if (!tr.randomize() with {
                // 20% chance that src1 == src2 to test the zero flag (for sub)
                if ($urandom_range(0, 100) < 20) src1 == src2;
            }) $fatal("Randomization failed");
            
            gen2drv.put(tr);
        end
        -> gen_done;
    endtask
endclass