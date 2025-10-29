// alu_control.v
`timescale 1ns/1ps
module alu_control(
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] alu_ctrl
);
    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // add (LW/SW)
            2'b01: alu_ctrl = 4'b0110; // sub (BEQ)
            2'b10: begin // R-type
                case ({funct7,funct3})
                    {7'b0000000,3'b000}: alu_ctrl = 4'b0010; // ADD
                    {7'b0100000,3'b000}: alu_ctrl = 4'b0110; // SUB
                    {7'b0000000,3'b111}: alu_ctrl = 4'b0000; // AND
                    {7'b0000000,3'b110}: alu_ctrl = 4'b0001; // OR
                    default: alu_ctrl = 4'b1111;
                endcase
            end
            2'b11: begin // I-type (ADDI etc) -> use add
                alu_ctrl = 4'b0010;
            end
            default: alu_ctrl = 4'b0000;
        endcase
    end
endmodule