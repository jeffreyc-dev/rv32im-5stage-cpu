//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-16-2025
//  
//  Project: mux2.sv
//  Description: 2-input Mux
//  License: MIT License (see LICENSE file in the project root)
//

module mux2 #(parameter WIDTH = 32)
(
  input  logic [WIDTH-1:0] d0, d1, // Data In
  input  logic             s,      // Select
  output logic [WIDTH-1:0] y       // Data Out
);

  assign y = s ? d1 :
                 d0 ;

endmodule
