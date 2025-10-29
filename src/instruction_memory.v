module instruction_memory (
    input  wire [31:0] addr,
    output reg  [31:0] instruction
);

    // Simple instruction memory (256 words)
    reg [31:0] memory [0:255];

    initial begin
        // Example RISC-V instructions (can modify later)
        // Format: memory[address] = 32'hXXXXXXXX;
        memory[0] = 32'h00000093;  // addi x1, x0, 0
        memory[1] = 32'h00100113;  // addi x2, x0, 1
        memory[2] = 32'h002081b3;  // add  x3, x1, x2
        memory[3] = 32'h00310233;  // add  x4, x2, x3
        memory[4] = 32'h004182b3;  // add  x5, x3, x4
        memory[5] = 32'h00000013;  // nop
        memory[6] = 32'h00000013;  // nop
        memory[7] = 32'h00000013;  // nop
        // you can extend as needed
    end

    always @(*) begin
        // divide by 4 because PC increments in bytes, memory indexed by words
        instruction = memory[addr[9:2]];
    end

endmodule