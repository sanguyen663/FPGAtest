`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 11:08:23 PM
// Design Name: 
// Module Name: SongTamGiac_TB
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


module SongTamGiac_TB(

    );
    
    // dau vào
    reg clk;
    reg rst_n;
    // dau ra
    wire [7:0] sine_out;

    // Khoi tao module
    SongTamGiac uut (
        .clk(clk),
        .rst_n(rst_n),
        .sine_out(sine_out)
    );

    // Tao clock 500MHz (chu ki 2ns)
    initial begin
        clk = 0;
        forever #1 clk = ~clk; // Chu ki 2ns
    end

    // Kich ban kiem tra
    initial begin
        // Reset ban dau
        rst_n = 0;
        #20;
        rst_n = 1;

        // Chay mô phong trong 100 chu ki sin
        #5200; // 10 chu ki sin (256 * 2ns * 100)
        $finish;
    end

    // Ghi ket qua ra file de xem dang sóng
    initial begin
        $dumpfile("sine_wave.vcd");
        $dumpvars(0, SongTamGiac_TB);
    end

endmodule
