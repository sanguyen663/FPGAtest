`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 11:40:33 AM
// Design Name: 
// Module Name: ss2nt
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


module ss2nt(
    input clk,
    input rst_n,
    input  load,
    input  [7:0] in,
    output  sdo
    );
    reg [7:0] shift_reg;
    reg tx_en;
    reg [2:0] counter;
       
       //serial output
       assign sdo = shift_reg[0];
         // txt_en
    always @ (posedge clk) begin
    if(!rst_n) tx_en <= 0;
    else if(load) tx_en <= 1;
    else if(counter[2:0] == 3'd7) tx_en <= 0;
    end
      //counter
    always @ (posedge clk) begin
    if(!rst_n) counter[2:0] <= 3'd0;
    else if(load) counter[2:0] <= 3'd0;
    else if(tx_en) counter[2:0] <= counter[2:0] + 1'b1;
    end
  
  
    //trasmit & shift data
    always @ (posedge clk) begin
    if(!rst_n) begin
    shift_reg[7:0] <= 8'd0;
    end
    else if(load) shift_reg[7:0] <= in[7:0];
    else if(tx_en) begin
     shift_reg[7:0] <= {1'b0,shift_reg[7:1]};
     end
    end
endmodule
