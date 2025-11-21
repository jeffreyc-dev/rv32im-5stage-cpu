#include <stdint.h>

#define N 100

/* Place dmem array at start of DMEM (0x80000000) */
volatile int dmem[N] __attribute__((section(".data"))) = {0};

/* Declare main bubble sort function */
void main(void) {
    // Initialize dmem with deterministic descending values
    for (int i = 0; i < N; i++) {
        dmem[i] = N - 1 - i;  // 99 down to 0
    }


    // Bubble sort
    for (int i = 0; i < N - 1; i++) {
        for (int j = 0; j < N - 1 - i; j++) {
            if (dmem[j] > dmem[j+1]) {
                int tmp = dmem[j];
                dmem[j] = dmem[j+1];
                dmem[j+1] = tmp;
            }
        }
    }
}

/* Provide _start symbol for reset.S to jump to */
void _start(void) {
    main();
    while (1);  // infinite loop if main returns
}
