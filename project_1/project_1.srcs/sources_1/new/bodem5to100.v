module counter_5_to_100 (
    input  wire clk,
    input  wire rst,   // reset ??ng b? m?c cao
    output reg  [6:0] q  // 7 bit ?? ?? bi?u di?n giá tr? t? 5 ??n 100
);
    always @(posedge clk) begin
        if (rst)
            q <= 7'd5;         // reset v? 5
        else if (q == 7'd100)
            q <= 7'd5;         // n?u ??t 100 thì quay v? 5
        else
            q <= q + 1'b1;     // t?ng lên 1
    end
endmodule
