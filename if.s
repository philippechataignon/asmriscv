.global _start
.text
_start:
	bne	a0,a1,.L2
	addw	a0,a3,a4
	ret
.L2:
	subw	a0,a3,a4
	ret
