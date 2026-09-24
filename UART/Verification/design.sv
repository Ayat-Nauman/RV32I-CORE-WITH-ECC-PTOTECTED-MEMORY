module transmitter (
    input  logic clk, rst, tx_start,
    input  logic [7:0] tx_data,
    output logic tx_done, tx
);

parameter clkdiv = 3;

typedef enum logic {IDLE, TRANSMITTING} transition_states;
transition_states state;

logic [3:0] bit_counter;
logic [6:0] baud_counter;
logic [10:0] tx_buffer;
logic parity;

assign parity = ~^tx_data[7:0];

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        state    <= IDLE;
        tx_done  <= 0;
        tx       <= 1;
    end else begin
        case (state)
            IDLE: begin
                tx      <= 1;
                tx_done <= 0;
                if (tx_start) begin
                    state       <= TRANSMITTING;
                    bit_counter <= 0;
                    baud_counter<= 0;
                    tx_buffer   <= {1'b1, parity, tx_data, 1'b0};
                end
            end

            TRANSMITTING: begin
                tx <= tx_buffer[0];
                baud_counter <= baud_counter + 1;
                if (baud_counter == clkdiv) begin
                    baud_counter <= 0;
                    bit_counter  <= bit_counter + 1;
                    tx_buffer    <= {1'b0, tx_buffer[10:1]};
                    if (bit_counter == 10) begin
                        tx_done <= 1;
                        state   <= IDLE;
                    end
                end
            end
        endcase
    end
end

endmodule


module receiver (
    input  logic clk, rst, rx,
    output logic rx_done, error_flag,
    output logic [7:0] rx_data
);

parameter clkdiv = 3;

logic [6:0] baud_counter;
logic [3:0] bit_counter;
logic [10:0] rx_buffer;
logic error;

typedef enum logic {IDLE, RECEIVING} transition_states;
transition_states state;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        state       <= IDLE;
        bit_counter <= 0;
        baud_counter<= 0;
        rx_done     <= 1'b0;
        error_flag  <= 1'b0;
        rx_data     <= 8'b0;
        rx_buffer   <= 0;
    end else begin
        case (state)
            IDLE: begin
                rx_done     <= 1'b0;
                error_flag  <= 1'b0;
                baud_counter<= 0;
                bit_counter <= 0;
                if (!rx) begin
                    baud_counter <= baud_counter + 1;
                    if (baud_counter == clkdiv) begin
                        state       <= RECEIVING;
                        baud_counter<= 0;
                    end
                end
            end

            RECEIVING: begin
                baud_counter <= baud_counter + 1;
                if (baud_counter == clkdiv) begin
                    baud_counter <= 0;
                    bit_counter  <= bit_counter + 1;
                    rx_buffer    <= {rx, rx_buffer[10:1]};
                end

                if (bit_counter == 10) begin
                    rx_done <= 1'b1;
                    rx_data <= rx_buffer[8:1];
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


module uart(
    input logic clk,
    input logic rst,     //Asynchronous Active low reset
    input logic tx_start,
    input logic [7:0] tx_data,
    input logic rx,
    output logic tx,
    output logic rx_done,
    output logic tx_done,
    output logic [7:0] rx_data,
    output logic error_flag
);

// Transmit data from transmitter to receiver
transmitter dut1(
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_done(tx_done),
    .tx(tx)
);

receiver dut2(
    .clk(clk),
    .rst(rst),
    .rx_done(rx_done),
    .error_flag(error_flag),
    .rx_data(rx_data),
    .rx(rx)
);

endmodule
