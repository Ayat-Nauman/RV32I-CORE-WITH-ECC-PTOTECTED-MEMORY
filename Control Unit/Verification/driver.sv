class driver;
    virtual cu_intf vif;
    mailbox gen2drv;

    function new(virtual cu_intf vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    function string get_opcode_name(bit [6:0] opc);
        case(opc)
            7'b0110011: return "R-Type";
            7'b0010011: return "I-Type";
            7'b0000011: return "LW";
            7'b0100011: return "SW";
            7'b1100011: return "Branch";
            7'b0110111: return "LUI";
            7'b1100111: return "JALR";
            7'b1101111: return "JAL";
            7'b0010111: return "AUIPC";
            default:    return "INVALID/GARBAGE";
        endcase
    endfunction
    
    task reset();
        vif.opcode <= 7'b0000000;
        wait(vif.stateReg == 4'd0); // Wait until FSM is naturally in State 0
    endtask

    task run();
        cu_transaction tr;
        forever begin
            gen2drv.get(tr);
            
            // the IR latches the memory at the end of State 1.
            // So we apply the new opcode exactly when entering State 2.
            wait(vif.stateReg == 4'd1);
            @(posedge vif.clk); 
            vif.opcode <= tr.opcode; // Opcode is now active for this instruction
                        
            $display("[DRIVER] Injecting Instruction: %7b (%s)", tr.opcode, get_opcode_name(tr.opcode));
            
            // Waiting for the instruction to complete (FSM returns to 0)
            wait(vif.stateReg != 4'd0);
            wait(vif.stateReg == 4'd0);
        end
    endtask
endclass