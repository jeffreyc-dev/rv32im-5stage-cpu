.section .text
.global _start

# --- Constants ---
.equ MIN_SIGNED, 0x80000000
.equ MAX_SIGNED, 0x7FFFFFFF

_start:
    # --- Initialization: Set Stack Pointer (sp) ---
    lui sp, %hi(_stack_bottom)
    addi sp, sp, %lo(_stack_bottom)
    
    # Initialize Input Registers (a0-a7)
    li a0, 0x12345678       # Positive value
    li a1, 0x00000001       # Small positive (1)
    li a2, 0xFFFFFFFF       # -1 (All ones)
    li a3, MIN_SIGNED       # Max negative
    li a4, MAX_SIGNED       # Max positive
    li a5, 0x00000000       # Zero
    li a6, 0x55555555       # Alternating pattern 1
    li a7, 0xAAAAAAAA       # Alternating pattern 2

# ----------------------------------------------------
# 1. U-Type (LUI, AUIPC) - 2 Instructions
# ----------------------------------------------------

# 1. LUI: Load Upper Immediate (Result: 0x12345000)
    lui t1, 0x12345
    sw t1, 0(sp)
    addi sp, sp, 4

# 2. AUIPC: Add Upper Immediate to PC (Result: PC + 0x1000)
    auipc t1, 0x00001
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 2. I-Type Computational (ADDI, SLTI, SLTIU, ANDI, ORI, XORI) - 6 Instructions
# ----------------------------------------------------

# 3. ADDI: Add Immediate (Result: a4+1 -> 0x80000000)
    addi t1, a4, 1
    sw t1, 0(sp)
    addi sp, sp, 4

# 4. SLTI: Set Less Than Immediate (Result: a3 <s 0 -> 1)
    slti t1, a3, 0
    sw t1, 0(sp)
    addi sp, sp, 4

# 5. SLTIU: Set Less Than Immediate Unsigned (Result: a1 <u -1 -> 1)
    sltiu t1, a1, -1
    sw t1, 0(sp)
    addi sp, sp, 4

# 6. ANDI: AND Immediate (Result: a0 & 0x678 -> 0x00000678)
    andi t1, a0, 0x678
    sw t1, 0(sp)
    addi sp, sp, 4

# 7. ORI: OR Immediate (Result: a0 | 0x00F -> 0x1234567F)
    ori t1, a0, 0x00F
    sw t1, 0(sp)
    addi sp, sp, 4

# 8. XORI: XOR Immediate (Result: a0 ^ 0xFFF -> 0xEDCBA987)
    xori t1, a0, -1
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 3. I-Type Shifts (SLLI, SRLI, SRAI) - 3 Instructions
# ----------------------------------------------------

# 9. SLLI: Shift Left Logical Immediate (Result: a1 << 31 -> 0x80000000)
    slli t1, a1, 31
    sw t1, 0(sp)
    addi sp, sp, 4

# 10. SRLI: Shift Right Logical Immediate (Result: a3 >>u 1 -> 0x40000000)
    srli t1, a3, 1
    sw t1, 0(sp)
    addi sp, sp, 4

# 11. SRAI: Shift Right Arithmetic Immediate (Result: a3 >>s 1 -> 0xC0000000)
    srai t1, a3, 1
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 4. R-Type (ADD, SUB, SLL, SRL, SRA, SLT, SLTU, XOR, OR, AND) - 10 Instructions
# ----------------------------------------------------

# 12. ADD: Add (Result: a4 + a1 -> 0x80000000)
    add t1, a4, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 13. SUB: Subtract (Result: a3 - a1 -> 0x7FFFFFFF)
    sub t1, a3, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 14. SLL: Shift Left Logical (Result: a1 << 31 -> 0x80000000)
    sll t1, a1, a2
    sw t1, 0(sp)
    addi sp, sp, 4

# 15. SRL: Shift Right Logical (Result: a3 >>u 31 -> 1)
    srl t1, a3, a2
    sw t1, 0(sp)
    addi sp, sp, 4

# 16. SRA: Shift Right Arithmetic (Result: a3 >>s 31 -> 0xFFFFFFFF)
    sra t1, a3, a2
    sw t1, 0(sp)
    addi sp, sp, 4

# 17. SLT: Set Less Than (Result: a3 <s a1 -> 1)
    slt t1, a3, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 18. SLTU: Set Less Than Unsigned (Result: a3 <u a1 -> 0)
    sltu t1, a3, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 19. XOR: Bitwise XOR (Result: a6 ^ a7 -> 0xFFFFFFFF)
    xor t1, a6, a7
    sw t1, 0(sp)
    addi sp, sp, 4

# 20. OR: Bitwise OR (Result: a6 | a7 -> 0xFFFFFFFF)
    or t1, a6, a7
    sw t1, 0(sp)
    addi sp, sp, 4

# 21. AND: Bitwise AND (Result: a6 & a7 -> 0x00000000)
    and t1, a6, a7
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 5. I-Type Load (LW, LH, LHU, LB, LBU) - 5 Instructions
# ----------------------------------------------------
# Setup memory location (t2) and store known data (t3)

    # Base address for loads/stores (4 bytes past current sp)
    addi t2, sp, 4  
    
    # Value: 0xAABBCCDD
    li t3, 0xAABBCCDD 
    sw t3, 0(t2) # Store the value at the target address (0x80000054) DMEM[22]

# 22. LW: Load Word (Result: 0xAABBCCDD)
    lw t1, 0(t2)
    sw t1, 0(sp)
    addi sp, sp, 4

# 23. LH: Load Halfword (Result: Sign-extended 0xAABB -> 0xFFFFAABB)
    lh t1, 2(t2)
    sw t1, 0(sp)
    addi sp, sp, 4

# 24. LHU: Load Halfword Unsigned (Result: Zero-extended 0xAABB -> 0x0000AABB)
    lhu t1, 0(t2)
    sw t1, 0(sp)
    addi sp, sp, 4

# 25. LB: Load Byte (Result: Sign-extended 0xCC -> 0xFFFFFFCC)
    lb t1, -3(t2)
    sw t1, 0(sp)
    addi sp, sp, 4

# 26. LBU: Load Byte Unsigned (Result: Zero-extended 0xAA -> 0x000000AA)
    lbu t1, 1(t2)
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 6. S-Type Store (SW, SH, SB) - 3 Instructions
# ----------------------------------------------------
# We use these instructions to set memory, but their functionality is verified
# by the previous Load tests. Here, we just execute them.

    li t3, 0x11223344
    
# 27. SW: Store Word (Saves 0x11223344 at 0(sp))
    sw t3, 0(sp)
    addi sp, sp, 4

# 28. SH: Store Halfword (Saves 0x3344 at 2(sp))
    sh t3, 2(sp)
    addi sp, sp, 4

# 29. SB: Store Byte (Saves 0x44 at 3(sp))
    sb t3, 3(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 7. J-Type (JAL) and I-Type (JALR) - 2 Instructions
# ----------------------------------------------------

# 30. JAL: Jump and Link (Result: t1 = PC of JAL + 4)
    jal t1, test_31_target
    li t1, 0xCAFEF00D # Should be skipped
    
test_31_target:
    sw t1, 0(sp)
    addi sp, sp, 4

# 31. JALR: Jump and Link Register (Result: t1 = PC of JALR + 4)
    la t2, test_32_target # Base register for jump
    jalr t1, 0(t2) # Use 0 offset for guaranteed RV32I alignment
    li t1, 0xCAFEF00D # Should be skipped
    
test_32_target:
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 8. B-Type Branch (BEQ, BNE, BLT, BGE, BLTU, BGEU) - 6 Instructions
# ----------------------------------------------------
# We use t1 to store an indicator value: 1 for taken, 0 for not taken.

# 32. BEQ: Branch Equal (Not Taken: a0 != a5 -> False)
    li t1, 0x115 # Taken
    beq a0, a5, skip_32
    li t1, 0x193 # Not taken
skip_32:
    sw t1, 0(sp)
    addi sp, sp, 4

# 33. BNE: Branch Not Equal (Taken: a0 != a5)
    li t1, 0x115 # Taken
    bne a0, a5, skip_33
    li t1, 0x193 # Not taken
skip_33:
    sw t1, 0(sp)
    addi sp, sp, 4

# 34. BLT: Branch Less Than (Not Taken: a0 <s a5 -> False)
    li t1, 0x115 # Taken
    blt a0, a5, skip_34
    li t1, 0x193 # Not taken
skip_34:
    sw t1, 0(sp)
    addi sp, sp, 4

# 35. BGE: Branch Greater Than or Equal (Taken: a0 >=s a5 -> True)
    li t1, 0x115 # Taken
    bge a0, a5, skip_35
    li t1, 0x193 # Not taken
skip_35:
    sw t1, 0(sp)
    addi sp, sp, 4

# 36. BLTU: Branch Less Than Unsigned (Not Taken: a0 <u a5 -> False)
    li t1, 0x115 # Taken
    bltu a0, a5, skip_36
    li t1, 0x193 # Not taken
skip_36:
    sw t1, 0(sp)
    addi sp, sp, 4

# 37. BGEU: Branch Greater Than or Equal Unsigned (Taken: a0 >=u a5 -> True)
    li t1, 0x115 # Taken
    bgeu a0, a5, skip_37
    li t1, 0x193 # Not taken
skip_37:
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 9. R-Type (MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU) - 8 Instructions
# ----------------------------------------------------

# 38. MUL: Multiply lower 32 bits (Result: a0 * a0 -> 0x12345678 * 0x12345678 = 0x014B66DC_1DF4D840, lower 32 bits)
    mul t1, a0, a0
    sw t1, 0(sp)
    addi sp, sp, 4

# 39. MUL: Multiply (Result: a2 * a1 -> -1 * 1 = 0xFFFFFFFF_FFFFFFFF, lower 32 bits)
    mul t1, a2, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 40. MUL: Multiply (Result: a3 * a2 -> MIN_SIGNED * -1 = 0x00000000_80000000, lower 32 bits)
# Actual result is 0x80000000. For signed overflow case, lower 32 bits are correct.
    mul t1, a3, a2
    sw t1, 0(sp)
    addi sp, sp, 4

# 41. MUL: Multiply (Result: a6 * a7 -> 0x55555555 * 0xAAAAAAAA = 0xE38E38E3_71C71C72, lower 32 bits)
    mul t1, a6, a7
    sw t1, 0(sp)
    addi sp, sp, 4

# 42. MULH: Multiply high signed (Result: a3 * a2 -> MIN_SIGNED * -1 = 0x00000000_80000000, upper 32 bits)
    mulh t1, a3, a2
    sw t1, 0(sp)
    addi sp, sp, 4

# 43. MULHU: Multiply high unsigned (Result: a6 * a7 -> 0x55555555 * 0xAAAAAAAA = 0x38E38E38_71C71C72, upper 32 bits)
    mulhu t1, a6, a7
    sw t1, 0(sp)
    addi sp, sp, 4

# 44. MULHSU: Multiply high signed/unsigned (Result: a2 signed * a2 unsigned -> -1 * 0xFFFFFFFF = 0xFFFFFFFF_00000001, upper 32 bits)
    mulhsu t1, a2, a2
    sw t1, 0(sp)
    addi sp, sp, 4

# 45. DIV: Signed division (Result: a0 / a1 -> 0x12345678 / 1 -> 0x12345678)
    div t1, a0, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 46. DIV: Signed division by zero (Result: a0 / a5 -> 0x12345678 / 0 = 0xFFFFFFFF)
    div t1, a0, a5
    sw t1, 0(sp)
    addi sp, sp, 4

# 47. DIVU: Unsigned division (Result: a0 / a1 -> 0x12345678 / 1 -> 0x12345678)
    divu t1, a0, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 48. REM: Signed remainder (Result: a0 % a1 -> 0x12345678 % 1 -> 0x00000000)
    rem t1, a0, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# 49. REM: Signed remainder on divide by zero (Result: a0 % a5 -> dividend value -> 0x12345678)
    rem t1, a0, a5
    sw t1, 0(sp)
    addi sp, sp, 4

# 50. REMU: Unsigned remainder (Result: a0 % a1 -> 0x12345678 % 1 -> 0x00000000)
    remu t1, a0, a1
    sw t1, 0(sp)
    addi sp, sp, 4

# ----------------------------------------------------
# 10. Program End (EBREAK) - 1 Instruction
# ----------------------------------------------------
# Final sentinel
    li t1, 0xDEADBEEF
    sw t1, 0(sp)
    addi sp, sp, 4

    # Halt execution. EBREAK is used by debuggers/simulators to signal end of test
    # or to enter debug mode.
    ebreak
end_test: 
    j end_test # Loop just in case ebreak is ignored
