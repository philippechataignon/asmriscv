CC=riscv64-linux-gnu-gcc
AS=riscv64-linux-gnu-as
LD=riscv64-linux-gnu-ld
CFLAGS=-O2
ASFLAGS=-a

src=$(wildcard *.c)
obj=$(src:.c=.o)
target=hello helloworld printd read

%.o: %.s
	$(AS) -c -o $@ $< $(ASFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.S
	$(CC) -Wa,-a -c -o $@ $< $(CFLAGS)

all: $(target)

helloworld: helloworld.o
	$(CC) -o $@ $^ $(LDFLAGS)

hello: hello.o
	$(CC) -o $@ $^ $(LDFLAGS)

printd: printd.o
	$(CC) -o $@ $^ $(LDFLAGS)

read: read.o
	$(CC) -o $@ $^ $(LDFLAGS)

.PHONY: clean

clean:
	rm -f *.o *~ core $(target)

#src = $(wildcard *.c)
#obj = $(src:.c=.o)
#
#LDFLAGS = -lGL -lglut -lpng -lz -lm
#
#myprog: $(obj)
#
#.PHONY: clean
#clean:
#	rm -f $(obj) myprog
