// hazard_unit.v
`timescale 1ns/1ps
module hazard_unit(
    input  wire [4:0] id_rs1,
    input  wire [4:0] id_rs2,
    input  wire [4:0] ex_rd,
    input  wire       ex_mem_read,
    output reg        pc_write,
    output reg        if_id_write,
    output reg        control_stall
);
    always @(*) begin
        if (ex_mem_read && ((ex_rd != 0) && ((ex_rd == id_rs1) || (ex_rd == id_rs2)))) begin
            pc_write = 0;
            if_id_write = 0;
            control_stall = 1;
        end else begin
            pc_write = 1;
            if_id_write = 1;
            control_stall = 0;
        end
    end
endmodule