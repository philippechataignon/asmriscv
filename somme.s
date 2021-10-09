    .globl  my_copy
    .type   my_copy, @function
    .text
    .align  1
my_copy:
    la      a1,source
    li      a2,0
    li      a3,0x12345678
.L3:
    lbu     a5,0(a1)
    addi    a1,a1,1
    addi    a0,a0,1
    addi    a2,a2,-1
    sb      a5,-1(a0)
    bnez    a5,.L3
    ret
    jal     sub

sub:
    ret

    .data
    .align  3
source:
    .string "source"
dest:
    .string "dest  "
