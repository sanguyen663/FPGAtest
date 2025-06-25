`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 10:46:11 PM
// Design Name: 
// Module Name: SongTamGiac
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


module SongTamGiac(
    input wire clk,          // Clock ??u vào
    input wire rst_n,//key 1        // Reset active-low
    input down, // key 3
    input up,    // key 2
    output reg [7:0] sine_out // Tín hi?u sin ??u ra (8-bit)
);
//cai dat nut up (key 2)
reg [25:0] counter_up;// Dem counter_up chong rung khi nhan up (key2)
always @(posedge clk) begin
    if(!rst_n) begin
        counter_up <= 26'd0;
    end
    else begin
        if(up)  // Neu ko nhan up (key 2)
            counter_up <= 0;
        
        else begin // Neu nhan up
            if(counter_up == 26'h4D7840) 
                counter_up <= 0;
            else 
                counter_up <= counter_up + 1;
        end
    end    
end
//cai dat nut down (key 3)
reg [25:0] counter_down;// Dem counter_down chong rung khi nhan down (key 3)
always @(posedge clk) begin
    if(!rst_n) begin
        counter_down <= 26'd0;
    end
    else begin
        if(down)  // Neu ko nhan up (key 2)
            counter_down <= 0;
        
        else begin // Neu nhan up
            if(counter_down == 26'h4D7840) 
                counter_down <= 0;
            else 
                counter_down <= counter_down + 1;
        end
    end    
end

    reg [7:0] phase; // B? ??m pha (index cho LUT)
    
    // B? ??m pha ?? truy c?p LUT
    reg [15:0] clk_div,counter;
always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 16'd10; // Giá tr? kh?i t?o h?p lý
    end else begin
        if (counter_up == 26'h4D7840) begin
            if (counter > 1)// Gioi han tan so toi thieu 
                counter <= counter - 1; // Tang tan so
        end else if (counter_down == 26'h4D7840) begin
            if (counter < 5000) // Gioi han tan so toi da
                counter <= counter + 1; // Giam tan so
        end
    end
end
    
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
        phase <= 0;
       // sine_out <= 8'd0;
    end
    else begin
        clk_div <= clk_div + 1;
        if (clk_div == counter) begin
            clk_div <= 0; 
            phase <= phase + 1;  
          //  sine_out <= sine_table[phase]; // Truy c?p tr?c ti?p LUT
            if(phase <= 128) begin
                sine_out <= phase;
            end
            else if (phase < 255) begin
                sine_out <=  8'd255  - phase + 8'd1;
            end
            else begin
                sine_out <=  8'd255 - phase + 8'd1;
                phase <= 0;
            end
        end
    end
end
endmodule
