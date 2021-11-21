CC=riscv64-linux-gnu-gcc
AS=riscv64-linux-gnu-as
LD=riscv64-linux-gnu-ld
CFLAGS=-O2
ASFLAGS=
LDFLAGS=

src=$(wildcard *.c)
obj=$(src:.c=.o)
target=hello helloworld printd read asm_strcpy strcpy asm_strcpy3

%.o: %.s
	$(AS) -c -o $@ $< $(ASFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.S
	$(CC) -c -o $@ $< $(CFLAGS)

%: %.o
	$(CC) -o $@ $^ $(LDFLAGS)

all: $(target)

asm_strcpy3: asm_strcpy3.o asm_strcpy2.o
asm_strcpy: asm_strcpy.o
hello: hello.o
helloworld: helloworld.o
printd: printd.o
read: read.o
strcpy: asm_strcpy2.o strcpy2.o
	$(CC) -o $@ $^ $(LDFLAGS)

.PHONY: clean

clean:
	rm -f *.o *~ core $(target)
