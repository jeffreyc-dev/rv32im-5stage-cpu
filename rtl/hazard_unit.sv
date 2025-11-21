//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-18-2025
//  
//  Project: hazard_unit.sv
//  Description: Hazard Unit
//  License: MIT License (see LICENSE file in the project root)
//

module hazard_unit
(
  input  logic [4:0] Rs1D,
  input  logic [4:0] Rs2D,

  input  logic [4:0] Rs1E,
  input  logic [4:0] Rs2E,
  input  logic [4:0] RdE,
//input  logic [1:0] PCSrcE,
  input  logic       mispredictE,
  input  logic [1:0] ResultSrcE, // 01 for reading from data memory
  input  logic       BusyE,      // ALU busy signal

  input  logic [4:0] RdM,
  input  logic       RegWriteM,

  input  logic [4:0] RdW,
  input  logic       RegWriteW,

  output logic       StallF,

  output logic       StallD,
  output logic       FlushD,

  output logic       StallE,
  output logic       FlushE,

  output logic       FlushM,

  output logic [1:0] ForwardAE,
  output logic [1:0] ForwardBE
);

  logic lStall;   // Load Stall
  logic aluStall; // ALU Stall
  logic jbFlush;  // Jump/Branch Flush

  // Data Hazards
  always_comb begin

    // Forwarding Logic
    ForwardAE = (Rs1E==RdM) & RegWriteM & (Rs1E!=0) ? 2'b10 : // SrcAE = ALUResultM
                (Rs1E==RdW) & RegWriteW & (Rs1E!=0) ? 2'b01 : // SrcAE = ResultW
                                                      2'b00 ; // SrcAE = RD1E

    ForwardBE = (Rs2E==RdM) & RegWriteM & (Rs2E!=0) ? 2'b10 : // SrcBE = ALUResultM
                (Rs2E==RdW) & RegWriteW & (Rs2E!=0) ? 2'b01 : // SrcBE = ResultW
                                                      2'b00 ; // SrcBE = RD2E

    // Load Stall Logic
    lStall = (ResultSrcE==2'b01) & ((Rs1D==RdE) | (Rs2D==RdE));

  end

  // Control Hazard for Jump/Branch
//assign jbFlush = |PCSrcE;
  assign jbFlush = mispredictE;

  // Structural Hazard for multi-cycle ALU operations
  assign aluStall = BusyE;

  // Stall/Flush Signals
  always_comb begin

    StallF = lStall | aluStall;

    StallD = lStall | aluStall;
    FlushD = jbFlush;

    StallE = aluStall;
    FlushE = lStall | jbFlush;

    FlushM = aluStall;

  end

endmodule
