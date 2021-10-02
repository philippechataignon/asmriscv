CC=riscv64-linux-gnu-gcc
AS=riscv64-linux-gnu-as
LD=riscv64-linux-gnu-ld
CFLAGS=
ASFLAGS=

%.o: %.s
	$(AS) -o $@ $< $(ASFLAGS)

ODIR=obj

_OBJ = helloworld.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

$(ODIR)/%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(ODIR)/%.o: %.s
	$(CC) -c -o $@ $< $(CFLAGS)

helloworld: $(OBJ)
	$(CC) -nostdlib -static -o $@ $^ $(CFLAGS)

.PHONY: clean

clean:
	rm -f $(ODIR)/*.o *~ core
