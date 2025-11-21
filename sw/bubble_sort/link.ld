ENTRY(_reset)

MEMORY {
  IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 1K    /* 1 KB instruction memory */
  DMEM (rw)  : ORIGIN = 0x80000000, LENGTH = 1K    /* 1 KB data memory */
}

SECTIONS {
  /* Text section in IMEM */
  .text : {
    KEEP(*(.text.reset))   /* force .reset at the start */
    *(.text*)              /* all other text (.text, .text.*) */
    *(.rodata*)            /* read-only data */
  } > IMEM

  /* Initialized data in DMEM */
  .data : {
    *(.data*)              /* global initialized variables (like dmem[]) */
  } > DMEM

  /* Uninitialized data in DMEM */
  .bss : {
    *(.bss*)               /* global uninitialized variables */
  } > DMEM

  /* Stack pointer top */
  _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);  /* SP points to top of DMEM */
}
