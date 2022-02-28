CC=riscv64-linux-gnu-gcc
AS=riscv64-linux-gnu-as
LD=riscv64-linux-gnu-ld
LDFLAGS=
ASFLAGS=

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<
%: %.o
	$(LD) $(LDFLAGS) -o $@ $<

src=$(wildcard *.s)
obj=$(patsubst %.s,%.o,$(src))
target=$(patsubst %.s,%,$(src))

all:$(target) $(obj)


#helloworld: $(OBJ)
#	$(CC) -nostdlib -static -o $@ $^ $(CFLAGS)

.PHONY: clean

clean:
	rm -f $(obj) $(target)
