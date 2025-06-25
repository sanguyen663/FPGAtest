`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 09:24:01 AM
// Design Name: 
// Module Name: SPI_Master
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


module spi_master (
    input rst_n, // key RESET
    input mode, // key 3-tu tang len
    input up,    // key 2
    input switch,// key 4
    input wire clk,           // System clock
   // input wire start,         // Start transmission
    //input wire [15:0] data_in, // 16-bit data to transmit
    //input wire miso,
    output reg sclk,              // SPI clock
    output reg led_4,
    output reg led_2,
    output reg led_3,
    output reg mosi,          // Master Out Slave In
    output reg cs_n          // Chip Select (active low)
   // output reg [7:0] rx_data
);

//****************************************************************************************
    reg [5:0] bit_cnt;        // Dem bit da chuyen
    reg [15:0] shift_reg;      // thanh ghi dich
    reg start;
    reg [15:0] data_in[12:0];
    reg [3:0] stt;
    
    initial begin
    data_in[0]  =  16'h0f00;// Tat Display Test
    data_in[1]  =  16'h09ff;// Bat giai ma BCD
    data_in[2]  =  16'h0a0f;// Ðo sang toi da
    data_in[3]  =  16'h0b07;// Hien thi 8 chu so
    data_in[4]  =  16'h0c01;// Thoat che do Shutdown
    data_in[5]  =  16'h0801; // hien so 0 o vi tri 8 dem tu ben phai 
    data_in[6]  =  16'h0709; // hien so 1 o vi tri 7 dem tu ben phai
    data_in[7]  =  16'h0600; // hien so 0 o vi tri 6 dem tu ben phai
    data_in[8]  =  16'h0505; // hien so 5 o vi tri 5 dem tu ben phai
    data_in[9]  =  16'h0402; // hien so 2 o vi tri 4 dem tu ben phai
    data_in[10] =  16'h0300; // hien so 0 o vi tri 3 dem tu ben phai
    data_in[11] =  16'h0202; // hien so 2 o vi tri 2 dem tu ben phai
    data_in[12] =  16'h0105; // hien so 5 o vi tri 1 dem tu ben phai
  end

//****************************************************************************************
 reg [3:0] vitri  ;
reg [3:0] i ;

//cai dat nut mode
reg s_mode;
reg [1:0] state, next_state;
reg [25:0] counter_mode; // Bien dem cho switch
reg [27:0] counter_time;
/* always @(posedge clk) begin
    if(!rst_n) begin
        counter_mode <= 26'd0;
        s_mode <= 0;
        led_3 <= 1;
        state <= 0;
        next_state <= 0;
        i <= 12;
    end
    else begin
        if(mode) // Neu ko nhan model (key 3)
            counter_mode <= 0;
        else begin // Neu nhan model
            if(counter_mode == 26'h5D7840)begin
                counter_mode <= 0;
                s_mode <= ~s_mode;
                led_3 <= ~led_3;
            end
            else 
                counter_mode <= counter_mode + 1;
        end
        if(s_mode)begin
            if(counter_time == 28'h2FAF080) begin // cho 1s
                counter_time <= 0 ;
                state <= next_state;
                case (state)
                    0: begin
                        i <= 12;
                        if (data_in[i][3:0] != 9)
                            next_state <= 1;
                        else 
                            next_state <= 2;
                    end
                    1: begin
                        data_in[i][3:0] <= data_in[i][3:0] + 1;
                        next_state <= 0;
                    end
                    2: begin
                        data_in[i][3:0] <= 0;
                        i <= i - 1;
                        if (i <= 5) 
                            next_state <= 0;
                        else if (data_in[i-1][3:0] != 9) 
                            next_state <= 1;
                        else 
                            next_state <= 2;
                    end
                endcase

            end
            else
                counter_time <= counter_time + 1;
        end
        else
            counter_time <= 0 ;
    end 
        
end
*/
 //cai dat nut switch

reg [25:0] counter_switch;// Dem counter_down chong rung khi nhan switch (key4)
always @(posedge clk) begin
    
    if(!rst_n ) begin
        counter_switch <= 26'd0;
        vitri <= 12;
        led_4 <= 1;
    end
    else begin
        if(switch)  // Neu ko nhan switch (key 4)
            counter_switch <= 0;
        
        else begin // Neu nhan switch
            if(counter_switch == 26'h5D7840) begin
                led_4 <= ~led_4;
                counter_switch <= 0;
                vitri <= vitri - 1 ;
                if(vitri <= 5)
                    vitri <= 12;
            end
            else 
                counter_switch <= counter_switch + 1;
        end
    end    
end
 
//cai dat nut up

reg [25:0] counter_up;// Dem counter_up chong rung khi nhan up (key2)
always @(posedge clk) begin
    
    if(!rst_n ) begin
        counter_up <= 26'd0;
        led_2 <= 1;
    end
    else begin
        if(up)  // Neu ko nhan up (key 2)
            counter_up <= 0;
        
        else begin // Neu nhan up
            if(counter_up == 26'h5D7840) begin
                counter_up <= 0;
                led_2 <= ~led_2;
                if(data_in[vitri][3:0] != 9)
                    data_in[vitri][3:0] <= data_in[vitri][3:0] + 1;
                else
                    data_in[vitri][3:0] <= 0;
            end
            else 
                counter_up <= counter_up + 1;
        end
    end    
end



 //****************************************************************************************
   
    always @(posedge clk or negedge rst_n) begin
  
       if(!rst_n) begin
            cs_n <= 1;
            sclk <= 0;
            bit_cnt <= 0;
            stt <= 0;
            start <= 1;
       end
       
       else begin
           if(start && cs_n) begin
                cs_n <= 0; 
                start <= 0;
                shift_reg <= data_in[stt];
           end
           
           else  begin  
              bit_cnt <= bit_cnt + 1;
              
              if(bit_cnt[0] == 0)begin //dung bien dem de dk sclk va mosi
                  sclk <= 0;
                    mosi <= shift_reg[15];
                    shift_reg <= {shift_reg[14:0],shift_reg[15]};
              end
                 
              if(bit_cnt[0] == 1)begin
                    sclk <= 1; 
              end
              
              if(bit_cnt == 32) begin // reset bien dem
                    cs_n <= 1;
                    sclk <= 0;
                    bit_cnt <= 0;
                    start <= 1;
                    if(stt<12)begin
                        stt <= stt +1;    
                    end
                    else
                        stt <= 0;
              end
           end
       end
    end
//****************************************************************************************
/*reg [3:0] rx_cnt;
reg rx_data_1;
reg [7:0] shift_data;
always @(negedge sclk or posedge cs_n) begin
    if(cs_n) begin
        rx_cnt <= 0;
        rx_data_1 <= 0; // kt da nhan du hay chua
        shift_data <= 0;
    end
        
    else begin
        shift_data <= {shift_data[6:0],miso};
        rx_cnt <= rx_cnt + 1;
        if(rx_cnt == 7)
            rx_data_1 <= 1;
        
    end
end

always @ (posedge clk) begin
    if( rx_data_1 == 1 )
            rx_data <= shift_data;
end
*/
endmodule
