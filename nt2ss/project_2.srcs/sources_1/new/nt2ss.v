`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 08:28:29 AM
// Design Name: 
// Module Name: nt2ss
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


module nt2ss(
    input clk,
    input rst_n,
    input start,
    input sdi,
    output reg [7:0] shift_reg,
    output reg finish
    );
    reg rx_en;
    reg [2:0] counter;
    reg [7:0] shift_reg_0;
    //rx_en
    always @ (posedge clk) begin
    if (!rst_n)rx_en <= 0;
    else if(start) rx_en <= 1;
    else if (counter == 7) rx_en <= 0;
    end
    
    //counter
    always @ (posedge clk) begin
    if (!rst_n)counter [2:0] <= 0;
    else if(start) counter [2:0] <= 0;
    else if (rx_en) counter [2:0] <= counter [2:0] + 1;
    end
    
    //finish
    always @ (posedge clk) begin
    if (!rst_n)finish <= 0;
    else if(counter[2:0] == 7) finish <= 1;
    else finish <=0;
    end
    
    //receive & shift data
    always @ (posedge clk)  begin
    if (!rst_n) begin 
    shift_reg <= 0;
    shift_reg_0 <=0;
    end
    
    else if(finish) begin
    shift_reg <= 0;
    shift_reg_0 <= 0;
    end
    
    else if (counter[2:0] == 7) shift_reg <= {sdi,shift_reg_0[7:1]};
    else if (rx_en || start) shift_reg_0 <= {sdi,shift_reg_0[7:1]};
    end
endmodule
