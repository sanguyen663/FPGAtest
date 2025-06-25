`timescale 1ns / 1ps

module uart_led_controller (
    input i_Clock,          // Clock he thong
    input i_Rx_Serial,      // Du lieu UART vào
    input switch,           // key 4
    output [3:0] o_LED,      // 4 LED dau ra  
    output o_Tx_Serial     // Du lieu serial dau ra
);

    // Khai báo wire cho UART
    wire w_Rx_DV;           // Data valid tu UART
    wire [7:0] w_Rx_Byte;   // Byte nhan dc tu UART
    
    // Register de luu trang thái LED
    reg [3:0] r_LED = 4'b1001;
    
    // Sd module uart_rx
    uart_rx #(.CLKS_PER_BIT(435)) UART_RX_INST (
        .i_Clock(i_Clock),
        .i_Rx_Serial(i_Rx_Serial),
        .o_Rx_DV(w_Rx_DV),
        .o_Rx_Byte(w_Rx_Byte)
    );
  // assign w_Rx_DV = 1; // luon nhan du lieu vao
    // Logic dieu khien LED
    always @(posedge i_Clock) begin
        if (w_Rx_DV) begin  // Khi nhan dc du lieu moi
            case (w_Rx_Byte[1:0])  // Dùng 2 bit thap nhat
                2'b01: r_LED <= 4'b1110;  // LED 1 sáng
                2'b10: r_LED <= 4'b1101;  // LED 2 sáng
                2'b11: r_LED <= 4'b1011;  // LED 3 sáng
                2'b00: r_LED <= 4'b0111;  // LED 4 sáng
                default: r_LED <= 4'b1001; 
            endcase
        end
    end
    
    // Gán dau ra
    assign o_LED = r_LED;
//*****************************************************************************
// Khai báo các wire và reg
    wire w_Tx_Active;       // Trang thái dang truyen (Ko dung cung dc)
    wire w_Tx_Done;         // Hoàn tat truyen 1 byte
    reg  r_Tx_DV = 0;       // Tín hieu Data Valid
    reg [7:0] r_Tx_Byte = 0;// Byte can truyen
    reg [3:0] r_Char_Index = 0; // Chi so ký tu trong chuoi
    reg [1:0] r_State = 0;  // State machine dieu khien
    reg [25:0] counter = 0;     //tao delay 1s
    reg [25:0] dem; // Bien dem chong rung cho switch
    reg [2:0] sel=0,o_sel=0;  //bien chon chuoi ky tu dung switch de dieu khien
    // Chuoi "Xin Chào " (ASCII)
    reg [150:0] STRING ; // 8 ký tu, moi ký tu 8 bit
    reg [3:0] STRING_LEN ;             // Do dài chuoi
    
    // Sd module uart_tx
    uart_tx #(.CLKS_PER_BIT(435)) UART_TX_INST (
        .i_Clock(i_Clock),
        .i_Tx_DV(r_Tx_DV),
        .i_Tx_Byte(r_Tx_Byte),
        .o_Tx_Active(w_Tx_Active),
        .o_Tx_Serial(o_Tx_Serial),
        .o_Tx_Done(w_Tx_Done)
    );
    
    // State machine de truyen liên tuc
    parameter s_START_TX  = 2'b00;
    parameter s_WAIT_TX   = 2'b01;
    parameter s_NEXT_CHAR = 2'b10;
    
    always @(posedge i_Clock) begin
        if(switch) // Neu ko nhan switch (key 4)
            dem <= 0;
        else begin // Neu nhan switch
            if(dem == 26'h7D7840) begin
                dem <= 0;
                if(sel == 0)
                    sel <= 1;
                else if(sel == 1)
                    sel <= 2;
                else
                    sel <= 3'd0;
            end else 
                dem <= dem + 1;
        end
    
        case(sel)
            3'd0: begin
                STRING <= " Xin Chao\n\r"; // 8 ký tu, moi ký tu 8 bit
                STRING_LEN <= 11;
            end
            3'd1: begin
                STRING <= " Nhat Nam\n\r"; // 8 ký tu, moi ký tu 8 bit
                STRING_LEN <= 11;
            end
            3'd2: begin
                STRING <= " TDHCHK58\n\r"; // 8 ký tu, moi ký tu 8 bit
                STRING_LEN <= 11;
            end
            default: begin
                STRING <= " Xin Chao\n\r"; // 8 ký tu, moi ký tu 8 bit
                STRING_LEN <= 11;
            end
        endcase
    
        case (r_State)
            s_START_TX: begin
                // Lay ký tu tu chuoi (truyen tu phai sang trái)
                r_Tx_Byte <= STRING[(STRING_LEN - 1 - r_Char_Index)*8 +: 8];
                r_Tx_DV <= 1;  // Kích hoat truyen
                r_State <= s_WAIT_TX;
            end
            
            s_WAIT_TX: begin
                r_Tx_DV <= 0;  // Tat DV sau 1 chu ki
                if (w_Tx_Done) begin
                    r_State <= s_NEXT_CHAR;
                end
            end
            
            s_NEXT_CHAR: begin
                if (r_Char_Index < STRING_LEN - 1) begin
                    r_Char_Index <= r_Char_Index + 1;
                    r_State <= s_START_TX;
                end else begin
                    counter <= counter + 1;
                    if(counter <= 26'd50000000)
                        if(o_sel != sel) begin      //hien
                            o_sel <= sel;           //m?i
                            r_State <= s_START_TX;  //chuoi
                            r_Char_Index <= 0;      //1
                        end                         //lan
                        else                        //duy
                            r_State <= s_NEXT_CHAR;
                    else begin
                        counter <= 0;
                        r_State <= s_NEXT_CHAR;     //nhat
                      //  r_State <= s_START_TX; //hien lien tuc moi 1s
                      //r_Char_Index <= 0;  // Quay lai dau chuoi
                    end
                end
                
            end
            
            default:
                r_State <= s_START_TX;
        endcase
    end

endmodule