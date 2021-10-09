#
# Risc-V Assembler program to print "Hello World!"
# to stdout.
#
# a0-a2 - parameters to linux function services
# a7 - linux function number
#

        .global _start          # Provide program starting address to linker
        .equ    write,64

# Setup the parameters to print hello world
# and then call Linux to do it.

        .text
_start:  li    a0,1           # 1 = StdOut
        la    a1,message     # load address of helloworld
        li    a2,%lo(len)    # length of our string
        li    a7,write       # linux write system call
        ecall                # Call linux to output the string

# Setup the parameters to exit the program
# and then call Linux to do it.

        li      a0,0         # Use 0 return code
        li      a7,93        # Service command code 93 terminates
        ecall                   # Call linux to terminate the program

        .data
message:
        .ascii "Hello World!\n"
        .equ    len,. - message
