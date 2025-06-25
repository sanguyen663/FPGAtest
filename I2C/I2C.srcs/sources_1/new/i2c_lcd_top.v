`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 03:30:00 PM
// Design Name: I2C LCD Controller
// Module Name: i2c_lcd_top
// Project Name: I2C_LCD_PCF8574
// Target Devices: FPGA (e.g., Xilinx Artix-7)
// Tool Versions: 
// Description: Top module for controlling a 16x2 LCD via PCF8574 I2C I/O expander
// 
// Dependencies: i2c_master.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module i2c_lcd_top (
    input wire clk,             // System clock (50 MHz)
    input wire rst_n,           // Active low reset
    inout wire sda,             // I2C data line = j9_3
    output wire scl            // I2C clock line = j9_4
    
);
     reg error;           // Error flag
     reg done ;            // Transaction complete
    // I2C master signals
    wire i2c_start;
    wire [6:0] i2c_addr;
    wire i2c_rw;
    wire [7:0] i2c_data_in;
    wire [7:0] i2c_data_out;
    wire i2c_done;
    wire i2c_error;

    // Instantiate I2C master
    i2c_master i2c_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start(i2c_start),
        .addr(i2c_addr),
        .rw(i2c_rw),
        .data_in(i2c_data_in),
        .data_out(i2c_data_out),
        .sda(sda),
        .scl(scl),
        .done(i2c_done),
        .error(i2c_error)
    );

    // PCF8574 I2C address (e.g., 0x20)
    localparam PCF8574_ADDR = 7'h20;

    // LCD control bits for PCF8574 (P0-P7): [D7,D6,D5,D4,BL,E,RW,RS]
    // BL = Backlight (1 = ON), E = Enable, RW = Read/Write, RS = Register Select
    localparam LCD_BACKLIGHT = 1'b1; // Backlight always ON

    // State machine states
    localparam IDLE           = 4'd0,
               INIT_LCD       = 4'd1,
               SEND_CMD       = 4'd2,
               SEND_DATA      = 4'd3,
               WAIT_I2C       = 4'd4,
               DELAY          = 4'd5,
               ERROR_STATE    = 4'd6;

    reg [3:0] state, next_state;
    reg [7:0] lcd_data;
    reg lcd_rs; // 0 = command, 1 = data
    reg i2c_start_reg;
    reg [7:0] i2c_data_reg;
    reg [31:0] delay_counter;
    reg [3:0] init_step;
    reg [7:0] display_char;
    reg [4:0] char_index;

    // Example string to display: "Hello, World!"
    reg [7:0] message [0:15];
    initial begin
        message[0]  = 8'h48; // H
        message[1]  = 8'h65; // e
        message[2]  = 8'h6C; // l
        message[3]  = 8'h6C; // l
        message[4]  = 8'h6F; // o
        message[5]  = 8'h2C; // ,
        message[6]  = 8'h20; // <space>
        message[7]  = 8'h57; // W
        message[8]  = 8'h6F; // o
        message[9]  = 8'h72; // r
        message[10] = 8'h6C; // l
        message[11] = 8'h64; // d
        message[12] = 8'h21; // !
        message[13] = 8'h20; // <space>
        message[14] = 8'h20; // <space>
        message[15] = 8'h20; // <space>
    end

    // LCD initialization commands (4-bit mode)
    reg [7:0] init_commands [0:7];
    initial begin
        init_commands[0] = 8'h33; // Initial 4-bit mode
        init_commands[1] = 8'h32; // Confirm 4-bit mode
        init_commands[2] = 8'h28; // 4-bit, 2 lines, 5x8 font
        init_commands[3] = 8'h0C; // Display ON, cursor OFF
        init_commands[4] = 8'h06; // Entry mode: increment, no shift
        init_commands[5] = 8'h01; // Clear display
        init_commands[6] = 8'h80; // Set DDRAM address to 0
        init_commands[7] = 8'h00; // End of initialization
    end

    // Delay counter (50 MHz clock, 1 ms = 50,000 cycles)
    localparam DELAY_5MS  = 32'd250_000;  // 5 ms for init
    localparam DELAY_2MS  = 32'd100_000;  // 2 ms for commands
    localparam DELAY_50US = 32'd2_500;    // 50 us for enable pulse

    // Assign I2C master inputs
    assign i2c_start = i2c_start_reg;
    assign i2c_addr = PCF8574_ADDR;
    assign i2c_rw = 1'b0; // Always write to PCF8574
    assign i2c_data_in = i2c_data_reg;

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic and output
    always @(*) begin
        next_state = state;
        i2c_start_reg = 1'b0;
        i2c_data_reg = 8'b0;
        done = 1'b0;
        error = i2c_error;

        case (state)
            IDLE: begin
                next_state = INIT_LCD;
                init_step = 4'd0;
                char_index = 5'd0;
            end

            INIT_LCD: begin
                if (init_commands[init_step] == 8'h00) begin
                    next_state = SEND_DATA; // Start displaying message
                end else begin
                    lcd_data = init_commands[init_step];
                    lcd_rs = 1'b0; // Command mode
                    next_state = SEND_CMD;
                end
            end

            SEND_CMD: begin
                // Send high nibble
                i2c_data_reg = {lcd_data[7:4], LCD_BACKLIGHT, 1'b1, 1'b0, lcd_rs}; // E = 1
                i2c_start_reg = 1'b1;
                next_state = WAIT_I2C;
            end

            SEND_DATA: begin
                if (char_index < 16) begin
                    lcd_data = message[char_index];
                    lcd_rs = 1'b1; // Data mode
                    next_state = SEND_CMD;
                end else begin
                    done = 1'b1;
                    next_state = IDLE;
                end
            end

            WAIT_I2C: begin
                if (i2c_done) begin
                    if (i2c_error) begin
                        next_state = ERROR_STATE;
                    end else begin
                        next_state = DELAY;
                        delay_counter = DELAY_50US; // Enable pulse width
                        // Prepare low nibble or next step
                        i2c_data_reg = {lcd_data[7:4], LCD_BACKLIGHT, 1'b0, 1'b0, lcd_rs}; // E = 0
                    end
                end
            end

            DELAY: begin
                if (delay_counter == 0) begin
                    if (i2c_data_reg[3] == 1'b1) begin // High nibble sent, send low nibble
                        i2c_data_reg = {lcd_data[3:0], LCD_BACKLIGHT, 1'b1, 1'b0, lcd_rs}; // E = 1
                        i2c_start_reg = 1'b1;
                        next_state = WAIT_I2C;
                    end else if (i2c_data_reg[2] == 1'b0) begin // Low nibble sent, complete command/data
                        if (state == INIT_LCD) begin
                            init_step = init_step + 1;
                            delay_counter = DELAY_5MS;
                            next_state = DELAY;
                        end else begin
                            char_index = char_index + 1;
                            delay_counter = DELAY_2MS;
                            next_state = DELAY;
                            next_state = SEND_DATA;
                        end
                    end
                end else begin
                    delay_counter = delay_counter - 1;
                end
            end

            ERROR_STATE: begin
                error = 1'b1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule