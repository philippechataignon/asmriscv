	.file	"somme.c"
	.option pic
	.text
	.align	1
	.globl	_start
_start:
	.globl	somme
	.type	somme, @function
somme:
	addw	a0,a0,a1
	ret
	.size	somme, .-somme
	.align	1
	.globl	my_copy
	.type	my_copy, @function
my_copy:
.L3:
	lbu	a5,0(a1)
	addi	a1,a1,1
	addi	a0,a0,1
	sb	a5,-1(a0)
	bnez	a5,.L3
	ret
	.size	my_copy, .-my_copy
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
