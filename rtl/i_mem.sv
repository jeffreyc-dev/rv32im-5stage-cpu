//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-29-2025
//  
//  Project: i_mem.sv
//  Description: Instruction Memory
//  License: MIT License (see LICENSE file in the project root)
//

module i_mem #(
  parameter int SIZE_POW2 = 10,              // 2^SIZE_POW2 bytes (e.g., 2^10 = 1 KB)
  parameter int BASE_ADDR = 32'h0000_0000    // Starting Address
)(
  input  logic [31:0] A,                     // Instruction Address
  output logic [31:0] RD                     // Instruction
);

  // Compute Total Words
  localparam int MEM_BYTES = 1 << SIZE_POW2; // 2^SIZE_POW2 bytes
  localparam int WORDS     = MEM_BYTES / 4;  // Number of 32-bit words

  // Instruction Memory
  logic [31:0] IMEM [0:WORDS-1];

  // Load Memory Contents
  initial
    $readmemh(`IMEM_HEX,IMEM);

  // Map the Address
  assign RD = IMEM[(A - BASE_ADDR) >> 2];

  // ---------------------------------------------------
  // Address-to-Instruction Mapping
  //
  // Each instruction = 4 bytes (word-aligned).
  // Word index is computed as:
  //      index = (A - BASE_ADDR) >> 2
  //
  // Example 1: BASE_ADDR = 0x0000_0000
  //   A = 0x0000_0000 → (0x0  - 0x0) >> 2 = 0  → IMEM[0]
  //   A = 0x0000_0004 → (0x4  - 0x0) >> 2 = 1  → IMEM[1]
  //   A = 0x0000_0008 → (0x8  - 0x0) >> 2 = 2  → IMEM[2]
  //   A = 0x0000_000C → (0xC  - 0x0) >> 2 = 3  → IMEM[3]
  //
  // Example 2: BASE_ADDR = 0x0000_1000
  //   A = 0x0000_1000 → (0x1000 - 0x1000) >> 2 = 0 → IMEM[0]
  //   A = 0x0000_1004 → (0x1004 - 0x1000) >> 2 = 1 → IMEM[1]
  //   A = 0x0000_1008 → (0x1008 - 0x1000) >> 2 = 2 → IMEM[2]
  // ---------------------------------------------------

endmodule
