module reg32b(
    input clk,
    input R,
    input WE,
    input [31:0] D,
    output reg [31:0] Q
    );
    
    initial Q = 32'h00000000; // non synthesizable should be removed
       
    always @(posedge clk) begin
        if (R)
            Q <= 32'h0000000;
        else if (WE)
            Q <= D;
    end
endmodule
