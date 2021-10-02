    .globl _start
    .globl src
    .globl dest
    .equ    exit,93

#######
    .text
    .align  3
 
_start:
    la      a0,dest
    jal     asm_print   
  
    la      a0,src
    la      a1,dest
    jal     asm_strcpy
 
    la      a0,dest
    jal     asm_print    
   
    li      a0,0        # exit code 0
    li      a7,exit  
    ecall         
 
#######
    .data
    .align  3
src:    
    .string    "sourc\n"
dest:
    .string    "abcdefghijklmn\n"
