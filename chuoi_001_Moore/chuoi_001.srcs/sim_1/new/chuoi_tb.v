`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 11:35:36 AM
// Design Name: 
// Module Name: chuoi_tb
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


module chuoi_tb();
reg clk;
reg rst_n;
reg s_in;
wire valid;

chuoi uut(
.clk(clk),
.rst_n(rst_n),
.s_in(s_in),
.valid(valid)
);

initial begin
    clk=1;
    forever #5 clk=~clk;
end

initial begin
    rst_n = 0;s_in = 0;
    #10 rst_n = 1;
     $display("%4t | %b | %b | %b | %b",$time,clk,rst_n,s_in,valid);
    #15 s_in = 1;
     $display("%4t | %b | %b | %b | %b",$time,clk,rst_n,s_in,valid);
    #20 s_in = 0;
     $display("%4t | %b | %b | %b | %b",$time,clk,rst_n,s_in,valid);
    #15 s_in = 1;
    $display("%4t | %b | %b | %b | %b",$time,clk,rst_n,s_in,valid);
    #20 $finish;
end
endmodule
