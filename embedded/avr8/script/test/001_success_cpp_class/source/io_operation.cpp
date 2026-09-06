#include <io_operation.hpp>

#ifdef SIMULATION
#include <cstdio>
#else
#include <avr/io.h>
#endif

void initialize_io_port()
{
#ifdef SIMULATION
    // Nothing to do
#else
    DDRB = 0x2F;
    DDRC = 0x00;
    DDRD = 0xFC;
    PORTB = 0x04;
    PORTC = 0x00;
    PORTD = 0x00;
#endif
}

void turn_on()
{
#ifdef SIMULATION
    printf("turn_on()\n");
#else
    const uint8_t mask = 0x20;
    PORTB |= mask;
#endif
}

void turn_off()
{
#ifdef SIMULATION
    printf("turn_off()\n");
#else
    const uint8_t mask = 0x20;
    PORTB &= ~mask;
#endif
}
