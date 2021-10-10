	.file	"write.c"
	.option pic
	.text
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	la	a5,stdout
	ld	a3,0(a5)
	addi	sp,sp,-16
	li	a2,1
	li	a1,13
	ld	a0,.LANCHOR0
	sd	ra,8(sp)
	call	fwrite@plt
	ld	ra,8(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.globl	str
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"Hello World!\n"
	.section	.data.rel.local,"aw"
	.align	3
	.set	.LANCHOR0,. + 0
	.type	str, @object
	.size	str, 8
str:
	.dword	.LC0
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
