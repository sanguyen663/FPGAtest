module tb_counter_5_to_100;
    reg clk;
    reg rst;
    wire [6:0] q;

    // Kh?i t?o module c?n ki?m tra
    counter_5_to_100 uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // T?o xung clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test k?ch b?n mô ph?ng
    initial begin
        $display("Thoi gian\tReset\tq");
        $monitor("%t\t%b\t%d", $time, rst, q);
        rst = 1;
        #12;
        rst = 0;
        // ?? counter ch?y m?t vòng ??y ??
        #1000;
        $finish;
    end
endmodule
