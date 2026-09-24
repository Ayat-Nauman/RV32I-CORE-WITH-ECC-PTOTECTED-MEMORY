`include "environment.sv"

program test (reg_intf vif);
    environment env;

    initial begin
        env = new(vif);
        env.run();
    end
endprogram
