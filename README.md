RISC-V 32-bit 5-Stage Pipelined Processor
==========================================

📘 Project Overview
-------------------
This project implements a 32-bit RISC-V (RV32I) pipelined processor using Verilog HDL. 
The design follows a classic 5-stage pipeline architecture:
1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory Access (MEM)
5. Write Back (WB)

The processor supports basic RISC-V instructions (arithmetic, logic, load/store, and branch operations)
and demonstrates how instruction-level parallelism is achieved through pipelining.

---

🧩 Modules Included
-------------------
• pc.v                 — Program Counter  
• instruction_memory.v — Instruction ROM  
• if_id.v              — IF/ID pipeline register  
• control_unit.v       — Main control signal generator  
• imm_gen.v            — Immediate generator  
• register_file.v      — 32×32 register file  
• alu_control.v        — ALU control signal generator  
• alu.v                — Arithmetic & logic operations  
• id_ex.v              — ID/EX pipeline register  
• ex_mem.v             — EX/MEM pipeline register  
• data_memory.v        — Data memory (RAM)  
• mem_wb.v             — MEM/WB pipeline register  
• hazard_unit.v        — (Optional) hazard detection  
• forwarding_unit.v    — (Optional) forwarding logic  
• cpu_top.v            — Top-level CPU integration  
• cpu_tb.v             — Testbench for simulation  

---

⚙ Simulation
-------------
Tool: Xilinx Vivado Simulator

Steps:
1. Open Vivado → Create Project → Add all Verilog source files and testbench  
2. Set cpu_tb.v as the top module  
3. Run Behavioral Simulation  
4. Add the following key signals to waveform:
   - PC_in, PC_out
   - Instruction
   - Control signals (RegWrite, MemRead, MemWrite, ALUSrc, Branch)
   - Register file inputs/outputs
   - ALU inputs, operation, and result
   - Data memory read/write values
   - Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB)
5. Run simulation for 1000 ns (or until the test program finishes)
6. Capture waveform screenshots and save in /simulation_results/

Output Example:
Simulation waveform showing instruction flow through pipeline stages.

---

🏗 Synthesis
-------------
Tool: Xilinx Vivado 2020.2 or later  
Device: Generic FPGA (no physical board required)

To generate synthesis and reports :
# Run synthesis only
launch_runs synth_1
wait_on_run synth_1
open_run synth_1

# Generate reports (no implementation)
report_utilization -file C:/Users/Dell/RISC_V/reports/utilization_report.txt
report_timing_summary -file C:/Users/Dell/RISC_V/reports/timing_summary.txt
report_power -file C:/Users/Dell/RISC_V/reports/power_report.txt

Post-synthesis schematic:  
Generated via *Open Synthesized Design → Schematic → Export as PDF*.

---

📊 Project Folder Structure
---------------------------
RISC_V_CPU/
│
├── src/                     ← All Verilog module files (.v)
│   ├── cpu_top.v
│   ├── alu.v
│   ├── control_unit.v
│   ├── register_file.v
│   ├── instruction_memory.v
│   ├── data_memory.v
│   ├── imm_gen.v
│   ├── hazard_unit.v
│   ├── forwarding_unit.v
│   ├── if_id.v
│   ├── id_ex.v
│   ├── ex_mem.v
│   ├── mem_wb.v
│   └── clock_gate.v
│
├── testbench/
│   └── cpu_tb.v
│
├── simulation_results/
│   ├── pipeline_waveform.png
│   └── write_back_waveform.png
│   
├── schematics/
│   └──cpu_top_schematic.pdf
│
└── README.md
---

🧠 Key Learning Outcomes
-------------------------
• Implementation of a 5-stage pipelined RISC-V processor  
• Understanding pipeline hazards and forwarding mechanisms  
• Practical exposure to Verilog HDL and Xilinx Vivado flow  
• Familiarity with synthesis, timing, and power reports  

---

👤 Author
---------
John David  
Mail:vadapallijohndavid@gmail.com 
LinkedIn:www.linkedin.com/in/vadapalli-john-david

---

📅 Version
----------
v1.0 — October 2025  
Status: Completed (Simulation + Synthesis)
