`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 19:04:26
// Design Name: 
// Module Name: threshold_detector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//   Compares an input sample against a programmable threshold and asserts
//   an event flag when the sample exceeds the threshold.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module threshold_detector #(
    parameter WIDTH = 16          // Bit-width of the sample and threshold
)(
    input  wire                     clk,        // Clock
    input  wire                     rst_n,      // Active-low synchronous reset
    input  wire signed [WIDTH-1:0]  sample_in,  // Current sample
    input  wire signed [WIDTH-1:0]  threshold,  // Threshold value
    output reg                      event_flag  // 1 when sample_in > threshold
);

    // Runs on every rising edge of the clock
    always @(posedge clk) begin
        if (!rst_n) begin
            // On reset, clear the flag
            event_flag <= 1'b0;
        end else begin
            // Compare sample_in and threshold
            if (sample_in > threshold)
                event_flag <= 1'b1;
            else
                event_flag <= 1'b0;
        end
    end

endmodule

    
