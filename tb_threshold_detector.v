`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 19:07:40
// Design Name: 
// Module Name: tb_threshold_detector
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
`timescale 1ns/1ps

module tb_threshold_detector;

    localparam WIDTH = 16;

    reg                    clk;
    reg                    rst_n;
    reg  signed [WIDTH-1:0] sample_in;
    reg  signed [WIDTH-1:0] threshold;
    wire                   event_flag;

    // DUT (Device Under Test)
    threshold_detector #(
        .WIDTH(WIDTH)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .sample_in (sample_in),
        .threshold (threshold),
        .event_flag(event_flag)
    );

    // Clock: 100 MHz (10 ns period)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        // Initial values
        rst_n     = 1'b0;
        sample_in = 0;
        threshold = 100;  // set threshold to 100
        #30;              // wait a bit with reset low

        rst_n = 1'b1;     // release reset

        // Samples below threshold
        apply_sample(50);
        apply_sample(99);

        // Samples above threshold
        apply_sample(101);
        apply_sample(150);

        // Back below
        apply_sample(80);

        #50;
        $display("[TB] Simulation finished");
        $finish;
    end

    // Task to apply a sample and print result
    task apply_sample(input signed [WIDTH-1:0] val);
    begin
        sample_in = val;
        @(posedge clk); // wait for one clock edge
        #1;             // small delay for event_flag to update
        $display("[TB] sample_in=%0d threshold=%0d event_flag=%0b",
                  sample_in, threshold, event_flag);
    end
    endtask

endmodule