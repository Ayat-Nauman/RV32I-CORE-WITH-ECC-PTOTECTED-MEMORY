module ram_256x16A ( // mimics the lib module
    input CLK, 
    input CEN, // active low chip select
    input WEN, // active low write enable
    input [7:0] A,
    input [15:0] D,
    output reg [15:0] Q
);

    reg [15:0] mem [0:255];

    always @(posedge CLK) begin
        if (~CEN) begin
            if(~WEN)
                mem[A] <= D;
            
            Q <= mem[A];
        end
    end
    
endmodule
