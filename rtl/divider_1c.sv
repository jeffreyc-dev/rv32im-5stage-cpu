//
//  Authors: Jeffrey Claudio
//  Latest Revision: 11-11-2025
//  
//  Project: divider_1c.sv
//  Description: One-Cycle 32-bit Divider
//  License: MIT License (see LICENSE file in the project root)
//

module divider_1c
(
  input  logic [31:0] numA,     // Operand A
  input  logic [31:0] denB,     // Operand B
  input  logic        sign_sel, // Sign Selection
  output logic [31:0] quotient, // Quotient
  output logic [31:0] remainder // Remainder
);

  logic [31:0] newA, newB;
  logic        sign;
  logic [31:0] u_quotient, u_remainder;

  always_comb begin

    case(sign_sel)
      // div,rem
      1'b0 : begin
               newA = numA[31] ? ~numA + 1'b1 : numA;
               newB = denB[31] ? ~denB + 1'b1 : denB;
               sign = numA[31] ^ denB[31];
             end
      // divu,remu
      1'b1 : begin
               newA = numA;
               newB = denB;
               sign = 1'b0;
             end
      // signed/signed by default
   default : begin
               newA = numA[31] ? ~numA + 1'b1 : numA;
               newB = denB[31] ? ~denB + 1'b1 : denB;
               sign = numA[31] ^ denB[31];
             end
    endcase

    u_quotient  = (denB!=32'b0) ? newA / newB :
                                  32'hFFFFFFFF;
    u_remainder = (denB!=32'b0) ? newA % newB :
                                  newA        ;

      quotient  = sign ? ~u_quotient  + 1'b1 : u_quotient;
      remainder = sign ? ~u_remainder + 1'b1 : u_remainder;

  end

endmodule
