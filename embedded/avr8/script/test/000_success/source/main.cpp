/**
 * @brief Blink using delay
 *
 * This software depends on the AE-ATmega ATmega328P development board
 * https://akizukidenshi.com/catalog/g/g104590/
 */

#ifdef SIMULATION
#include <thread>
#include <chrono>
void _delay_ms(double __ms)
{
    const int __ms_int = static_cast<int>(__ms + 0.5);
    std::this_thread::sleep_for(std::chrono::milliseconds(__ms_int));
}

#else // target
#include <util/delay.h>

#endif

#include <io_operation.hpp>


int main(void) {
    // ---> Initialize
    initialize_io_port();
    // <--- Initialize

    { // ---> Operation
        // Set initial status
        unsigned char is_turned_on = 0;
        turn_off();

        // ---> Main loop
        while (1) {
            // Wait
            _delay_ms(1000);

            if ( is_turned_on )
            {
                turn_off();
                is_turned_on = 0;
            }
            else
            {
                turn_on();
                is_turned_on = 1;
            }

        } // <--- Main loop
    } // <--- Operation

    // This program never reaches here
    return 0;
}
