`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2025 09:29:14 AM
// Design Name: 
// Module Name: chuoi_1011
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


module chuoi_1011(
    input clk,
    input rst_n,
    input s_in,
    output reg valid
    );
    reg [2:0] next_state,current_state;
    parameter IDLE = 3'd0;
    parameter D1 = 3'd1;
    parameter D10 = 3'd2;
    parameter D101 = 3'd3;
    parameter D1011 = 3'd4;
    
    always @ (*) begin
    case(current_state[2:0])
        IDLE: begin
                if(s_in) next_state [2:0] = D1;
                else      next_state [2:0] = current_state[2:0];
              end
        D1: begin
                if(~s_in) next_state [2:0] = D10;
                else      next_state [2:0] = current_state[2:0];
            end
        D10: begin
                if(s_in) next_state [2:0] = D101;
                else      next_state [2:0] = IDLE;
             end
        D101: begin
                if(s_in) next_state [2:0] = D1011;
                else      next_state [2:0] = D10;
              end
         D1011: begin
                if(s_in) next_state [2:0] = D1;
                else      next_state [2:0] = IDLE;
              end
        default: next_state [2:0] = IDLE;
      endcase
    end
    
        
always@ (posedge clk, negedge rst_n) begin
    if(~rst_n) current_state[2:0] <= IDLE;
    else  current_state[2:0] <= next_state[2:0];
end

always @ (*) begin
    if(current_state[2:0] == D1011)
        valid = 1;
    else
        valid = 0;
end
endmodule
