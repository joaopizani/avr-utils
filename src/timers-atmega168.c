#include <stdint.h>
#include "timers-atmega168.h"


uint8_t getTimer0PrescaleBits_atmega168(uint16_t prescale) {
    if(prescale == 1) return 0b00000001;
    else if(prescale == 8) return 0b00000010;
    else if(prescale == 64) return 0b00000011;
    else if(prescale == 256) return 0b00000100;
    else if(prescale == 1024) return 0b00000101;
    else return 0b00000000;
}

uint8_t getTimer1PrescaleBits_atmega168(uint16_t prescale) {
    // same as TIMER0
    return getTimer0PrescaleBits_atmega168(prescale);
}

uint8_t getTimer2PrescaleBits_atmega168(uint16_t prescale) {
    if(prescale == 1) return 0b00000001;
    else if(prescale == 8) return 0b00000010;
    else if(prescale == 32) return 0b00000011;
    else if(prescale == 64) return 0b00000100;
    else if(prescale == 128) return 0b00000101;
    else if(prescale == 256) return 0b00000110;
    else if(prescale == 1024) return 0b00000111;
    else return 0b00000000;
}


