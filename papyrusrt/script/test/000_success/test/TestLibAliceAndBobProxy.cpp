#include <gtest/gtest.h>
#include <AbstractAliceAndBobProxyInterface.hh>


TEST(TestLibAliceAndBobProxy, typical)
{
    AbstractAliceAndBobProxyInterface obj;

    EXPECT_EQ( false, obj.isAvailable() );
}
