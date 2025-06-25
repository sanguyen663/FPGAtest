`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 02:54:40 PM
// Design Name: 
// Module Name: i2c_master_tb
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

module i2c_master_tb;

    // Inputs
    reg clk;
    reg reset;
    reg start;
    reg [6:0] addr;
    reg [7:0] data;
    reg rw;
    
    // Bidirectional
    wire sda;
    
    // Outputs
    wire scl;
    wire done;
    
    // Internal signals
    reg sda_driver;
    reg sda_oe;
    
    // SDA tristate control
    assign sda = sda_oe ? sda_driver : 1'bz;
    
    // Instantiate the Unit Under Test (UUT)
    i2c_master uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .addr(addr),
        .data(data),
        .rw(rw),
        .sda(sda),
        .scl(scl),
        .done(done)
    );
    
    // Clock generation: 50MHz (20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize Inputs
        reset = 1;
        start = 0;
        addr = 7'h00;
        data = 8'h00;
        rw = 0;
        sda_driver = 1;
        sda_oe = 0;
        
        // Reset
        #100;
        reset = 0;
        
        // Test Case 1: Write operation
        #100;
        addr = 7'h55;     // I2C address
        data = 8'hAA;     // Data to write
        rw = 0;           // Write operation
        start = 1;        // Start transaction
        #40;
        start = 0;
        
        // Simulate slave ACK for address
        @(negedge scl);
        repeat(250) @(posedge clk); // Wait for address phase
        sda_oe = 1;
        sda_driver = 0;   // ACK
        @(posedge scl);
        @(negedge scl);
        sda_oe = 0;
        
        // Simulate slave ACK for data
        repeat(250) @(posedge clk); // Wait for data phase
        sda_oe = 1;
        sda_driver = 0;   // ACK
        @(posedge scl);
        @(negedge scl);
        sda_oe = 0;
        
        // Wait for transaction to complete
        @(posedge done);
        
        // Test Case 2: Read operation
        #1000;
        addr = 7'h2A;     // I2C address
        data = 8'h00;     // Dummy data
        rw = 1;           // Read operation
        start = 1;        // Start transaction
        #40;
        start = 0;
        
        // Simulate slave ACK for address
        @(negedge scl);
        repeat(250) @(posedge clk); // Wait for address phase
        sda_oe = 1;
        sda_driver = 0;   // ACK
        @(posedge scl);
        @(negedge scl);
        sda_oe = 0;
        
        // Simulate slave sending data (0x5A)
        repeat(250) @(posedge clk); // Wait for data phase
        sda_oe = 1;
        sda_driver = 0;   // Bit 7
        @(posedge scl);
        @(negedge scl);
        sda_driver = 1;   // Bit 6
        @(posedge scl);
        @(negedge scl);
        sda_driver = 0;   // Bit 5
        @(posedge scl);
        @(negedge scl);
        sda_driver = 1;   // Bit 4
        @(posedge scl);
        @(negedge scl);
        sda_driver = 1;   // Bit 3
        @(posedge scl);
        @(negedge scl);
        sda_driver = 0;   // Bit 2
        @(posedge scl);
        @(negedge scl);
        sda_driver = 1;   // Bit 1
        @(posedge scl);
        @(negedge scl);
        sda_driver = 0;   // Bit 0
        @(posedge scl);
        @(negedge scl);
        sda_oe = 0;
        
        // Wait for transaction to complete
        @(posedge done);
        
        // End simulation
        #1000;
        $finish;
    end
    
    // Monitor signals
    initial begin
        $monitor("Time=%0t, state=%0d, scl=%b, sda=%b, done=%b", 
                 $time, uut.state, scl, sda, done);
    end
    
    // Dump variables for waveform viewing
    initial begin
        $dumpfile("i2c_master_tb.vcd");
        $dumpvars(0, i2c_master_tb);
    end

endmodule
