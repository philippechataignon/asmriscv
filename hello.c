#include "puts.h"

int main(void)
{
    const char msg[] = "Hello, world!\n";
    asm_puts(msg, sizeof(msg));
    return 0;
}
