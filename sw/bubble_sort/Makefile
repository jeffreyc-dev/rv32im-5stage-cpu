# ==========================================================
# RISC-V Memory Build Makefile
# ==========================================================

# Toolchain prefix
RISCV_PREFIX = riscv32-unknown-elf-
CC      = $(RISCV_PREFIX)gcc
OBJDUMP = $(RISCV_PREFIX)objdump
OBJCOPY = $(RISCV_PREFIX)objcopy

# Compilation flags
CFLAGS  = -march=rv32i -mabi=ilp32 -O2 -Wall -nostdlib -ffreestanding
LDFLAGS = -T link.ld

# Input sources
SRC = reset.S bubble_sort.c

# Outputs
ELF = bubble_sort.elf
ASM = i_mem.asm
IMEM_BIN = i_mem.bin
DMEM_BIN = d_mem.bin
IMEM_HEX = i_mem.hex
DMEM_HEX = d_mem.hex

# ==========================================================
# Default target
# ==========================================================
all: $(ELF) $(ASM) $(IMEM_BIN) $(DMEM_BIN) $(IMEM_HEX) $(DMEM_HEX)

# 1️⃣ Build ELF
$(ELF): $(SRC) link.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $(SRC) -o $(ELF)

# 2️⃣ Dump .text section to readable assembly
$(ASM): $(ELF)
	$(OBJDUMP) -d -j .text $(ELF) > $(ASM)

# 3️⃣ Extract .text section binary (instruction memory)
$(IMEM_BIN): $(ELF)
	$(OBJCOPY) -O binary -j .text $(ELF) $(IMEM_BIN)

# 4️⃣ Combine data sections into single binary
$(DMEM_BIN): $(ELF)
	$(OBJCOPY) -O binary -j .data   $(ELF) data.bin   || true
	$(OBJCOPY) -O binary -j .bss    $(ELF) bss.bin    || true
	cat data.bin bss.bin > $(DMEM_BIN)
	rm -f data.bin bss.bin

# 5️⃣ Generate .hex files from binaries (using makehex)
$(IMEM_HEX): $(IMEM_BIN)
	makehex $(IMEM_BIN) 256 > $(IMEM_HEX)

$(DMEM_HEX): $(DMEM_BIN)
	makehex $(DMEM_BIN) 256 > $(DMEM_HEX)

# ==========================================================
# Cleanup
# ==========================================================
clean:
	rm -f $(ELF) $(ASM) $(IMEM_BIN) $(DMEM_BIN) $(IMEM_HEX) $(DMEM_HEX)

