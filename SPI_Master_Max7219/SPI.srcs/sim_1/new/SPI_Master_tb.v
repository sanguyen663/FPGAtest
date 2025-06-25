`timescale 1ns / 1ps

module spi_master_tb;

    // Testbench signals
    reg clk;                  // System clock
    reg rst_n;                // Active low reset
   // reg start;                // Start transmission
   // reg [15:0] data_in;        // 8-bit data to transmit
   // reg miso;                 // Master In Slave Out
    wire sclk;                // SPI clock
    wire mosi;                // Master Out Slave In
    wire cs_n;                // Chip Select (active low)
   // wire [7:0] rx_data;       // Received data

    // Instantiate the SPI Master
    spi_master uut (
        .clk(clk),
        .rst_n(rst_n),
    //    .start(start),
    //    .data_in(data_in),
     //   .miso(miso),
        .sclk(sclk),
        .mosi(mosi),
        .cs_n(cs_n)
      //  .rx_data(rx_data)
    );

    // Clock generation (50 MHz, 20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Simulate MISO data from slave
//    reg [7:0] slave_data;//gia su gia tri slave truyen
 //   integer bit_index;   // bien dem nhan bit

    // Test stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
    //    start = 0;
   //     data_in = 8'h00;
      //  miso = 0;
 //       slave_data = 8'h00;

        // Reset the system
        #100;
        rst_n = 1;

        // Test case 1: Send 0xA5, Receive 0x5A
        #100;
     //   data_in = 16'h33A5;
    //    slave_data = 8'h5A;
     //   start = 1;
        #20;
    //    start = 0;

        // Simulate MISO data
    //    bit_index = 7;
       /* forever begin
            @(posedge sclk or negedge cs_n);
            if (!cs_n && bit_index >= 0) begin
                miso = slave_data[bit_index];
                bit_index = bit_index - 1;
                start = 0;
            end
            else if (cs_n) begin
                miso = 0;
                bit_index = 7;
            end
        end */
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t rst_n=%b sclk=%b mosi=%b cs_n=%b ",
                 $time, rst_n, sclk, mosi, cs_n);
    end

    // Dump waveform
    initial begin
        $dumpfile("spi_master_tb.vcd");
        $dumpvars(0, spi_master_tb);
    end

    // Stop simulation after sufficient time
    initial begin
        #5000;
        $display("Simulation completed!");
        $finish;
    end

endmodule