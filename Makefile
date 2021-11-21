CC=riscv64-linux-gnu-gcc
AS=riscv64-linux-gnu-as
LD=riscv64-linux-gnu-ld
CFLAGS=-O2
ASFLAGS=-a
LDFLAGS=

src=$(wildcard *.c)
obj=$(src:.c=.o)
target=hello helloworld printd read asm_strcpy3 asm_strcpy

%.o: %.s
	$(AS) -a -c -o $@ $< $(ASFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.S
	# $(CC) -Wa,-a -c -o $@ $< $(CFLAGS)
	$(CC) -c -o $@ $< $(CFLAGS)

%: %.o
	$(CC) -o $@ $^ $(LDFLAGS)

all: $(target)

helloworld: helloworld.o
hello: hello.o
printd: printd.o
read: read.o
asm_strcpy3: asm_strcpy3.o asm_strcpy2.o
asm_strcpy: asm_strcpy.o

.PHONY: clean

clean:
	rm -f *.o *~ core $(target)
