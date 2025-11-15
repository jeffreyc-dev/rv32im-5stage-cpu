//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-16-2025
//  
//  Project: mux4.sv
//  Description: 4-input Mux
//  License: MIT License (see LICENSE file in the project root)
//

module mux4 #(parameter WIDTH = 32)
(
  input  logic [WIDTH-1:0] d0, d1, d2, d3, // Data In
  input  logic       [1:0] s,              // Select
  output logic [WIDTH-1:0] y               // Data Out
);

  assign y = (s==2'b11) ? d3 :
             (s==2'b10) ? d2 :
             (s==2'b01) ? d1 :
                          d0 ;

endmodule
