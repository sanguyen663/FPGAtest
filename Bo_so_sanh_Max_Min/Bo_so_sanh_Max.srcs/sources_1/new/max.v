`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 02:17:13 PM
// Design Name: 
// Module Name: max
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


module max(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] max4,
    output [7:0] min4
    );
    
function [7:0] max2;
    input [7:0] x1;
    input [7:0] x2;
    max2 = (x1 > x2) ? x1 : x2;
endfunction

function [7:0] min2;
    input [7:0] x1;
    input [7:0] x2;
    min2 = (x1 < x2) ? x1 : x2;
endfunction

wire [7:0] m1,m2,m3,m4;

assign m1 = max2(a,b);
assign m2 = max2(c,d);
assign max4=max2(m1,m2);

assign m3 = min2(a,b);
assign m4 = min2(c,d);
assign min4=min2(m3,m4);

endmodule
