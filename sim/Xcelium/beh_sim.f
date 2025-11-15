+access+rwc
-gui
-timescale 1ps/1fs

+define+IMEM_HEX="\"../i_mem.hex\""
+define+DMEM_HEX="\"../d_mem.hex\""

../../rtl/my_pkg.sv
../../rtl/mux2.sv
../../rtl/mux3.sv
../../rtl/mux4.sv
../../rtl/store_unit.sv
../../rtl/load_unit.sv
../../rtl/divider_1c.sv
../../rtl/divider_32c.sv
../../rtl/multiplier_1c.sv
../../rtl/multiplier_16c.sv
../../rtl/barrel_shifter.sv
../../rtl/adder.sv
../../rtl/alu.sv
../../rtl/extend.sv
../../rtl/reg_file.sv
../../rtl/control_unit.sv
../../rtl/pc.sv
../../rtl/i_mem.sv
../../rtl/d_mem.sv
../../rtl/pc_src.sv
../../rtl/hazard_unit.sv
../../rtl/decode_reg.sv
../../rtl/execute_reg.sv
../../rtl/memory_reg.sv
../../rtl/writeback_reg.sv
../../rtl/rv32im.sv
../../rtl/rv32im_top.sv

../rv32im_top_tb.sv
