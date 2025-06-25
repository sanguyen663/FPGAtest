`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 02:52:05 PM
// Design Name: 
// Module Name: i2c_master
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

module i2c_master (
    input wire clk,             // System clock (50 MHz)
    input wire rst_n,           // Active low reset
    input wire start,           // Start I2C transaction
    input wire [6:0] addr,      // 7-bit I2C address of PCF8574 (e.g., 7'h20)
    input wire rw,              // Read/Write (0 = write, 1 = read)
    input wire [7:0] data_in,   // Data to write to PCF8574
    output reg [7:0] data_out,  // Data read from PCF8574
    inout wire sda,             // I2C data line - ho tro 2 chieu vao ra
    output wire scl,            // I2C clock line
    output reg done,            // Transaction complete
    output reg error            // Error flag (e.g., NACK received)
);

    // State machine states
    localparam IDLE       = 4'd0,
               START_C    = 4'd1,
               ADDR_C     = 4'd2,
               ACK_ADDR   = 4'd3,
               WRITE_DATA = 4'd4,
               READ_DATA  = 4'd5,
               ACK_DATA   = 4'd6,
               NACK_DATA  = 4'd7,
               STOP_C     = 4'd8,
               ERROR      = 4'd9;

    reg [3:0] state, next_state;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;
    reg sda_out, sda_oe;
    reg scl_reg;
    reg [7:0] data_reg;
    reg [6:0] addr_reg;

    // SDA tristate control
    assign sda = sda_oe ? sda_out : 1'bz;
    assign scl = scl_reg;

    // Chia tan so cho SCL (50 MHz / 500 = 100 kHz)
    reg [8:0] clk_div;
    wire scl_enable = (clk_div == 9'd249); // 50 MHz / 250 = 200 kHz (SCL half-cycle = 100 kHz)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 9'd0;
        else
            clk_div <= clk_div + 1;
    end

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else if (scl_enable)
            state <= next_state;
    end

    // Next state logic and output
    always @(*) begin
        next_state = state;
        sda_out = 1'b1;
        sda_oe = 1'b1;
        scl_reg = 1'b1;
        done = 1'b0;
        error = 1'b0;

        case (state)
            IDLE: begin
                if (start) begin
                    next_state = START_C;
                    sda_oe = 1'b1;
                    sda_out = 1'b1;
                    scl_reg = 1'b1;
                end
            end

            START_C: begin
                sda_out = 1'b0; // Start condition: SDA low while SCL high
                scl_reg = 1'b1;
                next_state = ADDR_C;
            end

            ADDR_C: begin
                sda_out = shift_reg[7]; // Send address bits
                scl_reg = (bit_count[0] == 1'b0); // Toggle SCL
                if (bit_count == 4'd7 && bit_count[0] == 1'b1)
                    next_state = ACK_ADDR;
            end

            ACK_ADDR: begin
                sda_oe = 1'b0; // Release SDA for slave ACK
                scl_reg = 1'b1;
                if (sda == 1'b1)
                    next_state = ERROR; // NACK received
                else
                    next_state = (rw ? READ_DATA : WRITE_DATA);
            end

            WRITE_DATA: begin
                sda_out = shift_reg[7]; // Send data bits
                scl_reg = (bit_count[0] == 1'b0); // Toggle SCL
                if (bit_count == 4'd7 && bit_count[0] == 1'b1)
                    next_state = ACK_DATA;
            end

            READ_DATA: begin
                sda_oe = 1'b0; // Release SDA for slave to send data
                scl_reg = (bit_count[0] == 1'b0); // Toggle SCL
                if (bit_count == 4'd7 && bit_count[0] == 1'b1)
                    next_state = NACK_DATA;
            end

            ACK_DATA: begin
                sda_oe = 1'b0; // Release SDA for slave ACK
                scl_reg = 1'b1;
                if (sda == 1'b1)
                    next_state = ERROR; // NACK received
                else
                    next_state = STOP_C;
            end

            NACK_DATA: begin
                sda_oe = 1'b1; // Master sends NACK to stop reading
                sda_out = 1'b1;
                scl_reg = 1'b1;
                next_state = STOP_C;
            end

            STOP_C: begin
                sda_out = 1'b0; // Stop condition: SDA low to high while SCL high
                scl_reg = 1'b1;
                if (scl_enable) begin
                    sda_out = 1'b1;
                    next_state = IDLE;
                    done = 1'b1;
                end
            end

            ERROR: begin
                error = 1'b1;
                next_state = STOP_C;
            end

            default: next_state = IDLE;
        endcase
    end

    // Bit counter, shift register, and data handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_count <= 4'd0;
            shift_reg <= 8'd0;
            addr_reg <= 7'd0;
            data_reg <= 8'd0;
            data_out <= 8'd0;
        end
        else if (scl_enable) begin
            case (state)
                IDLE: begin
                    if (start) begin
                        addr_reg <= addr;
                        data_reg <= data_in;
                        shift_reg <= {addr, rw}; // Load address + R/W bit
                        bit_count <= 4'd0;
                    end
                end

                ADDR_C: begin
                    if (bit_count[0] == 1'b1) begin
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count + 1;
                    end
                    else
                        bit_count <= bit_count + 1;
                end

                ACK_ADDR: begin
                    shift_reg <= data_reg; // Load data for write
                    bit_count <= 4'd0;
                end

                WRITE_DATA: begin
                    if (bit_count[0] == 1'b1) begin
                        shift_reg <= shift_reg << 1;
                        bit_count <= bit_count + 1;
                    end
                    else
                        bit_count <= bit_count + 1;
                end

                READ_DATA: begin
                    if (bit_count[0] == 1'b1) begin
                        shift_reg <= {shift_reg[6:0], sda}; // Shift in received data
                        bit_count <= bit_count + 1;
                    end
                    else
                        bit_count <= bit_count + 1;
                end

                NACK_DATA: begin
                    data_out <= shift_reg; // Store received data
                    bit_count <= 4'd0;
                end

                ACK_DATA: begin
                    bit_count <= 4'd0;
                end
            endcase
        end
    end

endmodule
