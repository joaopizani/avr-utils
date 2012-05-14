#ifndef AVRUTILS_TIMERS_ATMEGA168P_H
#define AVRUTILS_TIMERS_ATMEGA168P_H

#include <stdint.h>


/// Obtains the bits to setup the prescale register of atmega168p's TIMER0 (8-bit)
uint8_t getTimer0PrescaleBits_atmega168p(uint16_t prescale);

/// Obtains the bits to setup the prescale register of atmega168p's TIMER1 (16-bit)
uint8_t getTimer1PrescaleBits_atmega168p(uint16_t prescale);

/// Obtains the bits to setup the prescale register of atmega168p's TIMER2 (8-bit)
uint8_t getTimer2PrescaleBits_atmega168p(uint16_t prescale);


#endif /* AVRUTILS_TIMERS_ATMEGA168P_H */
