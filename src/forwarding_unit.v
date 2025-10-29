// forwarding_unit.v
`timescale 1ns/1ps
module forwarding_unit(
    input  wire [4:0] ex_rs1,
    input  wire [4:0] ex_rs2,
    input  wire [4:0] mem_rd,
    input  wire [4:0] wb_rd,
    input  wire       mem_reg_write,
    input  wire       wb_reg_write,
    output reg  [1:0] forwardA,
    output reg  [1:0] forwardB
);
    always @(*) begin
        forwardA = 2'b00;
        forwardB = 2'b00;
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1)) forwardA = 2'b10;
        if (mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2)) forwardB = 2'b10;
        if (wb_reg_write && (wb_rd != 0) && (wb_rd == ex_rs1) && !(mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs1))) forwardA = 2'b01;
        if (wb_reg_write && (wb_rd != 0) && (wb_rd == ex_rs2) && !(mem_reg_write && (mem_rd != 0) && (mem_rd == ex_rs2))) forwardB = 2'b01;
    end
endmodule