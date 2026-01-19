`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 10:50:03
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_tx #(
    parameter integer CLK_FREQ_HZ = 100_000_000,  // system clock
    parameter integer BAUD_RATE   = 115_200       // target baud
)(
    input  wire       clk,
    input  wire       rst_n,     // active-low synchronous reset
    input  wire       tx_start,  // pulse to start transmission
    input  wire [7:0] tx_data,   // data byte to send
    output reg        tx,        // serial TX line
    output reg        tx_busy    // high while sending
);

    // Number of clock cycles per UART bit
    localparam integer BAUD_DIV = CLK_FREQ_HZ / BAUD_RATE;
    // We send: 1 start + 8 data + 1 stop = 10 bits total
    localparam integer TOTAL_BITS = 10;

    reg [$clog2(BAUD_DIV)-1:0] baud_cnt;
    reg [3:0]                  bit_idx;   // 0..9
    reg [9:0]                  shift_reg; // frame: {stop, data[7:0], start}

    always @(posedge clk) begin
        if (!rst_n) begin
            tx       <= 1'b1;     // idle high
            tx_busy  <= 1'b0;
            baud_cnt <= 0;
            bit_idx  <= 0;
            shift_reg<= 10'b1111111111;
        end else begin
            if (!tx_busy) begin
                // Idle state: wait for tx_start
                tx <= 1'b1;  // line idle
                if (tx_start) begin
                    // Construct frame: start(0) + data bits + stop(1)
                    shift_reg <= {1'b1, tx_data, 1'b0}; // [9]=stop, [0]=start
                    tx_busy   <= 1'b1;
                    baud_cnt  <= 0;
                    bit_idx   <= 0;
                    tx        <= 1'b0;  // send start bit immediately
                end
            end else begin
                // Currently transmitting
                if (baud_cnt == BAUD_DIV-1) begin
                    baud_cnt <= 0;
                    bit_idx  <= bit_idx + 1'b1;

                    if (bit_idx < TOTAL_BITS-1) begin
                        // Shift frame and output next bit
                        shift_reg <= {1'b1, shift_reg[9:1]}; // shift right, fill with 1
                        tx        <= shift_reg[1]; // next bit after current
                    end else begin
                        // Finished sending stop bit
                        tx       <= 1'b1;  // go back to idle
                        tx_busy  <= 1'b0;
                        bit_idx  <= 0;
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1'b1;
                end
            end
        end
    end

endmodule