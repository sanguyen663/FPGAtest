`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2025 10:02:31 AM
// Design Name: 
// Module Name: sine_wave_generator
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

module sine_wave_generator (
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

    // ??nh ngh?a b?ng tra c?u (LUT) cho 1 chu k? sin
    // S? m?u: 256 (8-bit index), giá tr? sin t? 0 ??n 255 (8-bit)
    reg [7:0] sine_table [0:255];
    reg [7:0] phase; // B? ??m pha (index cho LUT)

    // Kh?i t?o b?ng tra c?u (LUT) v?i giá tr? sin
    initial begin
        sine_table[0] = 128  ; sine_table[1] = 131  ; sine_table[2] = 134  ; sine_table[3] = 137;
        sine_table[4] = 140  ; sine_table[5] = 143  ; sine_table[6] = 146  ; sine_table[7] = 149;
        sine_table[8] = 152  ; sine_table[9] = 155  ; sine_table[10] = 158 ; sine_table[11] = 161;
        sine_table[12] = 164 ; sine_table[13] = 167 ; sine_table[14] = 170 ; sine_table[15] = 173;
        sine_table[16] = 176 ; sine_table[17] = 179 ; sine_table[18] = 182 ; sine_table[19] = 185;
        sine_table[20] = 188 ; sine_table[21] = 191 ; sine_table[22] = 193 ; sine_table[23] = 196;
        sine_table[24] = 199 ; sine_table[25] = 202 ; sine_table[26] = 204 ; sine_table[27] = 207;
        sine_table[28] = 209 ; sine_table[29] = 211 ; sine_table[30] = 213 ; sine_table[31] = 215;
        sine_table[32] = 218 ; sine_table[33] = 220 ; sine_table[34] = 222 ; sine_table[35] = 224;
        sine_table[36] = 226 ; sine_table[37] = 228 ; sine_table[38] = 230 ; sine_table[39] = 232;
        sine_table[40] = 234 ; sine_table[41] = 235 ; sine_table[42] = 237 ; sine_table[43] = 239;
        sine_table[44] = 240 ; sine_table[45] = 241 ; sine_table[46] = 243 ; sine_table[47] = 244;
        sine_table[48] = 245 ; sine_table[49] = 246 ; sine_table[50] = 248 ; sine_table[51] = 249;
        sine_table[52] = 250 ; sine_table[53] = 250 ; sine_table[54] = 251 ; sine_table[55] = 252;
        sine_table[56] = 253 ; sine_table[57] = 253 ; sine_table[58] = 254 ; sine_table[59] = 254;
        sine_table[60] = 254 ; sine_table[61] = 255 ; sine_table[62] = 255 ; sine_table[63] = 255;//doan sau ao vl
        sine_table[64] = 255 ; sine_table[65] = 255 ; sine_table[66] = 255 ; sine_table[67] = 254;
        sine_table[68] = 254 ; sine_table[69] = 254 ; sine_table[70] = 253 ; sine_table[71] = 253;
        sine_table[72] = 252 ; sine_table[73] = 251 ; sine_table[74] = 250 ; sine_table[75] = 250;
        sine_table[76] = 249 ; sine_table[77] = 248 ; sine_table[78] = 246 ; sine_table[79] = 245;
        sine_table[80] = 244 ; sine_table[81] = 243 ; sine_table[82] = 241 ; sine_table[83] = 240;
        sine_table[84] = 239 ; sine_table[85] = 237 ; sine_table[86] = 235 ; sine_table[87] = 234;
        sine_table[88] = 232 ; sine_table[89] = 230 ; sine_table[90] = 228 ; sine_table[91] = 226;
        sine_table[92] = 224 ; sine_table[93] = 222 ; sine_table[94] = 220 ; sine_table[95] = 218;
        sine_table[96] = 215 ; sine_table[97] = 213 ; sine_table[98] = 211 ; sine_table[99] = 209;
        sine_table[100] = 207; sine_table[101] = 204; sine_table[102] = 202; sine_table[103] = 199;
        sine_table[104] = 196; sine_table[105] = 193; sine_table[106] = 191; sine_table[107] = 188;
        sine_table[108] = 185; sine_table[109] = 182; sine_table[110] = 179; sine_table[111] = 176;
        sine_table[112] = 173; sine_table[113] = 170; sine_table[114] = 167; sine_table[115] = 164;
        sine_table[116] = 161; sine_table[117] = 158; sine_table[118] = 155; sine_table[119] = 152;
        sine_table[120] = 149; sine_table[121] = 146; sine_table[122] = 143; sine_table[123] = 140;
        sine_table[124] = 137; sine_table[125] = 134; sine_table[126] = 131; sine_table[127] = 128;//
        sine_table[128] = 128; sine_table[129] = 125; sine_table[130] = 122; sine_table[131] = 119;
        sine_table[132] = 116; sine_table[133] = 113; sine_table[134] = 110; sine_table[135] = 106;
        sine_table[136] = 103; sine_table[137] = 100; sine_table[138] = 97; sine_table[139] = 94;
        sine_table[140] = 91; sine_table[141] = 88; sine_table[142] = 85; sine_table[143] = 82;
        sine_table[144] = 79; sine_table[145] = 77; sine_table[146] = 74; sine_table[147] = 71;
        sine_table[148] = 68; sine_table[149] = 65; sine_table[150] = 63; sine_table[151] = 60;
        sine_table[152] = 57; sine_table[153] = 55; sine_table[154] = 50; sine_table[155] = 47;
        sine_table[156] = 45; sine_table[157] = 43; sine_table[158] = 40; sine_table[159] = 38;
        sine_table[160] = 36; sine_table[161] = 34; sine_table[162] = 32; sine_table[163] = 30;
        sine_table[164] = 28; sine_table[165] = 26; sine_table[166] = 24; sine_table[167] = 22;
        sine_table[168] = 21; sine_table[169] = 20; sine_table[170] = 19; sine_table[171] = 17;
        sine_table[172] = 16; sine_table[173] = 15; sine_table[174] = 13; sine_table[175] = 12;
        sine_table[176] = 11; sine_table[177] = 10; sine_table[178] = 8; sine_table[179] = 7;
        sine_table[180] = 6; sine_table[181] = 6; sine_table[182] = 5; sine_table[183] = 4;
        sine_table[184] = 3; sine_table[185] = 3; sine_table[186] = 2; sine_table[187] = 2;
        sine_table[188] = 2; sine_table[189] = 1; sine_table[190] = 1; sine_table[191] = 1;//
        sine_table[192] = 1; sine_table[193] = 1; sine_table[194] = 1; sine_table[195] = 2;
        sine_table[196] = 2; sine_table[197] = 2; sine_table[198] = 3; sine_table[199] = 3;
        sine_table[200] = 4; sine_table[201] = 5; sine_table[202] = 6; sine_table[203] = 6;
        sine_table[204] = 7; sine_table[205] = 8; sine_table[206] = 10; sine_table[207] = 11;
        sine_table[208] = 12; sine_table[209] = 13; sine_table[210] = 15; sine_table[211] = 16;
        sine_table[212] = 17; sine_table[213] = 19; sine_table[214] = 20; sine_table[215] = 21;
        sine_table[216] = 22; sine_table[217] = 24; sine_table[218] = 26; sine_table[219] = 28;
        sine_table[220] = 30; sine_table[221] = 32; sine_table[222] = 34; sine_table[223] = 36;
        sine_table[224] = 38; sine_table[225] = 40; sine_table[226] = 43; sine_table[227] = 45;
        sine_table[228] = 47; sine_table[229] = 50; sine_table[230] = 55; sine_table[231] = 57;
        sine_table[232] = 60; sine_table[233] = 63; sine_table[234] = 65; sine_table[235] = 68;
        sine_table[236] = 71; sine_table[237] = 74; sine_table[238] = 77; sine_table[239] = 79;
        sine_table[240] = 82; sine_table[241] = 85; sine_table[242] = 88; sine_table[243] = 91;
        sine_table[244] = 94; sine_table[245] = 97; sine_table[246] = 100; sine_table[247] = 103;
        sine_table[248] = 106; sine_table[249] = 110; sine_table[250] = 113; sine_table[251] = 116;
        sine_table[252] = 119; sine_table[253] = 122; sine_table[254] = 125; sine_table[255] = 128;
    end

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
        sine_out <= 8'd128;
    end
    else begin
        clk_div <= clk_div + 1;
        if (clk_div == counter) begin
            clk_div <= 0;   
            sine_out <= sine_table[phase]; // Truy c?p tr?c ti?p LUT
            if(phase < 255)
                phase <= phase + 1;
            else
                phase <= 0;
        end
    end
end

endmodule
