# riscv64-linux-gnu-as -a -march=rv64imac -o helloworld.o helloworld.s
riscv64-linux-gnu-as -a -o helloworld.o helloworld.s
riscv64-linux-gnu-ld -o helloworld helloworld.o
riscv64-linux-gnu-objdump -d helloworld
