#include <iostream>

#include <boost/asio.hpp>
#include <boost/thread.hpp>

int main()
{
    boost::asio::io_service io_service_instance;

    // Request invoke specified handler
    io_service_instance.post( []{ std::cout << "Thread(" << boost::thread::id() << "): Posts" << std::endl; } );
    io_service_instance.post( []{ std::cout << "Thread(" << boost::thread::id() << "): Posts" << std::endl; } );

    // Run posted items
    io_service_instance.run();
}
