#include <cstdio>
#include <arithmetic.hpp>

int main()
{
    const int a = 1;
    const int b = 2;

    std::printf("%d + %d = %d\n", a, b, add(a, b));
}
