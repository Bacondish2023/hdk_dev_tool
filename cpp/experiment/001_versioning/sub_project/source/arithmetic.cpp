#include <arithmetic.hpp>
#include <version.hpp>

int add(int a, int b)
{
    return a + b;
}

int sub(int a, int b)
{
    return a - b;
}

int mul(int a, int b)
{
    return a * b;
}

const char *getVersion()
{
    return VERSION_STRING;
}
