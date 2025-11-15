//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-16-2025
//  
//  Project: extend.sv
//  Description: Immediate Extension
//  License: MIT License (see LICENSE file in the project root)
//

import my_pkg::*;

module extend
(
  input  logic [31:7] i_imm,  // Immediate Raw
  input  imm_t        ImmSrc, // Immediate Select
  output logic [31:0] ImmExt  // Immediate Extended
);

  always_comb begin

    case(ImmSrc)
      I_imm : ImmExt = {{20{i_imm[31]}},i_imm[31:20]};
      S_imm : ImmExt = {{20{i_imm[31]}},i_imm[31:25],i_imm[11:7]};
      B_imm : ImmExt = {{20{i_imm[31]}},i_imm[7],i_imm[30:25],i_imm[11:8],1'b0};
      U_imm : ImmExt = i_imm[31:12] << 12;
      J_imm : ImmExt = {{12{i_imm[31]}},i_imm[19:12],i_imm[20],i_imm[30:21],1'b0};
    default : ImmExt = {{20{i_imm[31]}},i_imm[31:20]};
    endcase

  end

endmodule
