.global	_start

.text
_start:
    li x1,%lo(len)
.data
msg:
	.ascii  "Hello, world!\n" # inline ascii string
	len =   . - msg           # assign value of (current address - address of msg start) to symbol "len"
