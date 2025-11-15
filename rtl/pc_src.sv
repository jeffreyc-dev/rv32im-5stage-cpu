//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-3-2025
//  
//  Project: pc_src.sv
//  Description: PC Source
//  License: MIT License (see LICENSE file in the project root)
//

module pc_src
(
  input  logic       Jump,
  input  logic       Jumpr,
  input  logic       Branch,
  input  logic       br_taken,
  output logic [1:0] PCSrc
);

  assign PCSrc = Jump | (Branch & br_taken) ? 2'b01 : // PCE + ImmExtE
                 Jumpr                      ? 2'b10 : // ALUResultE & ~1
                                              2'b00 ; // PCF + 4

endmodule
