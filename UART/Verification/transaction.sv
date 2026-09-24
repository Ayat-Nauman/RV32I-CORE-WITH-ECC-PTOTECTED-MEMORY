class transaction;
    rand bit       tx_start;
    rand bit [7:0] tx_data;

    bit tx_done;
    bit rx_done;
    bit error_flag;
    bit [7:0] rx_data;

    function void display(string name);
        $display("\n---- %s ----", name);
        $display("tx_start   = %0b", tx_start);
        $display("tx_data    = %0h", tx_data);
        $display("rx_data    = %0h", rx_data);
        $display("rx_done    = %0b", rx_done);
        $display("error_flag = %0b", error_flag);
        $display("----------------------");
    endfunction
endclass
