//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-14-2025
//  
//  Project: rv32im_top.sv
//  Description: RISC-V 32-bit Integer, Multiplication, Division Extensions
//               with Instruction/Data Memory
//  License: MIT License (see LICENSE file in the project root)
//

module rv32im_top #(
  // ---------------------------------------------------
  // Parameterized Memory Map
  // ---------------------------------------------------
  parameter int IMEM_SIZE_POW2 = 10,             // 2^10 = 1   KB Instruction Memory
  parameter int DMEM_SIZE_POW2 =  9,             // 2^9  = 0.5 KB Data Memory
  parameter int IMEM_BASE_ADDR = 32'h0000_0000,  // IMEM starts at 0x0000_0000
  parameter int DMEM_BASE_ADDR = 32'h8000_0000   // DMEM starts at 0x0000_1000
)(
  input logic        clk,  // Clock
  input logic        reset // Reset
);

  // Instruction Memory Ports
  logic [31:0] Instr;      // Instruction
  logic [31:0] PC;         // Instruction Address

  // Data Memory Ports
  logic [31:0] ReadData;   // Read Data
  logic        MemWrite;   // Write Enable
  logic  [3:0] byte_en;    // Byte Enable
  logic [31:0] ALUResult;  // Read/Write Address
  logic [31:0] WriteData;  // Write Data

  rv32im u_cpu(
    .clk(clk),
    .reset(reset),
    // Instruction Memory Ports
    .Instr(Instr),
    .PC(PC),
    // Data Memory Ports
    .ReadData(ReadData),
    .MemWrite(MemWrite),
    .byte_en(byte_en),
    .ALUResult(ALUResult),
    .WriteData(WriteData)
  );

  i_mem #(
    .SIZE_POW2(IMEM_SIZE_POW2),
    .BASE_ADDR(IMEM_BASE_ADDR)
  ) u_i_mem(
    .A(PC),            // Instruction Address
    .RD(Instr)         // Instruction
  );

  d_mem #(
    .SIZE_POW2(DMEM_SIZE_POW2),
    .BASE_ADDR(DMEM_BASE_ADDR)
  ) u_d_mem(
    .clk(clk),         // Clock
    .WE(MemWrite),     // Write Enable
    .byte_en(byte_en), // Byte Enable
    .A(ALUResult),     // Read/Write Address
    .WD(WriteData),    // Write Data
    .RD(ReadData)      // Read Data
  );

endmodule
