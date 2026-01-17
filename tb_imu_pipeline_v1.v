`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 21:01:33
// Design Name: 
// Module Name: tb_imu_pipeline_v1
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

module tb_imu_pipeline_v1;

    // Same width, but small MAX/THRESH for easier viewing in simulation
    localparam WIDTH           = 16;
    localparam MAX_VALUE_TB    = 16'd10;   // counter wraps at 10
    localparam THRESHOLD_TB    = 16'sd5;   // event when sample_out > 5

    reg                  clk;
    reg                  rst_n;
    wire [WIDTH-1:0]     sample_out;
    wire                 event_flag;

    // -------------------------------------------------------------------------
    // DUT: top_v1
    // -------------------------------------------------------------------------
    top_v1 #(
        .WIDTH          (WIDTH),
        .MAX_VALUE      (MAX_VALUE_TB),
        .THRESHOLD_VALUE(THRESHOLD_TB)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .sample_out (sample_out),
        .event_flag (event_flag)
    );

    // -------------------------------------------------------------------------
    // Clock generation: 100 MHz (10 ns period)
    // -------------------------------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // -------------------------------------------------------------------------
    // Stimulus: reset + run for a while
    // -------------------------------------------------------------------------
    initial begin
        // Start in reset
        rst_n = 1'b0;
        #30;              // hold reset for 30 ns

        // Release reset
        rst_n = 1'b1;

        // Let the pipeline run for some cycles
        repeat (30) begin
            @(posedge clk);
            #1;
            $display("[TB] sample_out=%0d  threshold=%0d  event_flag=%0b",
                     sample_out, THRESHOLD_TB, event_flag);
        end

        $display("[TB] V1 pipeline simulation finished");
        $finish;
    end

endmodule
