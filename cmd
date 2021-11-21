# riscv64-linux-gnu-as -a -march=rv64imac -o helloworld.o helloworld.s
#riscv64-linux-gnu-as -a -o helloworld.o helloworld.s
#riscv64-linux-gnu-ld -o helloworld helloworld.o
#riscv64-linux-gnu-objdump -d helloworld

riscv64-linux-gnu-gcc -Wa,-a -o helloworld helloworld.S

riscv64-linux-gnu-gcc -Wa,-a -O2 -o printd printd.c
riscv64-linux-gnu-gcc -Wa,-a -O2 -fomit-frame-pointer -o hello hello.c
