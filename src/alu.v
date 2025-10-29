// alu.v
`timescale 1ns/1ps
module alu(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [3:0]  alu_ctrl,
    output reg  [31:0] result,
    output wire        zero
);
    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = a & b;
            4'b0001: result = a | b;
            4'b0010: result = a + b;
            4'b0110: result = a - b;
            4'b0111: result = (a < b) ? 32'd1 : 32'd0;
            4'b1100: result = ~(a | b);
            default: result = 32'd0;
        endcase
    end
    assign zero = (result == 32'd0);
endmodule