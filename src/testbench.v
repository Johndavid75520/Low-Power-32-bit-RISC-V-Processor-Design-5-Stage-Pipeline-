// cpu_tb.v
`timescale 1ns/1ps
module cpu_tb();
    reg clk, reset;
    cpu_top DUT(.clk(clk), .reset(reset));

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    initial begin
        reset = 1;
        #20;
        reset = 0;
        #2000;
        $finish;
    end
endmodule