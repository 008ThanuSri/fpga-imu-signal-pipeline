`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.01.2026 19:57:29
// Design Name: 
// Module Name: tb_counter_imu
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

module tb_counter_imu;

    localparam WIDTH     = 16;
    localparam MAX_VALUE = 16'd10;  // small for easier viewing in sim

    reg                  clk;
    reg                  rst_n;
    wire [WIDTH-1:0]     sample_out;

    // DUT instance
    counter_imu #(
        .WIDTH(WIDTH),
        .MAX_VALUE(MAX_VALUE)
    ) dut (
        .clk        (clk),
        .rst_n      (rst_n),
        .sample_out (sample_out)
    );

    // Clock: 10 ns period (100 MHz)
    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        // Initial reset
        rst_n = 1'b0;
        #30;
        rst_n = 1'b1;

        // Let the counter run for a while
        repeat (25) begin
            @(posedge clk);
            #1;
            $display("[TB] sample_out = %0d", sample_out);
        end

        $display("[TB] Simulation finished");
        $finish;
    end

endmodule