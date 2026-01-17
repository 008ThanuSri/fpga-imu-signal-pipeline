`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 19:55:50
// Design Name: 
// Module Name: counter_imu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple synthetic IMU-style source for V1. Generates a ramping sample value
//   that increases every clock cycle until it hits MAX_VALUE, then wraps to 0.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module counter_imu #(
    parameter WIDTH     = 16,         // Bit-width of the counter/sample
    parameter MAX_VALUE = 16'd500     // Max value before wrapping
)(
    input  wire                 clk,
    input  wire                 rst_n,      // active-low synchronous reset
    output reg  [WIDTH-1:0]     sample_out  // synthetic "IMU" sample
);

    always @(posedge clk) begin
        if (!rst_n) begin
            sample_out <= {WIDTH{1'b0}};    // reset to 0
        end else begin
            if (sample_out >= MAX_VALUE)
                sample_out <= {WIDTH{1'b0}}; // wrap back to 0
            else
                sample_out <= sample_out + 1'b1;
        end
    end

endmodule
