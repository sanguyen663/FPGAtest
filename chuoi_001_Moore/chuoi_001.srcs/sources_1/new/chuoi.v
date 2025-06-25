`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2025 11:12:50 AM
// Design Name: 
// Module Name: chuoi
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

//vd4.36
module chuoi(
    input clk,
    input rst_n,
    input s_in,
    output reg valid
    );
    reg [1:0] next_state,current_state;
    parameter IDLE = 2'd0;
    parameter D0 = 2'd1;
    parameter D00 = 2'd2;
    parameter D001 = 2'd3;
    
    always @ (*) begin
    case(current_state[1:0])
        IDLE: begin
                if(~s_in) next_state [1:0] = D0;
                else      next_state [1:0] = current_state[1:0];
              end
        D0: begin
                if(~s_in) next_state [1:0] = D00;
                else      next_state [1:0] = IDLE;
            end
        D00: begin
                if(s_in) next_state [1:0] = D001;
                else      next_state [1:0] = current_state[1:0];
             end
        D001: begin
                if(s_in) next_state [1:0] = IDLE;
                else      next_state [1:0] = D0;
              end
        default: next_state [1:0] = IDLE;
      endcase
    end
    
always@ (posedge clk, negedge rst_n) begin
    if(~rst_n) current_state[1:0] <= IDLE;
    else  current_state[1:0] <= next_state[1:0];
end

always @ (*) begin
    if(current_state[1:0] == D001)
        valid = 1;
    else
        valid = 0;
end

endmodule
