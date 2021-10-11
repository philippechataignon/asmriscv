#!/usr/bin/env python3
import logging
import sys
from elftools.elf.elffile import ELFFile
from elftools.elf.sections import Section, SymbolTableSection

logger = logging.getLogger(__name__)

# from intelhex import IntelHex

MEM = dict()
SYM = dict()
REG = [0] * 32
PC = 0
RUN = True


def extsgn(x, n=12):
    if x > (1 << (n - 1)) - 1:
        x = x - (1 << n)
    return x


def unsgn(x, n=32):
    if x < 0:
        x = x + (1 << n)
    return x


def dump(mem):
    print(hex(PC), ":", [f"{i}: {hex(x)}" for i, x in enumerate(REG)])
    prev = None
    for i, k in enumerate(sorted(mem.keys())):
        if prev is not None and k == prev + 1 and not k % 16 == 0:
            print(f"{hex(mem[k])}", end=" ")
        else:
            print()
            print(f"[{hex(k)}]: {hex(mem[k])}", end=" ")
        prev = k
    print()


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
        val = val32 & 0xFF
        MEM[dest + i] = val
        val32 = val32 >> 8


def exec(pgm, start):
    global PC, RUN
    if len(pgm) % 4 != 0:
        print("Pgm must be 32 bits aligned")
        return -1

    PC = start
    while RUN:
        addr = PC - start
        try:
            instr = (
                pgm[addr]
                + (pgm[addr + 1] << 8)
                + (pgm[addr + 2] << 16)
                + (pgm[addr + 3] << 24)
            )
        except IndexError:
            break
        exec_instr(instr)
    print("Exit")
    dump(MEM)


def exec_instr(instr):
    global PC, REG, MEM, RUN
    print(hex(PC), end=" ")
    op = (instr) & 0b1111111
    rd = (instr >> 7) & 0b11111
    f3 = (instr >> 12) & 0b111
    r1 = (instr >> 15) & 0b11111
    r2 = (instr >> 20) & 0b11111
    f7 = (instr >> 25) & 0b1111111

    # print(hex(PC), hex(instr), bin(instr))
    # print(f"op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}")

    # arith (R)
    if op == 0b0110011:
        if f3 == 0x0 and f7 == 0x00:
            print(f"add r{rd} <- r{r1} + r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] + REG[r2]
        elif f3 == 0x0 and f7 == 0x20:
            print(f"sub r{rd} <- r{r1} - r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] - REG[r2]
        elif f3 == 0x4 and f7 == 0x00:
            print(f"xor r{rd} <- r{r1} ^ r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] ^ REG[r2]
        elif f3 == 0x6 and f7 == 0x00:
            print(f"or r{rd} <- r{r1} | r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] | REG[r2]
        elif f3 == 0x7 and f7 == 0x00:
            print(f"and r{rd} <- r{r1} & r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] & REG[r2]
        elif f3 == 0x1 and f7 == 0x00:
            print(f"sll r{rd} <- r{r1} << r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] << REG[r2]
        elif f3 == 0x5 and f7 == 0x00:
            print(f"srl r{rd} <- r{r1} >> r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] >> REG[r2]
        elif f3 == 0x5 and f7 == 0x20:
            print(f"sra r{rd} <- r{r1} >> r{r2}")
            if rd > 0:
                msb = 1 if REG[r1] & (1 << 32) else 0
                REG[rd] = REG[r1] >> REG[r2]
                if msb:
                    REG[rd] |= (1 << 32)
        elif f3 == 0x2 and f7 == 0x00:
            print(f"slt r{rd} <- r{r1} < r{r2}")
            if rd > 0:
                REG[rd] = 1 if REG[r1] < REG[r2] else 0
        elif f3 == 0x3 and f7 == 0x00:
            print(f"sltu r{rd} <- r{r1} < r{r2}")
            if rd > 0:
                REG[rd] = 1 if unsgn(REG[r1]) < unsgn(REG[r2]) else 0
        elif f3 == 0x0 and f7 == 0x01:
            print(f"mul r{rd} <- r{r1} * r{r2}")
            if rd > 0:
                REG[rd] = (REG[r1] * REG[r2]) & 0xffffffff
        elif f3 == 0x1 and f7 == 0x01:
            print(f"mulh r{rd} <- r{r1} * r{r2}")
            if rd > 0:
                REG[rd] = (REG[r1] * REG[r2]) >> 32
        elif f3 == 0x2 and f7 == 0x01:
            print(f"mulsu r{rd} <- r{r1} * r{r2}")
            if rd > 0:
                REG[rd] = (REG[r1] * unsgn(REG[r2])) >> 32
        elif f3 == 0x3 and f7 == 0x01:
            print(f"mulu r{rd} <- r{r1} * r{r2}")
            if rd > 0:
                REG[rd] = (unsgn(REG[r1]) * unsgn(REG[r2])) >> 32
        elif f3 == 0x4 and f7 == 0x01:
            print(f"div r{rd} <- r{r1} / r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] // REG[r2]
        elif f3 == 0x5 and f7 == 0x01:
            print(f"divu r{rd} <- r{r1} / r{r2}")
            if rd > 0:
                REG[rd] = unsgn(REG[r1]) // unsgn(REG[r2])
        elif f3 == 0x6 and f7 == 0x01:
            print(f"rem r{rd} <- r{r1} % r{r2}")
            if rd > 0:
                REG[rd] = REG[r1] % REG[r2]
        elif f3 == 0x7 and f7 == 0x01:
            print(f"remu r{rd} <- r{r1} % r{r2}")
            if rd > 0:
                REG[rd] = unsgn(REG[r1]) % unsgn(REG[r2])
        else:
            print(
                f"Unknown arith op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}"
            )
    # arith imm (I)
    elif op == 0b0010011:
        val = instr >> 20
        val = extsgn(val)
        if f3 == 0x0:
            print(f"addi r{rd} <- r{r1} + {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] + val
        elif f3 == 0x4 and f7 == 0x00:
            print(f"xori r{rd} <- r{r1} - {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] ^ val
        elif f3 == 0x6 and f7 == 0x00:
            print(f"ori r{rd} <- r{r1} - {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] | val
        elif f3 == 0x7 and f7 == 0x00:
            print(f"andi r{rd} <- r{r1} - {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] & val
        elif f3 == 0x1 and f7 == 0x00:
            print(f"slli r{rd} <- r{r1} << {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] << val
        elif f3 == 0x5 and f7 == 0x00:
            print(f"srli r{rd} <- r{r1} >> {hex(val)}")
            if rd > 0:
                REG[rd] = REG[r1] >> val
        elif f3 == 0x5 and f7 == 0x20:
            print(f"srai r{rd} <- r{r1} >> {hex(val)}")
            if rd > 0:
                msb = 1 if REG[r1] & (1 << 32) else 0
                REG[rd] = REG[r1] >> val
                if msb:
                    REG[rd] |= (1 << 32)
        elif f3 == 0x2 and f7 == 0x00:
            print(f"slti r{rd} <- r{r1} < {hex(val)}")
            if rd > 0:
                REG[rd] = 1 if REG[r1] < val else 0
        elif f3 == 0x3 and f7 == 0x00:
            print(f"sltiu r{rd} <- r{r1} < {hex(val)}")
            if rd > 0:
                REG[rd] = 1 if unsgn(REG[r1]) < val else 0
    # load (I)
    elif op == 0b0000011:
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
                REG[rd] = load(REG[r1] + val, 1, u=True)
            elif f3 == 5:
                REG[rd] = load(REG[r1] + val, 2, u=True)
    # store (S)
    elif op == 0b0100011:
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
    elif op == 0b1100011:
        val = (rd >> 1) + ((f7 & 0b111111) << 4)  # bits 1:10
        if rd & 1 == 1:  # bit 11 set
            val |= 1 << 10
        if val & (1 << 6):  # bit 12 set
            val |= 1 << 11
        val = extsgn(val, 12)
        val = val << 1  # bit 0 is always 0
        print(f"br{f3} r{r1} <-> r{r2} PC + {hex(val)}")
        if (
            (f3 == 0 and REG[r1] == REG[r2])
            or (f3 == 1 and REG[r1] != REG[r2])
            or (f3 == 4 and REG[r1] < REG[r2])
            or (f3 == 5 and REG[r1] >= REG[r2])
            or (f3 == 6 and unsgn(REG[r1]) < unsgn(REG[r2]))
            or (f3 == 7 and unsgn(REG[r1]) >= unsgn(REG[r2]))
        ):
            PC += val
            return
    # jalr (I)
    elif op == 0b1100111:
        if f3 == 0x0:
            val = instr >> 20
            val = extsgn(val)
            print(f"jalr r{rd} = PC+4, PC = r{r1} + {hex(val)}")
            if rd > 0:
                REG[rd] = PC + 4
            PC = REG[r1] + val
            return
    # jal (J)
    elif op == 0b1101111:
        val = (f3 << 12) + (r1 << 15)  # bits 12-19
        if r2 & 1:
            val |= 1 << 11  # bit 11
        val += (r2 & 0b11110) + ((f7 & 0b111111) << 5)  # bits 1-10
        if f7 & (1 << 6):
            val |= 1 << 20  # bit 20
        val = extsgn(val, 21)
        print(f"jal r{rd} = PC + 4, PC += {hex(val)}")
        if rd > 0:
            REG[rd] = PC + 4
        PC += val
        return
    # lui (U)
    elif op == 0b0110111:
        val = (instr >> 12) << 12
        print(f"lui r{rd} <- {hex(val)}")
    # auipc (U)
    elif op == 0b0010111:
        val = (instr >> 12) << 12
        print(f"auipc r{rd} <- PC + {hex(val)}")
        if rd > 0:
            REG[rd] = PC + val
    # ecall/ebreak
    elif op == 0b1110011:
        if f3 == 0 & f7 == 0:
            if r2 == 0:
                print("ecall")
                if REG[17] == 64:  # call write
                    ptr = REG[11]
                    n = REG[12]
                    print(">>> ", end="")
                    while n > 0 and MEM[ptr] != 0:
                        print(chr(MEM[ptr]), end="")
                        ptr += 1
                        n -= 1
                elif REG[17] == 93:  # call exit
                    # dump(MEM)
                    RUN = False
            elif r2 == 1:
                print(f"ebreak")
                RUN = False
            else:
                print(
                    f"Unknown op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}"
                )
    else:
        print(
            f"Unknown op={bin(op)}, f3={hex(f3)}, f7={hex(f7)}, rd={rd}, r1={r1}, r2={r2}"
        )

    # next instruction
    PC += 4


def main():
    global MEM, REG, SYM

    with open(sys.argv[1], "rb") as file:
        elffile = ELFFile(file)
        for section in elffile.iter_sections():
            if isinstance(section, SymbolTableSection):
                for symbol in section.iter_symbols():
                    SYM[symbol.name] = symbol["st_value"]

        textSec = elffile.get_section_by_name(".text")
        start = textSec.header["sh_addr"]
        pgm = bytearray(textSec.data())

        dataSec = elffile.get_section_by_name(".data")
        if dataSec is not None:
            start_data = dataSec.header["sh_addr"]
            size_data = dataSec.header["sh_size"]
            data = bytearray(dataSec.data())

            for addr in range(size_data):
                MEM[start_data + addr] = data[addr]

    print(SYM)
    ## SP
    REG[2] = 0xF0001000
    ## GP
    REG[3] = SYM["__global_pointer$"]

    exec(pgm, start)

if __name__ == "__main__":
    logging.basicConfig()
    main()
