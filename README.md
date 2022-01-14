# AE-Design-RiSC16
Implementation of the RiSC 16 ( Ridiculously Simple Computer) Instruction Set Architecture

# RISC16 Architecture
## Registers

Accessible registers r0 to r7.

r0 always has value 0, even after writing to it.

Register can be accesed in instructions with R*, r*, * where * is [0, 7]

## Memory Architecture

Harvard Architecture Memory.

Addressing with 16 bits.

Load Store memory access.

## Instruction Info


<table>
    <tr>
        <th> Instruction </th>
        <th> Op Code[3] </th>
        <th> field A[3] </th>
        <th> field B[3] </th>
        <th> field K[4] </th>
        <th> field C[3] </th>
        <th> Description</th>
    </tr>
    <tr>
        <td> add </td>
        <td> 000 </td>
        <td> A </td>
        <td> B </td>
        <td> 0000 </td>
        <td> C </td>
        <td> A <= B + C </td>
    </tr>
    <tr>
        <td> addi </td>
        <td> 001 </td>
        <td> A </td>
        <td> B </td>
        <td colspan="2"> Immediate (7) [-64, 63] </td>
        <td> A <= B + imm </td>
    </tr>
    <tr>
        <td> nand </td>
        <td> 010 </td>
        <td> A </td>
        <td> B </td>
        <td> 0000 </td>
        <td> C </td>
        <td> A <= ~(B & C) </td>
    </tr>
    <tr>
        <td> lui </td>
        <td> 011 </td>
        <td> A </td>
        <td colspan="3"> Immediate (10) [0, 0x3ff] </td>     
        <td> A <= [ imm : 000000 ] </td>
    </tr>
    <tr>
        <td> sw </td>
        <td> 100 </td>
        <td> A </td>
        <td> B </td>
        <td colspan="2"> Immediate (7) [-64, 63] </td>
        <td> Mem[B + imm] <= A </td>
    </tr>
    <tr>
        <td> lw </td>
        <td> 101 </td>
        <td> A </td>
        <td> B </td>
        <td colspan="2"> Immediate (7) [-64, 63] </td>
        <td> A <= Mem[B + imm] </td>
    </tr>
    <tr>
        <td> beq </td>
        <td> 110 </td>
        <td> A </td>
        <td> B </td>
        <td colspan="2"> Immediate (7) [-64, 63] </td>
        <td> PC <= PC + 1 + if (A == B) Immed else 0</td>
    </tr>
    <tr>
        <td> jalr </td>
        <td> 111 </td>
        <td> A </td>
        <td> B </td>
        <td colspan="2"> 0000000 </td>
        <td> A <= PC + 1 ; PC <= PC + 1 + B</td>
    </tr>
</table>

# Assembler Support

- All Instructions

## Psuedo Instructions

<table>
    <tr>
        <th> Pseudo Instruction </th>
        <th> Instruction        </th>
        <th> Description        </th>
    </tr>
    <tr>
        <td> nop <td>
        <td> add 0, 0, 0 </td>
        <td> No operation </td>
    </tr>
    <tr>
        <td> lli a, immed <td>
        <td> addi a, a, imm[5:0] </td>
        <td> load lower 6 bits in immed to register a</td>
    </tr>
    <tr>
        <td> movi a, immed </td>
        <td> lui a, immed[15:6]
             addi a, a, imm[5:0]</td>
        <td> Load 16 bit value into register </td>
    </tr>
</table>

# Assembler Directives

<table>
    <tr> 
        <th> Directive </th>
        <th> Description </th>
    </tr>
    <tr>
        <td> label: .fill immed </td>
        <td> allocate 16 byte value in memory </td>
    </tr>
    <tr>
        <td> label: .space immed </td>
        <td> allocate 0 filled immed number of 16 byte loc in memory </td>
    <tr>
        <td> label: .ascii "string" </td>
        <td> allocate array filled with null terminated ascii string</td>
    </tr>
    <tr>
        <td> label: .const immed </td>
        <td> replace label in program with assembl time constant provided as immed. </td>
    </tr>
</table>

# Single Cycle Implementation

## PinOut

- instr           in  [16]   : Instruction to write to memory.
- addr            in  [16]   : Instruction Address.
- clk             in         : Clock.
- rst             in         : Reset System.
- pen             in         : Programming Enable.

## Modes of Operation

- Normal Execution:
    - instr     = x
    - addr      = x
    - rst       = 0
    - pen       = 0
    - clk       = square wave oscillator [0, 1]
    - Executes instructions in instruction memory one by one.

- Reset / Idle Mode:
    - instr     = x
    - addr      = x
    - rst       = 1
    - pen       = 0
    - clk       = square wave oscillator [0, 1]
    - Clears Data Memory and sets PC to 0x0000 at negative clock edge.

- Nuking Mode:
    - instr     = x
    - addr      = x
    - rst       = 1
    - pen       = 1
    - clk       = square wave oscillator [0, 1]
    - Clears Data and Instruction Memory, sets PC to 0x0000 at negative clock edge.

- Programming Mode:
    - instr     = Instruction to be written.
    - addr      = Address of Instruction to be written.
    - rst       = 0
    - pen       = 1
    - clk       = square wave oscillator [0, 1]
    - Writes instr to address addr of instruction memory at negative clock edge.


# References

https://user.eng.umd.edu/~blj/RiSC/

https://user.eng.umd.edu/~blj/RiSC/RiSC-seq.pdf

https://user.eng.umd.edu/~blj/RiSC/RiSC-isa.pdf
