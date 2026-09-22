class generator;
    cu_transaction tr;
    mailbox gen2drv;
    
    int num_valid_tx   = 50;
    int num_invalid_tx = 10;
    
    event gen_done;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
                
        // PHASE 1: Positive Constrained Random Testing
        // the valid_opcodes constraint is active        
        for (int i = 0; i < num_valid_tx; i++) begin
            tr = new();
            if (!tr.randomize()) $fatal("[GENERATOR] Valid Randomization failed");
            gen2drv.put(tr);
        end
                
        // PHASE 2: Negative Random Testing (Invalid Opcodes)        
        for (int i = 0; i < num_invalid_tx; i++) begin
            tr = new();
            
            // turning OFF the default constraint
            tr.valid_opcodes.constraint_mode(0); 
            
            // using an inline constraint to explicitly forbid valid opcodes, guaranteeing we only test the garbage/illegal space.
            if (!tr.randomize() with {
                !(opcode inside {
                    7'b0110011, 7'b0010011, 7'b0000011, 7'b0100011, 
                    7'b1100011, 7'b0110111, 7'b1100111, 7'b1101111, 7'b0010111
                });
            }) $fatal("[GENERATOR] Invalid Randomization failed");
            
            gen2drv.put(tr);
        end
        
        -> gen_done; // signal to the environment that we are done generating
    endtask
endclass