`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 21:00:32
// Design Name: 
// Module Name: top_v1
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


module top_v1 #(
    parameter WIDTH           = 16,         // Bit-width for samples
    parameter MAX_VALUE       = 16'd500,    // Max synthetic IMU value (wrap point)
    parameter THRESHOLD_VALUE = 16'sd100    // Event threshold
)(
    input  wire                 clk,
    input  wire                 rst_n,         // active-low synchronous reset

    output wire [WIDTH-1:0]     sample_out,    // synthetic IMU sample (from counter)
    output wire                 event_flag     // 1 when sample_out > threshold
);

    // Internal signal from counter_imu to threshold_detector
    wire [WIDTH-1:0] sample_internal;

    // -------------------------------------------------------------------------
    // Synthetic IMU-style source: simple ramp that wraps at MAX_VALUE
    // -------------------------------------------------------------------------
    counter_imu #(
        .WIDTH    (WIDTH),
        .MAX_VALUE(MAX_VALUE)
    ) u_counter_imu (
        .clk        (clk),
        .rst_n      (rst_n),
        .sample_out (sample_internal)
    );

    // -------------------------------------------------------------------------
    // Threshold detector: raises event_flag when sample exceeds THRESHOLD_VALUE
    // -------------------------------------------------------------------------
    threshold_detector #(
        .WIDTH(WIDTH)
    ) u_threshold_detector (
        .clk       (clk),
        .rst_n     (rst_n),
        .sample_in (sample_internal),
        .threshold (THRESHOLD_VALUE),
        .event_flag(event_flag)
    );

    // Expose sample_internal to the outside as sample_out for observation
    assign sample_out = sample_internal;

endmodule
