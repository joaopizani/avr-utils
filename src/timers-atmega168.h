#ifndef AVRUTILS_TIMERS_ATMEGA168_H
#define AVRUTILS_TIMERS_ATMEGA168_H

#include <stdint.h>


/// Obtains the bits to setup the prescale register of atmega168's TIMER0 (8-bit)
uint8_t getTimer0PrescaleBits_atmega168(uint16_t prescale);

/// Obtains the bits to setup the prescale register of atmega168's TIMER1 (16-bit)
uint8_t getTimer1PrescaleBits_atmega168(uint16_t prescale);

/// Obtains the bits to setup the prescale register of atmega168's TIMER2 (8-bit)
uint8_t getTimer2PrescaleBits_atmega168(uint16_t prescale);


#endif /* AVRUTILS_TIMERS_ATMEGA168_H */
