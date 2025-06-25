`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 11:04:21 PM
// Design Name: 
// Module Name: top
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


module top(
    input wire clk,
    input wire rst_n,
    input down, // key 3
    input up    // key 2
);
    wire [7:0] sine_out;

    // Kh?i t?o module t?o tín hi?u sin
    SongTamGiac TamGiac_gen (
        .clk(clk),
        .rst_n(rst_n),
        .sine_out(sine_out),
        .down(down),
        .up(up)
    );

    // Kh?i t?o ILA
    ila_0 ila_inst (
        .clk(clk),           // Clock c?a ILA (cùng clock v?i thi?t k?)
        .probe0(sine_out)    // Tín hi?u c?n quan sát
    );
endmodule
