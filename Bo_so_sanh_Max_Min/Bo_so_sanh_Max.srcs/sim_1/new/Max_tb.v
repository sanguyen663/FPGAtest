`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 02:28:49 PM
// Design Name: 
// Module Name: Max_tb
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


module Max_tb();
reg [7:0] a;
reg [7:0] b;
reg [7:0] c;
reg [7:0] d;
wire [7:0] max4;
wire [7:0] min4;

max uut (
.a(a),
.b(b),
.c(c),
.d(d),
.max4(max4),
.min4(min4)
);

initial begin
    a=8'h12;b=8'h53;c=8'hab;d=8'h4f;
  //  $display("%b | %b | %b | %b | %b | %b",a,b,c,d,max4,min4);
    #10 a=8'ha2;b=8'h51;c=8'haf;d=8'hcf;
    #10 a=8'h1b;b=8'hc3;c=8'h6b;d=8'h3f;
    #10 a=8'h99;b=8'h14;c=8'h34;d=8'h49;
    #10 a=8'h96;b=8'hf4;c=8'h35;d=8'h19;
    #10 $finish;
end

endmodule
