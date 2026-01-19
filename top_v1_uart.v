`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 13:16:12
// Design Name: 
// Module Name: top_v1_uart
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

module top_v1_uart #(
    parameter integer WIDTH           = 16,
    // These two are used for UART timing
    parameter integer CLK_FREQ_HZ     = 1_840_000,  // matches SIM clock setting
    parameter integer BAUD_RATE       = 115_200,
    // Pipeline parameters
    parameter [WIDTH-1:0] MAX_VALUE   = 16'd10,     // small for sim
    parameter signed [WIDTH-1:0] THRESHOLD_VALUE = 16'sd5
)(
    input  wire                 clk,
    input  wire                 rst_n,       // active-low synchronous reset

    output wire                 tx,          // UART TX line

    // Monitoring signals (for waveforms / debug)
    output wire [WIDTH-1:0]     sample_mon,
    output wire                 event_mon
);

    // -------------------------------------------------------------------------
    // V1 IMU pipeline: counter_imu -> threshold_detector (top_v1)
    // -------------------------------------------------------------------------
    wire [WIDTH-1:0] sample_out;
    wire             event_flag;

    top_v1 #(
        .WIDTH          (WIDTH),
        .MAX_VALUE      (MAX_VALUE),
        .THRESHOLD_VALUE(THRESHOLD_VALUE)
    ) u_top_v1 (
        .clk        (clk),
        .rst_n      (rst_n),
        .sample_out (sample_out),
        .event_flag (event_flag)
    );

    assign sample_mon = sample_out;
    assign event_mon  = event_flag;

    // -------------------------------------------------------------------------
    // UART transmitter
    // -------------------------------------------------------------------------
    wire       tx_busy;
    reg        tx_start;
    reg [7:0]  tx_data;

    uart_tx #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE  (BAUD_RATE)
    ) u_uart_tx (
        .clk      (clk),
        .rst_n    (rst_n),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),
        .tx_busy  (tx_busy)
    );

    // -------------------------------------------------------------------------
    // Simple packet FSM: sends 0xAA, LSB, MSB, flags
    // -------------------------------------------------------------------------
    localparam S_IDLE   = 3'd0;
    localparam S_HDR    = 3'd1;
    localparam S_LSB    = 3'd2;
    localparam S_MSB    = 3'd3;
    localparam S_FLAGS  = 3'd4;

    reg [2:0]          state;
    reg [WIDTH-1:0]    sample_latched;
    reg                event_latched;

    always @(posedge clk) begin
        if (!rst_n) begin
            state          <= S_IDLE;
            tx_start       <= 1'b0;
            tx_data        <= 8'h00;
            sample_latched <= {WIDTH{1'b0}};
            event_latched  <= 1'b0;
        end else begin
            // default each cycle
            tx_start <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (!tx_busy) begin
                        // latch current IMU sample + flag
                        sample_latched <= sample_out;
                        event_latched  <= event_flag;

                        tx_data  <= 8'hAA;    // header
                        tx_start <= 1'b1;
                        state    <= S_HDR;
                    end
                end

                S_HDR: begin
                    if (!tx_busy) begin
                        tx_data  <= sample_latched[7:0];   // LSB
                        tx_start <= 1'b1;
                        state    <= S_LSB;
                    end
                end

                S_LSB: begin
                    if (!tx_busy) begin
                        tx_data  <= sample_latched[15:8];  // MSB
                        tx_start <= 1'b1;
                        state    <= S_MSB;
                    end
                end

                S_MSB: begin
                    if (!tx_busy) begin
                        tx_data  <= {7'b0, event_latched}; // flags byte
                        tx_start <= 1'b1;
                        state    <= S_FLAGS;
                    end
                end

                S_FLAGS: begin
                    if (!tx_busy) begin
                        state <= S_IDLE; // next packet
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule