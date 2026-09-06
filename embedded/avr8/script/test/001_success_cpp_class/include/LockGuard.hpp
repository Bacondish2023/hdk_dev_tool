#ifndef LOCK_GUARD_HPP
#define LOCK_GUARD_HPP

// Standard
#include <stdint.h>


#ifdef SIMULATION

#include <mutex>

template <typename T>
using LockGuard = std::lock_guard<T>;

#else // REAL

#include <avr/io.h>

template <typename T>
class LockGuard
{
public:
    LockGuard(T& mutex)
    :   mutex_(mutex),
        sreg_(0)
    {
        sreg_ = SREG;
        if (  sreg_ & (_BV(SREG_I)) ) {
            mutex_.lock();
        }
        else
        {
            // Nothing to do
            // Already in critical section
        }
    }

    ~LockGuard()
    {
        if (  sreg_ & (_BV(SREG_I)) ) {
            mutex_.unlock();
        }
        else
        {
            // Nothing to do
            // Already in critical section at construction time
        }
    }

protected:
    T& mutex_;
    uint8_t sreg_;
};

#endif


#endif // LOCK_GUARD_HPP
