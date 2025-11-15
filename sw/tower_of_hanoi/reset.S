/* reset.S — minimal RISC-V reset/startup stub for hanoi_7 */

    .section .text.reset
    .globl _reset
    .globl _start        /* ensure _start from C file is visible */

_reset:
    /* ----------------------------------------------------------
     * Basic startup/reset routine
     * ---------------------------------------------------------- */

    /* Set stack pointer — defined in your linker.ld */
    la      sp, _stack_top

    /* Optional: zero out all integer registers except x0 */
    li      t0, 0
    li      t1, 0
    li      t2, 0
    li      t3, 0
    li      t4, 0
    li      t5, 0
    li      t6, 0
    li      a0, 0
    li      a1, 0
    li      a2, 0
    li      a3, 0
    li      a4, 0
    li      a5, 0
    li      a6, 0
    li      a7, 0
    li      s0, 0
    li      s1, 0
    li      s2, 0
    li      s3, 0
    li      s4, 0
    li      s5, 0
    li      s6, 0
    li      s7, 0
    li      s8, 0
    li      s9, 0
    li      s10, 0
    li      s11, 0
    li      gp, 0
    li      tp, 0
    li      ra, 0

    /* ---------------------------------------------------------- *
     * Jump to C entry (_start in your hanoi_7.c)                 *
     * ---------------------------------------------------------- */
    jal     _start

    /* Should never return */
1:  j       1b
