// cpu_top.v
`timescale 1ns/1ps
module cpu_top(
    input  wire clk,
    input  wire reset
);
    // IF
    wire [31:0] pc_curr, pc_next, pc_plus4, instruction;
    program_counter PC(.clk(clk), .reset(reset), .pc_in(pc_next), .pc_out(pc_curr));
    assign pc_plus4 = pc_curr + 4;
    instruction_memory IM(.addr(pc_curr), .instruction(instruction));

    // IF/ID
    wire [31:0] IF_ID_pc, IF_ID_instr;
    if_id IF_ID(.clk(clk), .reset(reset), .pc_in(pc_plus4), .instruction_in(instruction),
                .pc_out(IF_ID_pc), .instruction_out(IF_ID_instr));

    // ID signals
    wire [6:0] opcode = IF_ID_instr[6:0];
    wire [4:0] rd_id  = IF_ID_instr[11:7];
    wire [2:0] funct3 = IF_ID_instr[14:12];
    wire [4:0] rs1_id = IF_ID_instr[19:15];
    wire [4:0] rs2_id = IF_ID_instr[24:20];
    wire [6:0] funct7 = IF_ID_instr[31:25];

    // Control and ID units
    wire branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    wire [1:0] alu_op;
    control_unit CTRL(.opcode(opcode), .branch(branch), .mem_read(mem_read), .mem_to_reg(mem_to_reg),
                      .alu_op(alu_op), .mem_write(mem_write), .alu_src(alu_src), .reg_write(reg_write));

    // Register file
    // write-back signals from MEM/WB (declared below)
    wire [31:0] write_back_data;
    wire [4:0] mem_wb_rd;
    wire mem_wb_reg_write, mem_wb_mem_to_reg;
    wire [31:0] rf_rd1, rf_rd2;
    register_file RF(.clk(clk), .reset(reset), .reg_write(mem_wb_reg_write),
                     .rs1(rs1_id), .rs2(rs2_id), .rd(mem_wb_rd), .write_data(write_back_data),
                     .rd1(rf_rd1), .rd2(rf_rd2));

    // Immediate
    wire [31:0] imm_out;
    imm_gen IMM(.instruction(IF_ID_instr), .imm_out(imm_out));

    // ID/EX
    wire [31:0] ID_EX_rd1, ID_EX_rd2, ID_EX_imm;
    wire [4:0] ID_EX_rs1, ID_EX_rs2, ID_EX_rd;
    wire [2:0] ID_EX_f3; wire [6:0] ID_EX_f7;
    wire [1:0] ID_EX_alu_op;
    wire ID_EX_mem_read, ID_EX_mem_write, ID_EX_mem_to_reg, ID_EX_alu_src, ID_EX_reg_write;
    id_ex IDEX(.clk(clk), .reset(reset),
               .rd1_in(rf_rd1), .rd2_in(rf_rd2), .imm_in(imm_out),
               .rs1_in(rs1_id), .rs2_in(rs2_id), .rd_in(rd_id),
               .funct3_in(funct3), .funct7_in(funct7),
               .alu_op_in(alu_op),
               .mem_read_in(mem_read), .mem_write_in(mem_write),
               .mem_to_reg_in(mem_to_reg), .alu_src_in(alu_src), .reg_write_in(reg_write),
               .rd1_out(ID_EX_rd1), .rd2_out(ID_EX_rd2), .imm_out(ID_EX_imm),
               .rs1_out(ID_EX_rs1), .rs2_out(ID_EX_rs2), .rd_out(ID_EX_rd),
               .funct3_out(ID_EX_f3), .funct7_out(ID_EX_f7),
               .alu_op_out(ID_EX_alu_op),
               .mem_read_out(ID_EX_mem_read), .mem_write_out(ID_EX_mem_write),
               .mem_to_reg_out(ID_EX_mem_to_reg), .alu_src_out(ID_EX_alu_src), .reg_write_out(ID_EX_reg_write));

    // EX: ALU control + ALU
    wire [3:0] alu_ctrl;
    alu_control ALUCTRL(.alu_op(ID_EX_alu_op), .funct3(ID_EX_f3), .funct7(ID_EX_f7), .alu_ctrl(alu_ctrl));
    wire [31:0] alu_b = (ID_EX_alu_src) ? ID_EX_imm : ID_EX_rd2;
    wire [31:0] alu_result;
    wire alu_zero;
    alu ALU_U(.a(ID_EX_rd1), .b(alu_b), .alu_ctrl(alu_ctrl), .result(alu_result), .zero(alu_zero));

    // EX/MEM pipeline
    wire [31:0] EX_MEM_alu_result, EX_MEM_rd2;
    wire [4:0]  EX_MEM_rd;
    wire EX_MEM_mem_read, EX_MEM_mem_write, EX_MEM_reg_write, EX_MEM_mem_to_reg;
    ex_mem EXMEM(.clk(clk), .reset(reset),
                 .alu_result_in(alu_result), .rd2_in(ID_EX_rd2), .rd_in(ID_EX_rd),
                 .mem_read_in(ID_EX_mem_read), .mem_write_in(ID_EX_mem_write),
                 .reg_write_in(ID_EX_reg_write), .mem_to_reg_in(ID_EX_mem_to_reg),
                 .alu_result_out(EX_MEM_alu_result), .rd2_out(EX_MEM_rd2), .rd_out(EX_MEM_rd),
                 .mem_read_out(EX_MEM_mem_read), .mem_write_out(EX_MEM_mem_write),
                 .reg_write_out(EX_MEM_reg_write), .mem_to_reg_out(EX_MEM_mem_to_reg));

    // MEM
    wire [31:0] mem_read_data;
    data_memory DM(.clk(clk), .mem_read(EX_MEM_mem_read), .mem_write(EX_MEM_mem_write),
                   .addr(EX_MEM_alu_result), .write_data(EX_MEM_rd2), .read_data(mem_read_data));

    // MEM/WB
    wire [31:0] MEM_WB_mem_data, MEM_WB_alu_result;
    wire [4:0]  MEM_WB_rd;
    wire MEM_WB_reg_write, MEM_WB_mem_to_reg;
    mem_wb MEMWB(.clk(clk), .reset(reset),
                 .mem_data_in(mem_read_data),
                 .alu_result_in(EX_MEM_alu_result),
                 .rd_in(EX_MEM_rd),
                 .reg_write_in(EX_MEM_reg_write),
                 .mem_to_reg_in(EX_MEM_mem_to_reg),
                 .mem_data_out(MEM_WB_mem_data),
                 .alu_result_out(MEM_WB_alu_result),
                 .rd_out(MEM_WB_rd),
                 .reg_write_out(MEM_WB_reg_write),
                 .mem_to_reg_out(MEM_WB_mem_to_reg));

    // Write-back mux
    assign write_back_data = (MEM_WB_mem_to_reg) ? MEM_WB_mem_data : MEM_WB_alu_result;

    // expose MEM/WB signals to register file logic
    assign mem_wb_rd = MEM_WB_rd;
    assign mem_wb_reg_write = MEM_WB_reg_write;
    assign mem_wb_mem_to_reg = MEM_WB_mem_to_reg;

    // Next PC selection (simple: PC + 4, branch ignored for now)
    assign pc_next = pc_plus4;

endmodule