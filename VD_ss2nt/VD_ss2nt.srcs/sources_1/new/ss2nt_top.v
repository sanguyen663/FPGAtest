`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2025 10:14:08 AM
// Design Name: 
// Module Name: ss2nt_top
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


module ss2nt_top( input clk,
    input rst_n,
    output reg  load,
     output sdo
 );
 //chia tan so
 reg [2:0] div_clk;
 always@(posedge clk)
    div_clk <= div_clk +1;
 wire clk_div8;  
assign clk_div8 = div_clk[2]; 
   
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

    reg [7:0] in;
always@(posedge load,negedge rst_n) begin
    if(!rst_n) in <= 0;
    else in <= in +1;
end

ss2nt uut(
.clk(clk_div8),
.rst_n(rst_n),
.load(load),
.in(in),
.sdo(sdo)

);
endmodule
