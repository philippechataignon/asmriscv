#!/usr/bin/env python3
from intelhex import IntelHex

def exec(pgm, start):
    if len(pgm) % 4 != 0:
        print("Pgm must be 32 bits aligned")
        return -1

    for addr in range(0, len(pgm), 4):
        instr = (pgm[addr + 3] << 24) + (pgm[addr + 2] << 16) + (pgm[addr + 1] << 8) + pgm[addr]
        # print(hex(start + addr), hex(instr), bin(instr))
        op = (instr & 0b00000000000000000000000001111111) >> 0
        rd = (instr & 0b00000000000000000000111110000000) >> 7
        f3 = (instr & 0b00000000000000000111000000000000) >> 12
        r1 = (instr & 0b00000000000011111000000000000000) >> 15
        r2 = (instr & 0b00000001111100000000000000000000) >> 20
        f7 = (instr & 0b11111110000000000000000000000000) >> 25

        # print(f"op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}")

        # arith
        if (op == 0b0110011):
            if f3 == 0x0 and f7 == 0x00:
                print(f"add r{rd} <- r{r1} + r{r2}")
        # arith imm
        elif (op == 0b0010011):
            if f3 == 0x0:
                val = r2 + (f7 << 5)
                print(f"addi r{rd} <- r{r1} + {hex(val)}")
        # load
        elif (op == 0b0000011):
            val = instr & (1 << 12)
            print(f"load{f3} r{rd} <- {val}(r{r1})")
        # store
        elif (op == 0b0100011):
            val = rd + (f7 << 5)
            if val > 2047:
                val -= 4096
            print(f"store{f3} r{r2} -> {val}(r{r1})")
        # test
        elif (op == 0b1100011):
            val = (rd >> 1) + ((f7 & 0b111111) << 4) # bits 1:10
            if rd % 2 == 1: # bit 11 set
                val += (1 << 10)
            if val & (1 << 6): # bit 12 set
                val |= (1 << 11)
            if val > 2047:
                val -= 4096
            val = val << 1
            print(f"br{f3} r{r1} <-> r{r2} PC + {hex(val)}")
        # jalr
        elif (op == 0b1100111):
            if f3 == 0x0:
                val = r2 + (f7 << 5)
                print(f"jalr r{rd} = PC+4, PC = r{r1} + {hex(val)}")
        # jal
        elif (op == 0b1101111):
            val = (f3 + (r1 << 3)) << 12 # bits 12-19
            if r2 % 1:
                val |= (1 << 11) # bit 11
            val += (r2 & 0b11110) + ((f7 & 0b111111) << 5) # bits 1-10
            if f7 & (1 << 6):
                val |= (1 << 20) # bit 20
            print(f"jal r{rd} = PC+4, PC = r{r1} + {hex(val)}")
        # auipc
        elif (op == 0b0010111):
            val = instr & (1 << 12)
            print(f"auipc r{rd} <- PC + {hex(val)}")
        else:
            print(f"Unknown op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}")

def main():
    ih = IntelHex()
    ih.loadhex('somme.hex')
    s = ih.segments()
    start = s[0][0]
    pgm = ih[s[0][0]:s[0][1]].tobinarray()
    data = ih[s[1][0]:s[1][1]]

    #for i, e in enumerate(pgm):
    #    print(hex(start+i), hex(e))

    #for addr in range(s[1][0], s[1][1]):
    #    print(hex(addr),":", chr(ih[addr]), hex(ih[addr]))

    exec(pgm, start)

if __name__ == '__main__':
    main()
