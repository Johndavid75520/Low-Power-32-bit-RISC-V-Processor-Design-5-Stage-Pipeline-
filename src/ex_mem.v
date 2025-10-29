// ex_mem.v
`timescale 1ns/1ps
module ex_mem (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rd2_in,
    input  wire [4:0]  rd_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire        reg_write_in,
    input  wire        mem_to_reg_in,
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rd2_out,
    output reg  [4:0]  rd_out,
    output reg         mem_read_out,
    output reg         mem_write_out,
    output reg         reg_write_out,
    output reg         mem_to_reg_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 0;
            rd2_out <= 0;
            rd_out <= 0;
            mem_read_out <= 0;
            mem_write_out <= 0;
            reg_write_out <= 0;
            mem_to_reg_out <= 0;
        end else begin
            alu_result_out <= alu_result_in;
            rd2_out <= rd2_in;
            rd_out <= rd_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end
endmodule