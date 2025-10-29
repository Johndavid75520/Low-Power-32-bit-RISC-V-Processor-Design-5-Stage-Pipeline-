// control_unit.v
`timescale 1ns/1ps
module control_unit(
    input  wire [6:0] opcode,
    output reg        branch,
    output reg        mem_read,
    output reg        mem_to_reg,
    output reg [1:0]  alu_op,
    output reg        mem_write,
    output reg        alu_src,
    output reg        reg_write
);
    always @(*) begin
        // Defaults
        branch = 0; mem_read = 0; mem_to_reg = 0; alu_op = 2'b00;
        mem_write = 0; alu_src = 0; reg_write = 0;

        case (opcode)
            7'b0110011: begin // R-type
                alu_src = 0; mem_to_reg = 0; reg_write = 1; mem_read = 0;
                mem_write = 0; branch = 0; alu_op = 2'b10;
            end
            7'b0010011: begin // I-type ALU (ADDI)
                alu_src = 1; mem_to_reg = 0; reg_write = 1; mem_read = 0;
                mem_write = 0; branch = 0; alu_op = 2'b11;
            end
            7'b0000011: begin // LW
                alu_src = 1; mem_to_reg = 1; reg_write = 1; mem_read = 1;
                mem_write = 0; branch = 0; alu_op = 2'b00;
            end
            7'b0100011: begin // SW
                alu_src = 1; mem_to_reg = 0; reg_write = 0; mem_read = 0;
                mem_write = 1; branch = 0; alu_op = 2'b00;
            end
            7'b1100011: begin // BEQ
                alu_src = 0; mem_to_reg = 0; reg_write = 0; mem_read = 0;
                mem_write = 0; branch = 1; alu_op = 2'b01;
            end
            default: begin
                // keep defaults
            end
        endcase
    end
endmodule