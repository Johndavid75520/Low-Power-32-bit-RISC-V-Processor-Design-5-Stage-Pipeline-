// clock_gate.v
`timescale 1ns/1ps
module clock_gate(
    input  wire clk,
    input  wire enable,
    output wire gated_clk
);
    // Simulation-only simple AND gating (not for synthesis)
    assign gated_clk = clk & enable;
endmodule