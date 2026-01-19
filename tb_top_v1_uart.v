`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 13:32:35
// Design Name: 
// Module Name: tb_top_v1_uart
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


module tb_top_v1_uart;

    localparam integer WIDTH        = 16;
    localparam integer CLK_FREQ_HZ  = 1_840_000;   // must match DUT param
    localparam integer BAUD_RATE    = 115_200;
    localparam [WIDTH-1:0] MAX_VAL  = 16'd10;
    localparam signed [WIDTH-1:0] THR = 16'sd5;

    reg                  clk;
    reg                  rst_n;
    wire                 tx;
    wire [WIDTH-1:0]     sample_mon;
    wire                 event_mon;

    // -------------------------------------------------------------------------
    // DUT: top_v1_uart
    // -------------------------------------------------------------------------
    top_v1_uart #(
        .WIDTH          (WIDTH),
        .CLK_FREQ_HZ    (CLK_FREQ_HZ),
        .BAUD_RATE      (BAUD_RATE),
        .MAX_VALUE      (MAX_VAL),
        .THRESHOLD_VALUE(THR)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .tx        (tx),
        .sample_mon(sample_mon),
        .event_mon (event_mon)
    );

    // -------------------------------------------------------------------------
    // Clock generation: arbitrary, just consistent with CLK_FREQ_HZ parameter
    // -------------------------------------------------------------------------
    initial clk = 1'b0;
    always #10 clk = ~clk;   // 20 ns period

    // -------------------------------------------------------------------------
    // Stimulus
    // -------------------------------------------------------------------------
    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;

        // Let the system run for some time
        #200_000;  // 200 us of simulation

        $display("[TB] top_v1_uart simulation finished at time %0t", $time);
        $finish;
    end

    // Optional: print whenever an event is detected
    always @(posedge event_mon) begin
        $display("[TB] EVENT: time=%0t sample=%0d", $time, sample_mon);
    end

endmodule