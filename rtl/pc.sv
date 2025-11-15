//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-3-2025
//  
//  Project: pc.sv
//  Description: Program Counter
//  License: MIT License (see LICENSE file in the project root)
//

module pc
(
  input  logic        clk,
  input  logic        reset,
  input  logic        en,
  input  logic [31:0] PCNext, // Next PC
  output logic [31:0] PC      // PC
);

  always_ff @(posedge clk) begin

    if(reset) begin
      PC <= 32'b0;
    end else

    if(en) begin
      PC <= PCNext;
    end

  end

endmodule
