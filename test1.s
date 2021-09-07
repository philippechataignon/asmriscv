.equ RTC_BASE,      0x40000040
.equ TIMER_BASE,    0x40004000
.equ CT,0x12345678

# setup machine trap vector
         la     t0,num
         li     x1,3
         li     x3,5
         srliw  x1,x3,3

# break on interrupt
mtvec:
        .data
fil:
        .string "FAIL\n"
num: 
        .byte 6
