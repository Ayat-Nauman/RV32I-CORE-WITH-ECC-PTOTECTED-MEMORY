class generator;
    transaction tr;
    mailbox gen2drv;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task run();
        repeat (25) begin
            tr = new();
            tr.tx_start = 1;
            tr.randomize();
            gen2drv.put(tr);
            tr.display("generator");
        end
    endtask
endclass
