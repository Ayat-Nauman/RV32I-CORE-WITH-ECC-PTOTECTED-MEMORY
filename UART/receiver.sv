
module receiver (
    input  logic clk, rst, rx,
    output logic rx_done, error_flag,
    output logic [7:0] rx_data
);

parameter clkdiv = 3;

logic [6:0] baud_counter;
logic [3:0] bit_counter; 
logic [10:0] rx_buffer;  // 1 start + 8 data + 1 parity + 1 stop
logic error;

typedef enum logic {IDLE, RECEIVING} transition_states;
transition_states state;

always_ff @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= IDLE;
        bit_counter <= 0;
        baud_counter <= 0;
        rx_done <= 1'b0;
        error_flag <= 1'b0;
        rx_data <= 8'b0;
        rx_buffer <= 0;
    end else begin
        case (state) 
            IDLE: begin
                rx_done <= 1'b0;
                error_flag <= 1'b0;
                baud_counter <= 0;
                bit_counter <= 0;
                if (!rx) begin
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == clkdiv - 1) begin
                        state <= RECEIVING;
                        baud_counter <= 0;
                    end
                end
            end

            RECEIVING: begin
                baud_counter <= baud_counter + 1;
                if (baud_counter == clkdiv - 1) begin
                    baud_counter <= 0;
                    bit_counter <= bit_counter + 1;
                    rx_buffer <= {rx, rx_buffer[10:1]};
                end
                
                // After receiving 11 bits (0..10)
                if (bit_counter == 10) begin
                    rx_done <= 1'b1;
                    rx_data <= rx_buffer[8:1]; // 8 data bits
                    if (~^rx_buffer[8:1] == rx_buffer[9])
                        error_flag <= 1'b0;
                    else
                        error_flag <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule


