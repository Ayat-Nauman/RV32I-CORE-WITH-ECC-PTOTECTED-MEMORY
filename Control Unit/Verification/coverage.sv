class coverage_collector;
    cu_transaction tr;
    mailbox mon2cov;

    // Covergroup to track which opcodes the DUT actually processed
    covergroup cg_cu_opcodes;
        option.per_instance = 1;

        cp_opcode: coverpoint tr.opcode {
            bins r_type = {7'b0110011};
            bins i_type = {7'b0010011};
            bins lw     = {7'b0000011};
            bins sw     = {7'b0100011};
            bins branch = {7'b1100011};
            bins lui    = {7'b0110111};
            bins jalr   = {7'b1100111};
            bins jal    = {7'b1101111};
            bins auipc  = {7'b0010111};
            
            // tracking all other opcodes values as invalid negative tests
            bins invalid_opcode = default;
        }
    endgroup

    function new(mailbox mon2cov);
        this.mon2cov = mon2cov;
        cg_cu_opcodes = new();
    endfunction

    task run();
        forever begin
            mon2cov.get(tr);
            
            // We only want to sample coverage ONCE per instruction
            // State 2 (Decode) happens exactly once per instruction lifecycle
            if (tr.state == 4'd2) begin
                cg_cu_opcodes.sample();
            end
        end
    endtask
endclass