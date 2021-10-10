	.file	"puts.c"
	.option pic
	.text
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	li	a0,1
	lla	a1,.LANCHOR0
	li	a2,13
	li	a7,64
#APP
# 34 "puts.c" 1
	ecall
# 0 "" 2
#NO_APP
	li	a0,0
	ret
	.size	main, .-main
	.section	.rodata
	.align	3
	.set	.LANCHOR0,. + 0
	.type	msg.1509, @object
	.size	msg.1509, 13
msg.1509:
	.string	"Hello World!"
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
