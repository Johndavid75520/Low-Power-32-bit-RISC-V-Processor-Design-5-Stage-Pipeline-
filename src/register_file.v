// register_file.v
`timescale 1ns/1ps
module register_file(
    input  wire        clk,
    input  wire        reset,
    input  wire        reg_write,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire [31:0] write_data,
    output wire [31:0] rd1,
    output wire [31:0] rd2
);
    reg [31:0] regs [0:31];
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i=0;i<32;i=i+1) regs[i] <= 32'd0;
        end else begin
            if (reg_write && (rd != 5'd0)) regs[rd] <= write_data;
        end
    end
    assign rd1 = regs[rs1];
    assign rd2 = regs[rs2];
endmodule