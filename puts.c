#define STRLEN(s) sizeof(s)/sizeof(s[0])
inline long asm_write(const char msg[], long len)
{
	register long a0 asm ("a0") = (long)1;
	register long a1 asm ("a1") = (long)msg;
	register long a2 asm ("a2") = (long)len;
	register long a7 asm ("a7") = (long)64;
	asm volatile (
            "ecall"					\
		    : "+r" (a0)				\
		    : "r" (a1), "r" (a2), "r" (a7)		\
		    : "memory"
    );
    return a0;
}

int _start()
{
    static const char msg[] = "Hello World!";
    asm_write(msg, STRLEN(msg));
    return 0;
}
