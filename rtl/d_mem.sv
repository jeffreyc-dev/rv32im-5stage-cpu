//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-29-2025
//  
//  Project: d_mem.sv
//  Description: Data Memory
//  License: MIT License (see LICENSE file in the project root)
//

module d_mem #(
  parameter int SIZE_POW2 = 9,               // 2^SIZE_POW2 bytes (e.g., 2^9 = 512 B)
  parameter int BASE_ADDR = 32'h8000_0000    // Starting address of DMEM
)(
  input  logic        clk,                   // Clock
  input  logic        WE,                    // Write Enable
  input  logic  [3:0] byte_en,               // Byte Enable

  input  logic [31:0] A,                     // Read/Write Address
  input  logic [31:0] WD,                    // Write Data
  output logic [31:0] RD                     // Read Data
);

  // Compute Total Words
  localparam int MEM_BYTES = 1 << SIZE_POW2; // 2^SIZE_POW2 bytes
  localparam int WORDS     = MEM_BYTES / 4;  // Number of 32-bit words

  // Internal Memory Array
  logic [31:0] DMEM [0:WORDS-1];

  initial
  $readmemh(`DMEM_HEX,DMEM);

  // Synchronous Write Logic
  always_ff @(posedge clk) begin
    if (WE) begin
      if (byte_en[0]) DMEM[(A - BASE_ADDR) >> 2][ 7: 0] <= WD[ 7: 0];
      if (byte_en[1]) DMEM[(A - BASE_ADDR) >> 2][15: 8] <= WD[15: 8];
      if (byte_en[2]) DMEM[(A - BASE_ADDR) >> 2][23:16] <= WD[23:16];
      if (byte_en[3]) DMEM[(A - BASE_ADDR) >> 2][31:24] <= WD[31:24];
    end
  end

  // Asynchronous Read logic
  assign RD = DMEM[(A - BASE_ADDR) >> 2];

  // ---------------------------------------------------
  // Address-to-Data Mapping
  //
  // Each data-word = 4 bytes (word-aligned).
  // Word index is computed as:
  //      index = (A - BASE_ADDR) >> 2
  //
  // Example 1: BASE_ADDR = 0x0000_0000
  //   A = 0x0000_0000 → (0x0  - 0x0) >> 2 = 0  → DMEM[0]
  //   A = 0x0000_0004 → (0x4  - 0x0) >> 2 = 1  → DMEM[1]
  //   A = 0x0000_0008 → (0x8  - 0x0) >> 2 = 2  → DMEM[2]
  //   A = 0x0000_000C → (0xC  - 0x0) >> 2 = 3  → DMEM[3]
  //
  // Example 2: BASE_ADDR = 0x0000_1000
  //   A = 0x0000_1000 → (0x1000 - 0x1000) >> 2 = 0 → DMEM[0]
  //   A = 0x0000_1004 → (0x1004 - 0x1000) >> 2 = 1 → DMEM[1]
  //   A = 0x0000_1008 → (0x1008 - 0x1000) >> 2 = 2 → DMEM[2]
  // ---------------------------------------------------

endmodule
