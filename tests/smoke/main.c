#include <stdint.h>

#include "arm_nnfunctions.h"

int main(void)
{
    int8_t values[] = {-8, -1, 2, 9};
    const int8_t expected[] = {0, 0, 2, 6};

    arm_relu6_s8(values, 4);
    for (unsigned int index = 0; index < 4; ++index)
    {
        if (values[index] != expected[index])
        {
            return 1;
        }
    }
    return 0;
}
