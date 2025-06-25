`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 03:45:49 PM
// Design Name: 
// Module Name: ss2nt_tb
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


module ss2nt_tb();
    reg clk;
    reg rst_n;
    reg load;
    reg [7:0] in;
    wire sdo;

ss2nt uut(
.clk(clk),
.rst_n(rst_n),
.load(load),
.in(in),
.sdo(sdo)

);

initial begin
clk=1;
forever #5 clk=~clk;//ck=10
end

reg [3:0] count;
always@(posedge clk) begin
    if(!rst_n) begin 
    count[3:0]<=0;
    load <= 0;
    end
    else begin
        count <= count +1;
        if(count==8)
            count <= 0;
        if(count==0)
            load <=1;
        else
            load <=0;
    end
end

always@(posedge load,negedge rst_n) begin
    if(!rst_n) in <= 0;
    else in <= in +1;
end

initial begin
rst_n = 0;
#10 rst_n = 1;
$display("$time | %d | %d | %d | %d",clk,rst_n,load,in,sdo);
/*#10 load = 0; in=8'b0;
$display("$time | %d | %d | %d | %d | %d | %d",clk,rst_n,load,tx_en,in,counter,sdo);
#80 in= 8'b11100010;load = 1;
$display("$time | %d | %d | %d | %d | %d | %d",clk,rst_n,load,tx_en,in,counter,sdo);
#10 load = 0; in=8'b0;
$display("$time | %d | %d | %d | %d | %d | %d",clk,rst_n,load,tx_en,in,counter,sdo);
#80 in= 8'b11011011;load = 1;
$display("$time | %d | %d | %d | %d | %d | %d",clk,rst_n,load,tx_en,in,counter,sdo);
#10 load = 0; in=8'b0;
$display("$time | %d | %d | %d | %d | %d | %d",clk,rst_n,load,tx_en,in,counter,sdo);
*/
#270 $finish;
end
endmodule
