    .globl  my_copy
    .type   my_copy, @function
    .text
    .align  1
my_copy:
    la      a1,source
.L3:
    lbu     a5,0(a1)
    addi    a1,a1,1
    addi    a0,a0,1
    sb      a5,-1(a0)
    bnez    a5,.L3
    ret

    .data
    .align  3
source:
    .string "source"
dest:
    .string "dest  "
