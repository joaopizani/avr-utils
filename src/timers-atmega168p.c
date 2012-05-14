#include <stdint.h>
#include "timers-atmega168p.h"


uint8_t getTimer0PrescaleBits_atmega168p(uint16_t prescale) {
    if(prescale == 1) return 0b 00 000 001;
    else if(prescale == 8) return 0b 00 000 010;
    else if(prescale == 64) return 0b 00 000 011;
    else if(prescale == 256) return 0b 00 000 100;
    else if(prescale == 1024) return 0b 00 000 101;
    else return 0b 00 000 000;
}

uint8_t getTimer1PrescaleBits_atmega168p(uint16_t prescale) {
    // same as TIMER0
    return getTimer0PrescaleBits_atmega168p(prescale);
}

uint8_t getTimer2PrescaleBits_atmega168p(uint16_t prescale) {
    if(prescale == 1) return 0b 00 000 001;
    else if(prescale == 8) return 0b 00 000 010;
    else if(prescale == 32) return 0b 00 000 011;
    else if(prescale == 64) return 0b 00 000 100;
    else if(prescale == 128) return 0b 00 000 101;
    else if(prescale == 256) return 0b 00 000 110;
    else if(prescale == 1024) return 0b 00 000 111;
    else return 0b 00 000 000;
}

