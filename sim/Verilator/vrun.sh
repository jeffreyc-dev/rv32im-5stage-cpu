#!/bin/bash
set -e

# Paths
RTL_DIR=../../rtl
SIM_DIR=..

# Verilator executable flags
VERILATOR_FLAGS="--cc --exe --build -Wall -Wno-fatal --trace --trace-max-array 16384"

# Top-level module and testbench
TOP=rv32im_top
TB=$SIM_DIR/rv32im_top_tb.sv

# Verilator command with +define macros for hex paths
verilator $VERILATOR_FLAGS \
    +define+IMEM_HEX=\"../i_mem.hex\" \
    +define+DMEM_HEX=\"../d_mem.hex\" \
    $RTL_DIR/my_pkg.sv \
    $RTL_DIR/*.sv \
    $TB \
    ../beh_sim.cpp \
    --top-module $TOP \
    -CFLAGS "-I$RTL_DIR -I$SIM_DIR"

# Run the simulation executable
obj_dir/V$TOP
