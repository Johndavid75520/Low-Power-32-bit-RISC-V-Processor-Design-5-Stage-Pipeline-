// id_ex.v
`timescale 1ns/1ps
module id_ex(
    input  wire        clk,
    input  wire        reset,
    // inputs from ID
    input  wire [31:0] rd1_in,
    input  wire [31:0] rd2_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    input  wire [2:0]  funct3_in,
    input  wire [6:0]  funct7_in,
    input  wire [1:0]  alu_op_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire        mem_to_reg_in,
    input  wire        alu_src_in,
    input  wire        reg_write_in,
    // outputs to EX
    output reg  [31:0] rd1_out,
    output reg  [31:0] rd2_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,
    output reg  [2:0]  funct3_out,
    output reg  [6:0]  funct7_out,
    output reg  [1:0]  alu_op_out,
    output reg         mem_read_out,
    output reg         mem_write_out,
    output reg         mem_to_reg_out,
    output reg         alu_src_out,
    output reg         reg_write_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd1_out <= 0; rd2_out <= 0; imm_out <= 0;
            rs1_out <= 0; rs2_out <= 0; rd_out <= 0;
            funct3_out <= 0; funct7_out <= 0; alu_op_out <= 0;
            mem_read_out <= 0; mem_write_out <= 0; mem_to_reg_out <= 0;
            alu_src_out <= 0; reg_write_out <= 0;
        end else begin
            rd1_out <= rd1_in;
            rd2_out <= rd2_in;
            imm_out <= imm_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out  <= rd_in;
            funct3_out <= funct3_in;
            funct7_out <= funct7_in;
            alu_op_out <= alu_op_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            alu_src_out <= alu_src_in;
            reg_write_out <= reg_write_in;
        end
    end
endmodule