`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 14:24:19
// Design Name: 
// Module Name: imu_sim
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
/////////////////////////////////////////////////////////////////////////////
module imu_sim #(
    parameter integer WIDTH        = 16,
    parameter signed [WIDTH-1:0] AX_MAX = 16'sd500,
    parameter signed [WIDTH-1:0] AY_MAX = 16'sd800,
    parameter signed [WIDTH-1:0] AZ_BASE= 16'sd1000,
    parameter signed [WIDTH-1:0] AZ_SWING=16'sd200
)(
    input  wire                   clk,
    input  wire                   rst_n,

    output reg  signed [WIDTH-1:0] ax,
    output reg  signed [WIDTH-1:0] ay,
    output reg  signed [WIDTH-1:0] az
);

    // Internal up/down direction flags
    reg dir_x;  // 0 = up, 1 = down
    reg dir_y;
    reg dir_z;

    // Slow down ay and az updates a bit using dividers
    reg [7:0] div_y;
    reg [7:0] div_z;

    localparam signed [WIDTH-1:0] AX_STEP = 16'sd10;
    localparam signed [WIDTH-1:0] AY_STEP = 16'sd5;
    localparam signed [WIDTH-1:0] AZ_STEP = 16'sd4;

    always @(posedge clk) begin
        if (!rst_n) begin
            ax    <= 0;
            ay    <= 0;
            az    <= AZ_BASE;
            dir_x <= 1'b0;
            dir_y <= 1'b0;
            dir_z <= 1'b0;
            div_y <= 0;
            div_z <= 0;
        end else begin
            // -------- X axis: fast triangle --------
            if (!dir_x) begin
                // going up
                if (ax >= AX_MAX)
                    dir_x <= 1'b1;
                else
                    ax <= ax + AX_STEP;
            end else begin
                // going down
                if (ax <= -AX_MAX)
                    dir_x <= 1'b0;
                else
                    ax <= ax - AX_STEP;
            end

            // -------- Y axis: slower triangle --------
            div_y <= div_y + 1'b1;
            if (div_y == 8'd0) begin
                if (!dir_y) begin
                    if (ay >= AY_MAX)
                        dir_y <= 1'b1;
                    else
                        ay <= ay + AY_STEP;
                end else begin
                    if (ay <= -AY_MAX)
                        dir_y <= 1'b0;
                    else
                        ay <= ay - AY_STEP;
                end
            end

            // -------- Z axis: base gravity + wobble --------
            div_z <= div_z + 1'b1;
            if (div_z == 8'd0) begin
                if (!dir_z) begin
                    if (az >= AZ_BASE + AZ_SWING)
                        dir_z <= 1'b1;
                    else
                        az <= az + AZ_STEP;
                end else begin
                    if (az <= AZ_BASE - AZ_SWING)
                        dir_z <= 1'b0;
                    else
                        az <= az - AZ_STEP;
                end
            end
        end
    end

endmodule
