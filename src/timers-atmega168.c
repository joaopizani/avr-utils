#include <stdint.h>
#include "timers-atmega168.h"


uint8_t getTimerPrescaleBits_atmega168(uint16_t prescale) {
    switch(prescale) {
        case 0:    return 0;
        case 1:    return 1;
        case 8:    return 2;
        case 64:   return 3;
        case 256:  return 4;
        case 1024: return 5;
        default:   return 0;
    }
}

