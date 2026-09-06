#ifndef MUTEX_HPP
#define MUTEX_HPP


#ifdef SIMULATION

#include <mutex>
typedef std::mutex Mutex;

#else // REAL

class Mutex
{
public:
    Mutex();
    ~Mutex();

    void lock();
    void unlock();
};

#endif


#endif // MUTEX_HPP
