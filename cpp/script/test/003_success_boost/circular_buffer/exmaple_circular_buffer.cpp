#include <cstdint>

#include <boost/circular_buffer.hpp>

int main()
{
    boost::circular_buffer<uint8_t> buffer(4);

    buffer.push_front(0);
    buffer.push_front(1);

    for (int i = 0; i < static_cast<int>(buffer.size()); i++)
    {
        printf("buffer[%d]: %d\n", i, buffer.at(i));
    }
}
