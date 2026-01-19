`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 12:12:41
// Design Name: 
// Module Name: tb_uart_tx
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

module tb_uart_tx;

    // For simulation: pretend clk is 1.84 MHz so that BAUD_DIV = 16
    // 1_840_000 / 115_200 = 16
    localparam integer SIM_CLK_FREQ_HZ = 1_840_000;
    localparam integer BAUD_RATE       = 115_200;

    reg        clk;
    reg        rst_n;
    reg        tx_start;
    reg [7:0]  tx_data;
    wire       tx;
    wire       tx_busy;

    // DUT
    uart_tx #(
        .CLK_FREQ_HZ(SIM_CLK_FREQ_HZ),
        .BAUD_RATE  (BAUD_RATE)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),
        .tx_busy  (tx_busy)
    );

    // Clock: not 100MHz now; period chosen arbitrarily for sim
    initial clk = 1'b0;
    always #10 clk = ~clk;  // 50 kHz clock in sim (period 20 ns)

    initial begin
        rst_n    = 1'b0;
        tx_start = 1'b0;
        tx_data  = 8'h00;

        #100;
        rst_n = 1'b1;

        // Wait a little after reset
        #100;

        // Send one byte: ASCII 'A' = 0x41 = 0100_0001
        tx_data  = 8'h41;
        tx_start = 1'b1;
        @(posedge clk);
        tx_start = 1'b0;

        // Wait while frame transmits
        wait (!tx_busy);   // block until done

        // Send a second byte: 0x5A
        #200;
        tx_data  = 8'h5A;
        tx_start = 1'b1;
        @(posedge clk);
        tx_start = 1'b0;

        wait (!tx_busy);

        #200;
        $display("[TB] UART TX test finished");
        $finish;
    end

endmodule
