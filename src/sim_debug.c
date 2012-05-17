/*
 * File: sim_debug.c
 *
 * Author: João Paulo Pizani Flor
 * Date: 2012-04-26
 *
 */
#include <stdio.h>
#include "sim_debug.h"


int debug_putc(char c, FILE* stream) {
    SIM_WRITE = c;
    return 0;
}

int debug_getc(FILE* stream) {
    int c;
    c = (int) SIM_READ;

    return c;
}

void debug_exit(unsigned char exit_value) {
    SIM_EXIT = exit_value;
}

