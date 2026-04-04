#include <gtest/gtest.h>
#include <AbstractAliceAndBobProxyInterface.hh>


TEST(TestLibAliceAndBobProxy, typical)
{
    AbstractAliceAndBobProxyInterface obj // defect

    EXPECT_EQ( false, obj.isAvailable() );
}
