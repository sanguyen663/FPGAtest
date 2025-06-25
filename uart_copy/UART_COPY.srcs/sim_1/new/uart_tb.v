`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 09:59:51 AM
// Design Name: 
// Module Name: tb_uart_rx
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

`timescale 1ns/1ps

module uart_rx_tb;

    // Tham s? baud rate và clock
    parameter CLOCK_PERIOD = 20; // 10MHz clock (100ns period)
    parameter BAUD_RATE = 115200;
    parameter BIT_PERIOD = 50_000_000 / BAUD_RATE; // ns per bit
    
    reg clk;
  
    reg rx;
    wire [7:0] data_out;
    wire valid;
    
    // Instantiate the UART RX module
    uart_rx uut (
        .i_Clock(clk),
//        .rst(rst),
        .i_Rx_Serial(rx),
        .o_Rx_DV (valid),
        .o_Rx_Byte(data_out)
    );
    
    // Clock generation
    always #(CLOCK_PERIOD/2) clk = ~clk;
    
    // Task to send a byte over UART
    task send_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0; // Start bit
            #(BIT_PERIOD);
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end
            rx = 1; // Stop bit
            #(BIT_PERIOD);
        end
    endtask
    
    initial begin
        // Initialize signals
        clk = 0;
 //       rst = 1;
        rx = 1; // Idle state
        
        // Reset sequence
        #100;
 //       rst = 0;
 //       #100;
        
        // Send test bytes
        send_byte(8'h55); // 0b01010101
        #100000;
        send_byte(8'hA3); // 0b10100011
        #100000;
        
        // End simulation
        #100000;
        $stop;
    end

endmodule

