`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 08:04:38 AM
// Design Name: 
// Module Name: led7_tb
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


module led7_tb();
    reg [3:0] in;
    wire [6:0] out;
    
    led7 uut(
    .in(in),
    .out(out)
    );
    
    initial begin
        $monitor("in = %b , out = %b",in,out);
        in = 0;
        #10 in = 3;
        #10 in = 6;
        #10 in = 7;
        #10 in = 9;
        #10 in = 10;
        #10 in = 12;
        #10 in = 14;
        #10 in = 15;
        #10 $finish;
    end
endmodule
