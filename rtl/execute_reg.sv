//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-3-2025
//  
//  Project: execute_reg.sv
//  Description: Execute Register
//  License: MIT License (see LICENSE file in the project root)
//

import my_pkg::*;

module execute_reg
(
  input  logic        clk,
  input  logic        en,
  input  logic        clr,

  // Control Signals
  input  logic        RegWriteD,
  input  logic  [1:0] ResultSrcD,
  input  logic        MemWriteD,
  input  logic  [1:0] s_selD,
  input  logic  [1:0] l_selD,
  input  logic        u_loadD,
  input  logic        JumpD,
  input  logic        JumprD,
  input  logic        BranchD,
  input  logic  [1:0] ALUResultSrcD,
  input  ALUOp        ALUControlD,
  input  logic        ALUSrcD,

  output logic        RegWriteE,
  output logic  [1:0] ResultSrcE,
  output logic        MemWriteE,
  output logic  [1:0] s_selE,
  output logic  [1:0] l_selE,
  output logic        u_loadE,
  output logic        JumpE,
  output logic        JumprE,
  output logic        BranchE,
  output logic  [1:0] ALUResultSrcE,
  output ALUOp        ALUControlE,
  output logic        ALUSrcE,

  // PC, Register Address, Data
  input  logic [31:0] RD1D,
  input  logic [31:0] RD2D,
  input  logic [31:0] PCD,
  input  logic  [4:0] Rs1D,
  input  logic  [4:0] Rs2D,
  input  logic  [4:0] RdD,
  input  logic [31:0] ImmExtD,
  input  logic [31:0] PCPlus4D,

  output logic [31:0] RD1E,
  output logic [31:0] RD2E,
  output logic [31:0] PCE,
  output logic  [4:0] Rs1E,
  output logic  [4:0] Rs2E,
  output logic  [4:0] RdE,
  output logic [31:0] ImmExtE,
  output logic [31:0] PCPlus4E
);

  always_ff @(posedge clk) begin

    if(clr) begin
      RegWriteE     <=  1'b0;
      ResultSrcE    <=  2'b0;
      MemWriteE     <=  1'b0;
      s_selE        <=  2'b0;
      l_selE        <=  2'b0;
      u_loadE       <=  1'b0;
      JumpE         <=  1'b0;
      JumprE        <=  1'b0;
      BranchE       <=  1'b0;
      ALUResultSrcE <=  2'b0;
      ALUControlE   <=  OP_ADD;
      ALUSrcE       <=  1'b0;
      RD1E          <= 32'b0;
      RD2E          <= 32'b0;
      PCE           <= 32'b0;
      Rs1E          <=  5'b0;
      Rs2E          <=  5'b0;
      RdE           <=  5'b0;
      ImmExtE       <= 32'b0;
      PCPlus4E      <= 32'b0;
    end else

    if(en) begin
      RegWriteE     <= RegWriteD;
      ResultSrcE    <= ResultSrcD;
      MemWriteE     <= MemWriteD;
      s_selE        <= s_selD;
      l_selE        <= l_selD;
      u_loadE       <= u_loadD;
      JumpE         <= JumpD;
      JumprE        <= JumprD;
      BranchE       <= BranchD;
      ALUResultSrcE <= ALUResultSrcD;
      ALUControlE   <= ALUControlD;
      ALUSrcE       <= ALUSrcD;
      RD1E          <= RD1D;
      RD2E          <= RD2D;
      PCE           <= PCD;
      Rs1E          <= Rs1D;
      Rs2E          <= Rs2D;
      RdE           <= RdD;
      ImmExtE       <= ImmExtD;
      PCPlus4E      <= PCPlus4D;
    end

  end

endmodule
