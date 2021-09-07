loop:
    li x6,100
    li x7,100
    li x1,1000
    add x5,x6,x7
    bge x5,x1,load1
load1: 
    mv x5,x0
    j loop

buffer:
    .bss    65536,8
