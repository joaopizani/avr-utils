/*
 * File: sim_debug.h
 *
 * Author: João Paulo Pizani Flor
 * Date: 2012-04-26
 *
 */
#ifndef SIM_DEBUG_H_
#define SIM_DEBUG_H_

/*
 * Two macros should be defined for these functions to work: SIM_WRITE and SIM_READ,
 * which are, respectively, the IO-offset addresses to which the AVR core will write
 * debug bytes and from which it will read.
 *
 * The RECOMMENDED way (please don't do it otherwise) is to define these values in the
 * section "Simulation options" of this project's Makefile. In the Makefile, you
 * should define the vars. "SIM_WRITE_ADDR" and "SIM_READ_ADDR", which will affect
 * the macros used here.
 */

int debug_putc(char c, FILE* stream);

int debug_getc(FILE* stream);

void debug_exit(unsigned char exit_value);


#endif /* SIM_DEBUG_H_ */
