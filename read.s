	.file	"read.c"
	.option pic
	.text
	.align	1
	.globl	search
	.type	search, @function
search:
	slli	a2,a2,3
	add	a2,a1,a2
	mv	a5,a1
.L2:
	bgtu	a2,a5,.L8
	li	a0,-1
	ret
.L8:
	ld	a6,0(a5)
	mv	a3,a0
.L3:
	lbu	a7,0(a3)
	lbu	a4,0(a6)
	beqz	a7,.L4
	beqz	a4,.L5
	beq	a7,a4,.L6
.L5:
	addi	a5,a5,8
	j	.L2
.L6:
	addi	a3,a3,1
	addi	a6,a6,1
	j	.L3
.L4:
	bnez	a4,.L5
	sub	a0,a5,a1
	srai	a0,a0,3
	sext.w	a0,a0
	ret
	.size	search, .-search
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC0:
	.string	"Usage: %s <file>\n"
	.align	3
.LC1:
	.string	"r"
	.align	3
.LC2:
	.string	"fopen"
	.align	3
.LC3:
	.string	"Total word: %d\n"
	.align	3
.LC4:
	.string	"pipo"
	.align	3
.LC5:
	.string	"%d\n"
	.align	3
.LC6:
	.string	"qslkjdqslkjd"
	.align	3
.LC7:
	.string	"constitution"
	.align	3
.LC8:
	.string	"zythums"
	.align	3
.LC9:
	.string	"aa"
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	la	a5,__stack_chk_guard
	addi	sp,sp,-1168
	ld	a5,0(a5)
	li	a3,3198976
	li	t1,-3198976
	sd	s0,1152(sp)
	sd	s1,1144(sp)
	sd	s3,1128(sp)
	sd	s10,1072(sp)
	sd	ra,1160(sp)
	sd	s2,1136(sp)
	sd	s4,1120(sp)
	sd	s5,1112(sp)
	sd	s6,1104(sp)
	sd	s7,1096(sp)
	sd	s8,1088(sp)
	sd	s9,1080(sp)
	sd	s11,1064(sp)
	addi	a4,a3,1048
	add	sp,sp,t1
	add	a4,a4,sp
	sd	a5,0(a4)
	addi	a5,a3,1056
	add	a5,a5,sp
	mv	s1,a0
	li	s10,-3198976
	li	a0,6402048
	add	s3,a5,s10
	addi	a0,a0,-2048
	mv	s0,a1
	sd	zero,-1048(s3)
	sd	zero,-1040(s3)
	call	malloc@plt
	li	a5,2
	beq	s1,a5,.L15
	la	a5,stderr
	ld	a3,0(s0)
	ld	a0,0(a5)
	lla	a2,.LC0
	li	a1,1
	call	__fprintf_chk@plt
.L22:
	li	a0,1
.L23:
	call	exit@plt
.L15:
	mv	s5,a0
	ld	a0,8(s0)
	lla	a1,.LC1
	call	fopen@plt
	mv	s4,a0
	beqz	a0,.L16
	li	a5,3198976
	addi	a4,a5,1056
	add	a4,a4,sp
	addi	s10,s10,-1032
	li	s0,-3198976
	add	s10,a4,s10
	addi	a4,a5,1056
	add	a4,a4,sp
	addi	s7,s0,-1040
	addi	s6,s0,-1048
	mv	s11,s5
	li	s2,0
	add	s7,a4,s7
	add	s6,a4,s6
	li	s8,-1
	li	s9,10
.L17:
	mv	a2,s4
	mv	a1,s7
	mv	a0,s6
	call	getline@plt
	mv	a2,a0
	bne	a0,s8,.L19
	mv	a2,s2
	lla	a1,.LC3
	li	a0,1
	call	__printf_chk@plt
	ld	a0,-1048(s3)
	addi	s0,s0,-1032
	call	free@plt
	mv	a0,s4
	call	fclose@plt
	li	a5,3198976
	addi	a5,a5,1056
	add	a5,a5,sp
	add	s0,a5,s0
	mv	a2,s2
	mv	a1,s0
	lla	a0,.LC4
	call	search
	mv	a2,a0
	lla	a1,.LC5
	li	a0,1
	call	__printf_chk@plt
	mv	a2,s2
	mv	a1,s0
	lla	a0,.LC6
	call	search
	mv	a2,a0
	lla	a1,.LC5
	li	a0,1
	call	__printf_chk@plt
	mv	a2,s2
	mv	a1,s0
	lla	a0,.LC7
	call	search
	mv	a2,a0
	lla	a1,.LC5
	li	a0,1
	call	__printf_chk@plt
	mv	a2,s2
	mv	a1,s0
	lla	a0,.LC8
	call	search
	mv	a2,a0
	lla	a1,.LC5
	li	a0,1
	call	__printf_chk@plt
	mv	a2,s2
	mv	a1,s0
	lla	a0,.LC9
	call	search
	mv	a2,a0
	lla	a1,.LC5
	li	a0,1
	call	__printf_chk@plt
	mv	a0,s5
	call	free@plt
	li	a0,0
	j	.L23
.L16:
	lla	a0,.LC2
	call	perror@plt
	j	.L22
.L19:
	ld	a5,-1048(s3)
	addi	a4,a2,-1
	add	a5,a5,a4
	lbu	a3,0(a5)
	bne	a3,s9,.L18
	sb	zero,0(a5)
	mv	a2,a4
.L18:
	ld	a1,-1048(s3)
	addi	s1,a2,1
	mv	a0,s11
	mv	a2,s1
	call	strncpy@plt
	addiw	s2,s2,1
	sd	s11,0(s10)
	add	s11,s11,s1
	addi	s10,s10,8
	j	.L17
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
