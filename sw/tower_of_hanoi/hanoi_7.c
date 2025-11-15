#include <stdint.h>

// Maximum disks
#define MAX_DISKS 7
#define STACK_TOP 0x80000200 // Stack top in DMEM


// Towers (0=A, 1=B, 2=C) placed in custom section ".towers"
volatile uint32_t towers[3] __attribute__((section(".towers"))) = {0, 0, 0};
volatile uint32_t heights[3] = {MAX_DISKS, 0, 0};

// ----------------------
// Push/pop helpers
// ----------------------
static inline uint32_t pop(int t) {
    uint32_t h = heights[t] - 1;
    uint32_t disk = (towers[t] >> (h * 4)) & 0xF;
    towers[t] &= ~(0xF << (h * 4));
    heights[t] = h;
    return disk;
}

static inline void push(int t, uint32_t disk) {
    uint32_t h = heights[t];
    towers[t] |= (disk & 0xF) << (h * 4);
    heights[t] = h + 1;
}

// ----------------------
// Recursive Hanoi
// ----------------------
void hanoi(int n, int src, int aux, int dst) {
    if (n == 0) return;

    hanoi(n - 1, src, dst, aux);
    uint32_t disk = pop(src);
    push(dst, disk);
    hanoi(n - 1, aux, src, dst);
}

// ----------------------
// Initialize towers
// ----------------------
void init_tower() {
    towers[0] = 0;
    for (int i = 0; i < MAX_DISKS; i++) {
        towers[0] |= (MAX_DISKS - i) << (i * 4);
    }
    towers[1] = 0;
    towers[2] = 0;

    heights[0] = MAX_DISKS;
    heights[1] = 0;
    heights[2] = 0;
}

// ----------------------
// Minimal _start entry
// ----------------------
void _start() {
    asm volatile("li sp, %0" : : "i"(STACK_TOP)); // setup stack

    init_tower();
    hanoi(MAX_DISKS, 0, 1, 2); // src=A, aux=B, dst=C

    while (1) { asm volatile("nop"); } // halt
}
