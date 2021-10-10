    .globl  my_copy
    .type   my_copy, @function
    .text
    .align  1
my_copy:
    la      a0,dest
    la      a1,source
.L3:
    lbu     a5,0(a1)
    sb      a5,0(a0)
    addi    a1,a1,1
    addi    a0,a0,1
    bnez    a5,.L3
    ret

    .data
source:
    .string "source"
dest:
    .string "dest  "
