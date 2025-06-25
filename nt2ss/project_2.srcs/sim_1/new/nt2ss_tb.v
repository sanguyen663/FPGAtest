`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2025 08:44:07 AM
// Design Name: 
// Module Name: nt2ss_tb
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


module nt2ss_tb();
reg clk;
reg rst_n;
reg start;
reg sdi;
wire [7:0] shift_reg;
wire finish;

nt2ss uut(
.clk(clk),
.rst_n(rst_n),
.start(start),
.sdi(sdi),
.shift_reg(shift_reg),
.finish(finish)
);

initial begin
clk=1;
forever #5 clk = ~clk;
end

always@(posedge clk) begin
    if(!rst_n) start <= 1;
    else if(finish) start <= 1;
    else  start <=0;
end

  task send_byte(input [7:0] data);
        integer i;
        begin
            start = 1; #10; // Start signal
            start = 0;
            for (i = 0; i < 8; i = i + 1) begin
                sdi = data[i]; // Send LSB first
                #10;
            end
            wait (finish); // Wait for finish signal
            #10;
        end
    endtask
    
    
    initial begin
        // Initialize signals
        clk = 1;
        rst_n = 0;
        start = 0;
        sdi = 0;

        // Reset sequence
        #20 rst_n = 1; // Release reset
        
        // Send three bytes: 0xA5, 0x3C, 0x7F (LSB first)
        send_byte(8'hff);
        $display("Received byte: %h", shift_reg);

        send_byte(8'h00);
        $display("Received byte: %h", shift_reg);

        send_byte(8'hFF);
        $display("Received byte: %h", shift_reg);

        // Finish simulation
        #50;
        $finish;
    end
endmodule
