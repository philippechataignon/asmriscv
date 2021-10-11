	.text
	.align	1
	.globl	asm_puts
	.type	asm_puts, @function
asm_puts:
    mv  a1,a0   #ptr
    mv  a2,a1   #len
	li	a0,1
	li	a7,64
	ecall
	li	a0,0
	ret
