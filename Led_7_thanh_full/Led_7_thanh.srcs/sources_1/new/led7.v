`timescale 1ns / 1ps
module led7( 
    input clk,
    input rst_n, // key reset
    input mode, // key 3
    input up,    // key 2
    input switch,// key 4
    output reg [5:0] s_led,
    output reg [6:0] out,
    output reg dp
);
//cai dat nut mode
reg s_mode;
reg [25:0] counter_mode; // Bien dem cho switch
always @(posedge clk) begin
    if(!rst_n) begin
        counter_mode <= 26'd0;
    end
    else begin
        if(mode) // Neu ko nhan model (key 3)
            counter_mode <= 0;
        else begin // Neu nhan model
            if(counter_mode == 26'h7D7840)
                counter_mode <= 0;
            else 
                counter_mode <= counter_mode + 1;
        end 
    end
end
// Chon che do mode
always @(posedge clk) begin
    if(!rst_n)
        s_mode <= 1'b0;
    else begin
        if(counter_mode == 26'h7D7840)
            s_mode = s_mode +1'b1;
    end
end

// Mang luu giá tri cua 6 LED
reg [3:0] in_values [5:0]; // 6 bit BCD cho 6 LED ( tu 0 den f )

reg [2:0] sel;  //bien chon led dung switch de dieu khien

reg [25:0] counter_up;// Dem counter_up chong rung khi nhan up (key2)
always @(posedge clk) begin
    if(!rst_n || s_mode) begin
        counter_up <= 26'd0;
    end
    else begin
        if(up)  // Neu ko nhan up (key 2)
            counter_up <= 0;
        
        else begin // Neu nhan up
            if(counter_up == 26'h7D7840) 
                counter_up <= 0;
            else 
                counter_up <= counter_up + 1;
        end
    end    
end

reg [26:0] counter_time; // bien dem che do mode 1 (dong ho)
always @(posedge clk) begin
    if(!rst_n || !s_mode) begin
        counter_time <= 27'd0;
    end
    
    else begin
        if(counter_time == 27'h2faf080) //moi chu ki 20ns
              counter_time <= 0;
        else
              counter_time <= counter_time + 1;
    end  
end
//***********************************************************************************
//dieu chinh gia tri led
always @(posedge clk) begin
    if(!rst_n) begin
        in_values[0] <= 4'd0; // Gia tri ban dau
        in_values[1] <= 4'd0;
        in_values[2] <= 4'd0;
        in_values[3] <= 4'd0;
        in_values[4] <= 4'd0;
        in_values[5] <= 4'd0;
    end
//***********************************************************************************
//mode 0 : (dat gio) gioi han thay doi gia tri   
    else if(! s_mode) begin
      if(sel==0||sel==2) begin
        if(counter_up == 26'h7D7840 ) begin
            if(in_values[sel]<9)
                 in_values[sel] <= in_values[sel] + 1; // Tang giá tri LED dc chon
            else
                 in_values[sel] <= 4'd0;
        end
      end
      
     else if (sel ==1||sel==3) begin
        if(counter_up == 26'h7D7840) begin
             if(in_values[sel] < 4'h5)
               in_values[sel] <= in_values[sel] + 1; // Tang giá tri LED dc chon
             else
               in_values[sel] <= 4'd0; 
        end   
     end
      
     else if (sel == 5) begin
        if(counter_up == 26'h7D7840) begin
            if( in_values[4] < 4'h4) begin
                if(in_values[sel]<2)
                   in_values[sel] <= in_values[sel] + 1; // Tang giá tri LED dc chon
                else
                   in_values[sel] <= 4'd0;
            end 
            
            else begin  
             if(in_values[sel]<1)
                   in_values[sel] <= in_values[sel] + 1; // Tang giá tri LED dc chon
                else
                   in_values[sel] <= 4'd0;
            end
         end
      end
      
      else begin//4
          if(counter_up == 26'h7D7840) begin
                if( in_values[5]<2 ) begin
                     if(in_values[sel]<9)
                           in_values[sel] <= in_values[sel] + 1; // Tang giá tri LED dc chon
                     else
                           in_values[sel] <= 4'd0;
                end
                       
                else begin
                    if(in_values[sel]<3)
                       in_values[sel] <= in_values[sel] + 1; // Tang giá tri LED dc chon
                    else
                        in_values[sel] <= 4'd0;
                end
          end
      end
    end
//***********************************************************************************
//mode 1 : dong ho    
  else begin
     if(counter_time == 27'h2faf080 ) begin
            if(in_values[0]<9)
                 in_values[0] <= in_values[0] + 1; // Tang giá tri LED dc chon
            else begin
                in_values[0] <= 4'd0;
                if(in_values[1] < 5)
                     in_values[1] <= in_values[1] + 1; // Tang giá tri LED dc chon
                else begin
                     in_values[1] <= 4'd0;
                     if(in_values[2] < 9)
                          in_values[2] <= in_values[2] + 1; // Tang giá tri LED dc chon
                     else begin
                          in_values[2] <= 4'd0; 
                          if(in_values[3] < 5)
                              in_values[3] <= in_values[3] + 1; // Tang giá tri LED dc chon
                          else begin
                              in_values[3] <= 4'd0; 
                              if(in_values[5] < 2 ) begin
                                   if(in_values[4] < 4'h9)
                                         in_values[4] <= in_values[4] + 1; // Tang giá tri LED dc chon
                                   else
                                         in_values[4] <= 4'd0;
                                         in_values[5] <= in_values[5] + 1 ;
                              end
             
                              else begin
                                    if(in_values[4] < 4'h3)
                                          in_values[4] <= in_values[4] + 1; // Tang giá tri LED dc chon
                                    else
                                          in_values[4] <= 4'd0;
                                          in_values[5] <= 4'd0;
                              end
                          end
                     end
                end
            end
     end
   end 
end  
//***********************************************************************************
//mode 0 : (dat gio) chon led dc thay doi
reg [25:0] dem; // Bien dem chong rung cho switch
always @(posedge clk) begin
    if(!rst_n) begin
        dem <= 26'd0;
    end
    
    else if(!s_mode) begin
        if(switch) // Neu ko nhan switch (key 4)
            dem <= 0;
        else begin // Neu nhan switch
            if(dem == 26'h7D7840)
                dem <= 0;
            else 
                dem <= dem + 1;
        end 
    end
    
    else begin
        if(dem == 26'h7D7840)
                dem <= 0;
            else 
                dem <= dem + 1; 
    end
end
// Chon LED dc thay doi
always @(posedge clk) begin
    if(!rst_n)
        sel <= 3'd0;
        
    else if(!s_mode) begin // che do mode 0 (dat gio)
        if(dem == 26'h7D7840)
            if(sel < 5)
                sel <= sel + 1;
            else
                sel <= 3'd0;
    end
    
    else begin // che do mode 1 (dong ho)
        if(sel < 5)
                sel <= sel + 1;
            else
                sel <= 3'd0;
    end
   
end
//**************************************************************************************
// Logic nhap nháy cho LED dc chon
reg [24:0] blink_counter; // Bien dem cho nhap nháy
reg blink_state;          // Trang thái bat/tat
always @(posedge clk) begin
    if(!rst_n) begin
        blink_counter <= 25'd0;
        blink_state <= 1'b0;
    end
    else begin
        blink_counter <= blink_counter + 1;
        if(blink_counter == 25'd16777215) begin // ~2Hz v?i clock 100MHz (100M / 2^24 / 2)
            blink_counter <= 25'd0;
            blink_state <= ~blink_state;
        end
    end
end

// Quét LED de hien thi trang thai + nhap nhay
reg [2:0] scan; // Bien quét tu dong
reg [15:0] scan_counter; // Bien dem quét
always @(posedge clk) begin
    if(!rst_n) begin
        scan_counter <= 16'd0;
        scan <= 3'd0;
        s_led <= 6'b111111; // Tat tat ca LED khi reset
        out <= 7'b0000000;  // tat out ve 0 khi reset
    end
    else begin
        scan_counter <= scan_counter + 1;
        if(scan_counter == 16'hFFFF) begin // Tan so quét ~1kHz voi clock 100MHz
            scan <= scan + 1;
            if(scan > 5) scan <= 0;
            
            case(scan)
                3'h0: begin 
                    dp <= 1;
                    s_led <= 6'b111110; 
                    if(scan == sel && blink_state && !s_mode) // Nhap nháy neu là LED dc chon
                        out <= 7'b1111111; // Tat
                    else
                        case(in_values[0])
                            4'h0: out <= ~7'b011_1111;
                            4'h1: out <= ~7'b000_0110;
                            4'h2: out <= ~7'b101_1011;
                            4'h3: out <= ~7'b100_1111;
                            4'h4: out <= ~7'b110_0110;
                            4'h5: out <= ~7'b110_1101;
                            4'h6: out <= ~7'b111_1101;
                            4'h7: out <= ~7'b000_0111;
                            4'h8: out <= ~7'b111_1111;
                            4'h9: out <= ~7'b110_1111;
                            4'hA: out <= ~7'b111_0111;
                            4'hB: out <= ~7'b111_1100;
                            4'hC: out <= ~7'b011_1001;
                            4'hD: out <= ~7'b101_1110;
                            4'hE: out <= ~7'b111_1001;
                            4'hF: out <= ~7'b111_0001;
                            default: out <= ~7'b011_1111;
                        endcase
                end
                3'h1: begin 
                    dp <= 1;
                    s_led <= 6'b111101; 
                    if(scan == sel && blink_state && !s_mode)
                        out <= 7'b1111111;
                    else
                        case(in_values[1])
                            4'h0: out <= ~7'b011_1111;
                            4'h1: out <= ~7'b000_0110;
                            4'h2: out <= ~7'b101_1011;
                            4'h3: out <= ~7'b100_1111;
                            4'h4: out <= ~7'b110_0110;
                            4'h5: out <= ~7'b110_1101;
                            4'h6: out <= ~7'b111_1101;
                            4'h7: out <= ~7'b000_0111;
                            4'h8: out <= ~7'b111_1111;
                            4'h9: out <= ~7'b110_1111;
                            4'hA: out <= ~7'b111_0111;
                            4'hB: out <= ~7'b111_1100;
                            4'hC: out <= ~7'b011_1001;
                            4'hD: out <= ~7'b101_1110;
                            4'hE: out <= ~7'b111_1001;
                            4'hF: out <= ~7'b111_0001;
                            default: out <= ~7'b011_1111;
                        endcase
                end
                3'h2: begin 
                    dp <= 0;
                    s_led <= 6'b111011; 
                    if(scan == sel && blink_state && !s_mode)
                        out <= 7'b1111111;
                    else
                        case(in_values[2])
                            4'h0: out <= ~7'b011_1111;
                            4'h1: out <= ~7'b000_0110;
                            4'h2: out <= ~7'b101_1011;
                            4'h3: out <= ~7'b100_1111;
                            4'h4: out <= ~7'b110_0110;
                            4'h5: out <= ~7'b110_1101;
                            4'h6: out <= ~7'b111_1101;
                            4'h7: out <= ~7'b000_0111;
                            4'h8: out <= ~7'b111_1111;
                            4'h9: out <= ~7'b110_1111;
                            4'hA: out <= ~7'b111_0111;
                            4'hB: out <= ~7'b111_1100;
                            4'hC: out <= ~7'b011_1001;
                            4'hD: out <= ~7'b101_1110;
                            4'hE: out <= ~7'b111_1001;
                            4'hF: out <= ~7'b111_0001;
                            default: out <= ~7'b011_1111;
                        endcase
                end
                3'h3: begin 
                    dp <= 1;
                    s_led <= 6'b110111; 
                    if(scan == sel && blink_state && !s_mode)
                        out <= 7'b1111111;
                    else
                        case(in_values[3])
                            4'h0: out <= ~7'b011_1111;
                            4'h1: out <= ~7'b000_0110;
                            4'h2: out <= ~7'b101_1011;
                            4'h3: out <= ~7'b100_1111;
                            4'h4: out <= ~7'b110_0110;
                            4'h5: out <= ~7'b110_1101;
                            4'h6: out <= ~7'b111_1101;
                            4'h7: out <= ~7'b000_0111;
                            4'h8: out <= ~7'b111_1111;
                            4'h9: out <= ~7'b110_1111;
                            4'hA: out <= ~7'b111_0111;
                            4'hB: out <= ~7'b111_1100;
                            4'hC: out <= ~7'b011_1001;
                            4'hD: out <= ~7'b101_1110;
                            4'hE: out <= ~7'b111_1001;
                            4'hF: out <= ~7'b111_0001;
                            default: out <= ~7'b011_1111;
                        endcase
                end
                3'h4: begin 
                    dp <= 0;
                    s_led <= 6'b101111; 
                    if(scan == sel && blink_state && !s_mode)
                        out <= 7'b1111111;
                    else
                        case(in_values[4])
                            4'h0: out <= ~7'b011_1111;
                            4'h1: out <= ~7'b000_0110;
                            4'h2: out <= ~7'b101_1011;
                            4'h3: out <= ~7'b100_1111;
                            4'h4: out <= ~7'b110_0110;
                            4'h5: out <= ~7'b110_1101;
                            4'h6: out <= ~7'b111_1101;
                            4'h7: out <= ~7'b000_0111;
                            4'h8: out <= ~7'b111_1111;
                            4'h9: out <= ~7'b110_1111;
                            4'hA: out <= ~7'b111_0111;
                            4'hB: out <= ~7'b111_1100;
                            4'hC: out <= ~7'b011_1001;
                            4'hD: out <= ~7'b101_1110;
                            4'hE: out <= ~7'b111_1001;
                            4'hF: out <= ~7'b111_0001;
                            default: out <= ~7'b011_1111;
                        endcase
                end
                3'h5: begin 
                    dp <= 1;
                    s_led <= 6'b011111; 
                    if(scan == sel && blink_state && !s_mode)
                        out <= 7'b1111111;
                    else
                        case(in_values[5])
                            4'h0: out <= ~7'b011_1111;
                            4'h1: out <= ~7'b000_0110;
                            4'h2: out <= ~7'b101_1011;
                            4'h3: out <= ~7'b100_1111;
                            4'h4: out <= ~7'b110_0110;
                            4'h5: out <= ~7'b110_1101;
                            4'h6: out <= ~7'b111_1101;
                            4'h7: out <= ~7'b000_0111;
                            4'h8: out <= ~7'b111_1111;
                            4'h9: out <= ~7'b110_1111;
                            4'hA: out <= ~7'b111_0111;
                            4'hB: out <= ~7'b111_1100;
                            4'hC: out <= ~7'b011_1001;
                            4'hD: out <= ~7'b101_1110;
                            4'hE: out <= ~7'b111_1001;
                            4'hF: out <= ~7'b111_0001;
                            default: out <= ~7'b011_1111;
                        endcase
                end
                default: begin 
                    s_led <= 6'b111111; 
                    out <= ~7'b011_1111; 
                end
            endcase
        end
    end
end

endmodule