//
//  Authors: Jeffrey Claudio
//  Latest Revision: 10-29-2025
//  
//  Project: rv32im_top_tb.sv
//  Description: A simple behavior-level testbench for rv32im_top.sv
//

module rv32im_top_tb;

  // Clock & Reset
  reg clk   = 1;
  reg reset = 1;
  always #100 clk = ~clk; // 5 GHz clock

  // Parameter overrides for top-level memories
  parameter int IMEM_SIZE_POW2 = 10; // 2^10 = 1   KB
  parameter int DMEM_SIZE_POW2 = 9;  // 2^9  = 0.5 KB
  parameter int IMEM_BASE_ADDR = 32'h0000_0000;
  parameter int DMEM_BASE_ADDR = 32'h8000_0000;

  // For comparing to Spike/Sail RISC-V models;
  integer file;
  integer i;

  initial begin
    $dumpfile("rv32im_top_tb.vcd");
    $dumpvars(0,rv32im_top_tb);

    repeat (10) @(posedge clk);
    reset <= 0;
    repeat (40000) @(posedge clk);

    // Open hex file
    file = $fopen("d_mem_final.hex", "w");

    if (file == 0) begin
        $display("ERROR: could not open d_mem_final.hex for writing");
        $finish;
    end

    // Loop over 128 memory words
    for (i = 0; i < 128; i++) begin
        // Write in hex format
        $fdisplay(file, "%08X", u_DUT.u_d_mem.DMEM[i]);
    end

    $fclose(file);
    $display("DMEM dump complete!");
    $finish;
    
  end

  rv32im_top #(
    .IMEM_SIZE_POW2(IMEM_SIZE_POW2),
    .DMEM_SIZE_POW2(DMEM_SIZE_POW2),
    .IMEM_BASE_ADDR(IMEM_BASE_ADDR),
    .DMEM_BASE_ADDR(DMEM_BASE_ADDR)
  ) u_DUT(
    .clk(clk),
    .reset(reset)
  );

endmodule
