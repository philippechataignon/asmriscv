#include "include.h"

        .global main                # Provide program starting address to linker

# Setup the parameters to print hello world
# and then call Linux to do it.

        .text
main:  
        li    a0,STDOUT_FILENO      # 1 = StdOut
        la    a1,message            # load address of helloworld
        lbu   a2,len                # length of our string
        li    a7,__NR_write         # linux write system call
        ecall                       # Call linux to output the string

# Setup the parameters to exit the program
# and then call Linux to do it.

        li      a0,0                # Use 0 return code
        li      a7,__NR_exit        # Service command code 93 terminates
        ecall                       # Call linux to terminate the program

        .data
message:
        .ascii "Hello World!\n"
len:
        .byte   . - message
