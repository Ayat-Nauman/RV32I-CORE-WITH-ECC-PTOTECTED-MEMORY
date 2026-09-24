class scoreboard;
    mailbox drv2scb;
    mailbox mon2scb;

    int pass, fail;

    transaction exp_q[$];
    transaction act_q[$];

    function new(mailbox drv2scb, mailbox mon2scb);
        this.drv2scb = drv2scb;
        this.mon2scb = mon2scb;
        pass = 0;
        fail = 0;
    endfunction

    task compare();
        if (exp_q.size() > 0 && act_q.size() > 0) begin
            transaction e = exp_q.pop_front();
            transaction a = act_q.pop_front();

            if ((e.tx_data == a.rx_data) && (a.error_flag == 0)) begin
                pass++;
                $display("[PASS] sent = %0h, received = %0h", e.tx_data, a.rx_data);
            end else begin
                fail++;
                $display("[FAIL] sent = %0h, received = %0h, error_flag = %0b",
                          e.tx_data, a.rx_data, a.error_flag);
            end
            $display("Pass cases = %0d, Fail cases = %0d", pass, fail);
        end
    endtask

    task run();
        fork
            forever begin
                transaction tr;
                drv2scb.get(tr);
                exp_q.push_back(tr);
                compare();
            end
            forever begin
                transaction tr;
                mon2scb.get(tr);
                act_q.push_back(tr);
                compare();
            end
        join_none
    endtask
endclass
