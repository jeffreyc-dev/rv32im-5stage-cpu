//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-16-2025
//  
//  Project: mux3.sv
//  Description: 3-input Mux
//  License: MIT License (see LICENSE file in the project root)
//

module mux3 #(parameter WIDTH = 32)
(
  input  logic [WIDTH-1:0] d0, d1, d2, // Data In
  input  logic       [1:0] s,          // Select
  output logic [WIDTH-1:0] y           // Data Out
);

  assign y = s[1] ? d2 :
             s[0] ? d1 :
                    d0 ;

endmodule
