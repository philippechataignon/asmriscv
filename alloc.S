        .equ PAGESIZE, 4096             # We reserve exactly one page

        .section .text
        .align 2
        .global _start

_start:
        # Set up mmap call
        li a0, 0                        # NULL, because we want anonymous mapping
        li a1, PAGESIZE                 # Linux standard page is 4096
        li a2, PROT_READ|PROT_WRITE     # Read and write to page
        li a3, MAP_ANONYMOUS|MAP_PRIVATE  
        li a4, -1                       # File descriptor for anonymous
        li a5, 0                        # Offset
        li a7, __NR_mmap
        ecall
        ret
