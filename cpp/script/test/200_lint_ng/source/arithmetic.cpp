#include <arithmetic.hpp>


int add(int a, int b)
{
    int workspace[2];
    workspace[0] = a;
    workspace[1] = b;
    
    return workspace[0] + workspace[2]; // NG
}

int sub(int a, int b)
{
    return a - b;
}

int mul(int a, int b)
{
    return a * b;
}
