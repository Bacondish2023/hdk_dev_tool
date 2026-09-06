#include <Mutex.hpp>


#ifdef SIMULATION

// Nothing to do

#else // REAL

#include <avr/interrupt.h>

Mutex::Mutex()
{
    // Nothing to do
}

Mutex::~Mutex()
{
    // Nothing to do
}

void Mutex::lock()
{
    // Disable interrupts to enter critical section
    cli();
}

void Mutex::unlock()
{
    // Enable interrupts to exit critical section
    sei();
}

#endif
