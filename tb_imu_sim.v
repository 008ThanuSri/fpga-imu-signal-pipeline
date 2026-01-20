`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 14:25:33
// Design Name: 
// Module Name: tb_imu_sim
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

module tb_imu_sim;

    localparam WIDTH = 16;

    reg  clk;
    reg  rst_n;
    wire signed [WIDTH-1:0] ax;
    wire signed [WIDTH-1:0] ay;
    wire signed [WIDTH-1:0] az;

    imu_sim #(
        .WIDTH   (WIDTH)
    ) dut (
        .clk (clk),
        .rst_n(rst_n),
        .ax (ax),
        .ay (ay),
        .az (az)
    );

    // simple clock
    initial clk = 1'b0;
    always #10 clk = ~clk;   // 20 ns period

    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;

        // run for some time to see patterns
        #200_000;

        $display("[TB] imu_sim finished at t=%0t", $time);
        $finish;
    end

endmodule