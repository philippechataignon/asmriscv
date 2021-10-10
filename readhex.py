#!/usr/bin/env python3
import sys
from intelhex import IntelHex

MEM = dict()
REG = [0] * 32
PC = 0
RUN = True

def extsgn(x, n = 12):
    if x > (1 << (n - 1)) - 1:
        x = x - (1 << n)
    return x

def unsgn(x, n=32):
    if x < 0:
        x = x + (1 << n)
    return x

def dump(mem):
    print(hex(PC),":", [hex(x) for x in REG])
    for k in sorted(mem.keys()):
        print(f"[{hex(k)}]: {chr(mem[k])} - {hex(mem[k])}")

def load(src, n, u=False):
    val = 0
    for i in range(n):
        val = val << 8
        val += MEM[src + n - 1 - i]
    if u:
        val = unsgn(val, n)
    return val

def store(val32, dest, n):
    for i in range(n):
        val = val32 & 0xff
        MEM[dest + i] = val
        val32 = val32 >> 8

def exec(pgm, start):
    global PC
    if len(pgm) % 4 != 0:
        print("Pgm must be 32 bits aligned")
        return -1

    PC = start
    while RUN:
        addr = PC - start
        try:
            instr = (pgm[addr + 3] << 24) + (pgm[addr + 2] << 16) + (pgm[addr + 1] << 8) + pgm[addr]
        except IndexError:
            break
        exec_instr(instr)
    print("Exit")
    dump(MEM)

def exec_instr(instr):
    global PC, REG, MEM
    dump(MEM)
    op = (instr      ) & 0b1111111
    rd = (instr >> 7 ) & 0b11111
    f3 = (instr >> 12) & 0b111
    r1 = (instr >> 15) & 0b11111
    r2 = (instr >> 20) & 0b11111
    f7 = (instr >> 25) & 0b1111111

    # print(hex(start + addr), hex(instr), bin(instr))
    # print(f"op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}")

    # arith (R)
    if (op == 0b0110011):
        if f3 == 0x0 and f7 == 0x00:
            print(f"add r{rd} <- r{r1} + r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] + REG[r2]
    # arith imm (I)
    elif (op == 0b0010011):
        if f3 == 0x0:
            val = instr >> 20
            val = extsgn(val)
            print(f"addi r{rd} <- r{r1} + {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] + val
    # load (I)
    elif (op == 0b0000011):
        val = instr >> 20
        val = extsgn(val)
        print(f"load{f3} r{rd} <- {val}(r{r1})")
        if rd > 0:
            if f3 == 0:
                REG[rd] = load(REG[r1] + val, 1)
            elif f3 == 1:
                REG[rd] = load(REG[r1] + val, 2)
            elif f3 == 2:
                REG[rd] = load(REG[r1] + val, 4)
            elif f3 == 4:
                REG[rd] = load(REG[r1] + val, 1, u = True)
            elif f3 == 5:
                REG[rd] = load(REG[r1] + val, 2, u = True)
    # store (S)
    elif (op == 0b0100011):
        val = rd + (f7 << 5)
        val = extsgn(val)
        print(f"store{f3} r{r2} -> {val}(r{r1})")
        if f3 == 0:
            store(REG[r2], REG[r1] + val, 1)
        elif f3 == 1:
            store(REG[r2], REG[r1] + val, 2)
        elif f3 == 2:
            store(REG[r2], REG[r1] + val, 4)
    # test (B)
    elif (op == 0b1100011):
        val = (rd >> 1) + ((f7 & 0b111111) << 4) # bits 1:10
        if rd & 1 == 1: # bit 11 set
            val |= (1 << 10)
        if val & (1 << 6): # bit 12 set
            val |= (1 << 11)
        val = extsgn(val, 12)
        val = val << 1 # bit 0 is always 0
        print(f"br{f3} r{r1} <-> r{r2} PC + {hex(val)}")
        if (f3 == 0 and REG[r1] == REG[r2])         \
           or (f3 == 1 and REG[r1] != REG[r2])      \
           or (f3 == 4 and REG[r1] < REG[r2])       \
           or (f3 == 5 and REG[r1] >= REG[r2])      \
           or (f3 == 6 and unsgn(REG[r1]) < unsgn(REG[r2]))       \
           or (f3 == 7 and unsgn(REG[r1]) >= unsgn(REG[r2])):
            PC += val
            return
    # jalr (I)
    elif (op == 0b1100111):
        if f3 == 0x0:
            val = instr >> 20
            val = extsgn(val)
            print(f"jalr r{rd} = PC+4, PC = r{r1} + {hex(val)}")
            if rd > 0:
                REG[rd] = PC + 4
            PC = REG[r1] + val
            return
    # jal (J)
    elif (op == 0b1101111):
        val = (f3 + (r1 << 3)) << 12 # bits 12-19
        if r2 & 1:
            val |= (1 << 11) # bit 11
        val += (r2 & 0b11110) + ((f7 & 0b111111) << 5) # bits 1-10
        if f7 & (1 << 6):
            val |= (1 << 20) # bit 20
        print(f"jal r{rd} = PC + 4, PC += {hex(val)}")
        if rd > 0:
            REG[rd] = PC + 4
        PC += val
        return
    # lui (U)
    elif (op == 0b0110111):
        val = (instr >> 12) << 12
        print(f"lui r{rd} <- {hex(val)}")
    # auipc (U)
    elif (op == 0b0010111):
        val = (instr >> 12) << 12
        print(f"auipc r{rd} <- PC + {hex(val)}")
        if rd > 0:
            REG[rd] = PC + val
    # ecall/ebreak
    elif (op == 0b1110011):
        if f3 == 0 & f7 == 0:
            if r2 == 0:
                print("ecall")
            elif r2 == 1:
                print("ebreak")
                RUN = False
            else:
                print(f"Unknown op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}")
    else:
        print(f"Unknown op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}")

    # next instruction
    PC += 4

def main():
    global MEM, REG
    ih = IntelHex()
    ih.loadhex(sys.argv[1])
    s = ih.segments()
    pgm = ih[s[0][0]:s[0][1]].tobinarray()
    data = ih[s[1][0]:s[1][1]]

    for addr in range(s[1][0], s[1][1]):
        MEM[addr] = ih[addr]

    # SP
    REG[2] = 0xF000FFFF
    # GP
    REG[3] = 0xF000EFFF

    exec(pgm, s[0][0])

    #store(0x9fff8000, 0x20000000, 4)
    #val = load(0x20000000, 1)
    #print(val)
    #val = load(0x20000001, 1)
    #print(val)
    #val = load(0x20000002, 1)
    #print(val)
    #val = load(0x20000000, 2)
    #print(val)
    #val = load(0x20000000, 4)
    #print(hex(val))
    #dump(MEM)

if __name__ == '__main__':
    main()
