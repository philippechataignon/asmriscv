CC=riscv64-linux-gnu-gcc
AS=riscv64-linux-gnu-as
LD=riscv64-linux-gnu-ld
CFLAGS=-O2
ASFLAGS=-a

src=$(wildcard *.c)
obj=$(src:.c=.o)
target=hello helloworld printd read

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

.PHONY: clean

clean:
	rm -f *.o *~ core $(target)
