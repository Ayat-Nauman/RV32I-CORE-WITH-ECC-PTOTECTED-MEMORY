module mem_map_decoder (
    input  wire        clk,
    input  wire        rst,       // Active-low reset     
    input  wire [31:0] Address,
    input  wire [31:0] WriteData,
    input  wire        MemRead,
    input  wire        MemWrite,
    output reg  [31:0] ReadData,  

    // External UART pins
    input  wire        rx,
    output wire        tx
);

    // Memory Map Definitions
    localparam UART_STATUS_ADDR = 32'h00000400;
    localparam UART_DATA_ADDR   = 32'h00000404;

    // Address Decoding logic
    wire is_uart_status = (Address == UART_STATUS_ADDR);
    wire is_uart_data   = (Address == UART_DATA_ADDR);
    wire is_mem         = (Address < 32'h00000400); 

    // UART Interconnect Signals
    wire       uart_tx_done;
    wire       uart_rx_done;
    wire [7:0] uart_rx_data;
    wire       uart_error;
    
    // Memory Interconnect Signals
    wire [31:0] mem_read_data;

    // CPU Write Edge Detection
    reg mem_write_prev;
    always @(posedge clk or negedge rst) begin
        if (!rst)
            mem_write_prev <= 1'b0;
        else
            mem_write_prev <= MemWrite;
    end
    
    wire cpu_write_pulse = is_uart_data & MemWrite & ~mem_write_prev;

    // TRANSMIT (Tx) PATH: 32-bit to 4x 8-bit Serialization
    reg        tx_busy;
    reg [31:0] tx_buffer;
    reg [1:0]  tx_byte_count;
    reg        tx_state;          // 0 = IDLE, 1 = TRANSMITTING
    reg        uart_tx_start_reg;

    wire [7:0] uart_tx_data  = tx_buffer[7:0]; // always transmit the lowest byte (little endian)
    wire       uart_tx_start = uart_tx_start_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            tx_state          <= 1'b0;
            tx_busy           <= 1'b0;
            tx_byte_count     <= 2'b00;
            tx_buffer         <= 32'd0;
            uart_tx_start_reg <= 1'b0;
        end else begin
            // default to no start pulse (forces 1-cycle pulses)
            uart_tx_start_reg <= 1'b0;

            case (tx_state)
                1'b0: begin // IDLE STATE
                    if (cpu_write_pulse && !tx_busy) begin
                        tx_buffer         <= WriteData;
                        tx_byte_count     <= 2'b00;
                        tx_busy           <= 1'b1;
                        uart_tx_start_reg <= 1'b1; // trigger 1st byte
                        tx_state          <= 1'b1;
                    end
                end
                
                1'b1: begin // TRANSMITTING STATE
                    if (uart_tx_done) begin
                        if (tx_byte_count == 2'b11) begin
                            // all 4 bytes sent
                            tx_busy  <= 1'b0;
                            tx_state <= 1'b0;
                        end else begin
                            // shift right by 8 bits to expose the next byte
                            tx_buffer         <= {8'h00, tx_buffer[31:8]};
                            tx_byte_count     <= tx_byte_count + 1'b1;
                            uart_tx_start_reg <= 1'b1; // trigger next byte
                        end
                    end
                end
            endcase
        end
    end
	 
    // RECEIVE (Rx) PATH: 4x 8-bit to 32-bit Deserialization
    reg        rx_ready;
    reg [31:0] rx_buffer;
    reg [1:0]  rx_byte_count;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            rx_ready      <= 1'b0;
            rx_byte_count <= 2'b00;
            rx_buffer     <= 32'd0;
        end else begin
            // clear flag when CPU reads the data
            if (is_uart_data && MemRead) begin
                rx_ready <= 1'b0;
            end
            
            // shift data in when UART finishes a byte
            if (uart_rx_done) begin
                // shift newest byte to the MSB, move older bytes down
                rx_buffer <= {uart_rx_data, rx_buffer[31:8]};
                
                if (rx_byte_count == 2'b11) begin
                    rx_ready      <= 1'b1;   // 4 bytes assembled, alert CPU
                    rx_byte_count <= 2'b00;  // reset counter for next word
                end else begin
                    rx_byte_count <= rx_byte_count + 1'b1;
                end
            end
        end
    end

    // Read Multiplexer (Routing Data to CPU)
    always @(*) begin
        if (is_uart_status && MemRead) begin
            ReadData = {30'b0, tx_busy, rx_ready};
        end else if (is_uart_data && MemRead) begin
            ReadData = rx_buffer;
        end else begin
            ReadData = mem_read_data;
        end
    end
    
    wire mem_actual_write = MemWrite & is_mem;
    wire mem_actual_read  = MemRead & is_mem;

    memoryv2 main_memory (
        .clk       (clk),
        .Address   (Address),
        .WriteData (WriteData),
        .MemRead   (mem_actual_read),
        .MemWrite  (mem_actual_write),
        .Data      (mem_read_data)
    );
    
    uart uart_peripheral (
        .clk        (clk),
        .rst        (rst),
        .tx_start   (uart_tx_start),
        .tx_data    (uart_tx_data),
        .rx         (rx),
        .tx         (tx),
        .rx_done    (uart_rx_done),
        .tx_done    (uart_tx_done),
        .rx_data    (uart_rx_data),
        .error_flag (uart_error)
    );

endmodule