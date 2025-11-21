//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-18-2025
//  
//  Project: gbh.sv
//  Description: Global Branch History Register (10-bit)
//  License: MIT License (see LICENSE file in the project root)
//

module gbh
(
  input  logic       clk,        // Clock
  input  logic       reset,      // Reset
  input  logic       BranchE,    // Update GHR Enable
  input  logic       br_actualE, // Actual branch outcome
  output logic [9:0] gbh_reg     // The current history value
);

  always_ff @(posedge clk) begin
    if (reset) begin
      gbh_reg <= 10'b0;
    end else if (BranchE) begin
      // Shift in the new branch resolution when branch instruction is detected
      gbh_reg <= {gbh_reg[8:0], br_actualE};
    end
  end

endmodule
