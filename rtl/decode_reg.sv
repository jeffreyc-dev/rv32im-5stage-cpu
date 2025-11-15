//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-31-2025
//  
//  Project: decode_reg.sv
//  Description: Decode Register
//  License: MIT License (see LICENSE file in the project root)
//

module decode_reg
(
  input  logic        clk,
  input  logic        en,
  input  logic        clr,

  input  logic [31:0] InstrF,
  input  logic [31:0] PCF,
  input  logic [31:0] PCPlus4F,

  output logic [31:0] InstrD,
  output logic [31:0] PCD,
  output logic [31:0] PCPlus4D
);

  always_ff @(posedge clk) begin

    if(clr) begin
      InstrD   <= 32'b0;
      PCD      <= 32'b0;
      PCPlus4D <= 32'b0;
    end else

    if(en) begin
      InstrD   <= InstrF;
      PCD      <= PCF;
      PCPlus4D <= PCPlus4F; 
    end

  end

endmodule 
