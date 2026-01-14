#include <cstdio>
#include <arithmetic.hpp>

#include <version.hpp>

int main()
{
    std::printf("Application Version: %s\n", VERSION_STRING);
    std::printf("Library Version: %s\n", getVersion());

    const int a = 1;
    const int b = 2;

    std::printf("%d + %d = %d\n", a, b, add(a, b));
}
