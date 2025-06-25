`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/10/2025 09:10:50 AM
// Design Name: 
// Module Name: nt2ss_top
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


module nt2ss_top(
    input clk,
    input rst_n,
    output reg load,
    output sdo
    );

     //chia tan so
 reg [2:0] div_clk;
 always@(posedge clk)
    div_clk <= div_clk +1;
 wire clk_div8;  
assign clk_div8 = div_clk[2]; 

//dung ss2nt de tao dau vao cho nt2ss
reg [7:0] in;
ss2nt chuyen_nt(
.clk(clk_div8),
.rst_n(rst_n),
.load(load),
.in(in),
.sdo(sdo)
);

//goi ham su dung chinh
  wire finish;
 wire [7:0]  parallel_data;
reg sdi;
nt2ss uut(
.clk(clk_div8),
.rst_n(rst_n),
.start(load),
.sdi(sdo),
.shift_reg(parallel_data),
.finish(finish)
);

ila_0 my_ila(
.clk(clk),
.probe0(load),
.probe1(sdo),
.probe2(finish),
.probe3(in),
.probe4(parallel_data)
);

//thiet lap load
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

//tao dau vao cho ss2nt
always@(posedge load,negedge rst_n) begin
    if(!rst_n) in <= 0;
    else in <= in +1;
end

endmodule
