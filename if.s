	.file	"if.c"
	.option pic
	.text
	.align	1
	.globl	test
	.type	test, @function
test:
	bne	a0,a1,.L2
	addw	a0,a3,a4
	ret
.L2:
	subw	a0,a3,a4
	ret
	.size	test, .-test
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
