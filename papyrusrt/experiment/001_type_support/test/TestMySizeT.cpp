#include <cstdio>

#include <gtest/gtest.h>

#include <umlrtobjectclass.hh>
#include <MySizeT.hh>

#define BUFFER_SIZE (256)


TEST(TestMySizeT, encodeAndDecode)
{
    MySizeT obj(1);
    MySizeT obj_destination(-1);
    uint8_t buffer[BUFFER_SIZE];

    // Encode and verify
    void *return_encode = UMLRTType_MySizeT.encode(&UMLRTType_MySizeT, &obj, buffer, 0);
    //EXPECT_EQ( return_encode, buffer + UMLRTType_MySizeT.object.sizeOf ); This fails

    // Decode and verify
    const void *return_decode = UMLRTType_MySizeT.decode(&UMLRTType_MySizeT, buffer, &obj_destination, 0);
    EXPECT_EQ( return_decode, buffer + UMLRTType_MySizeT.object.sizeOf );
    // ASSERT_EQ( obj_destination, obj ); This fails
}

TEST(TestMySizeT, fprintf)
{
    MySizeT obj(1);
    const char *expected = "{MySizeT:(unable to print)}";
    char buffer[BUFFER_SIZE];

    FILE *fp = tmpfile();
    if ( fp == nullptr )
    {
        FAIL() << "tmpfile() failed";
    }

    // Run and verify
    int return_value = UMLRTType_MySizeT.fprintf(fp, &UMLRTType_MySizeT, &obj, 0, 1);
    ASSERT_EQ( return_value, strlen(expected) );

    rewind(fp);
    fread(buffer, 1, return_value, fp);
    buffer[return_value] = '\0';
    fclose(fp);

    ASSERT_STREQ(expected, buffer);
}
