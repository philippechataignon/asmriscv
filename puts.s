	.text
	.align	1
	.globl	asm_puts
	.type	asm_puts, @function
asm_puts:
    mv  a2,a1   #len
    mv  a1,a0   #ptr
	li	a0,1    #stdout
	li	a7,64   #write
	ecall
	li	a0,0    #return 0
	ret
