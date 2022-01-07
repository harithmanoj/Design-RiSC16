/* 

Implementation of RiSC 16 ISA.
Copyright (C) 2022  Harith Manoj

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>. 

*/

`define ALU_ADD     2'b00
`define ALU_NAND    2'b01
`define ALU_PASSA   2'b10
`define ALU_SUB     2'b11

`define OP_ADD      3'b000
`define OP_ADDI     3'b001
`define OP_NAND     3'b010
`define OP_LUI      3'b011
`define OP_SW       3'b100
`define OP_LW       3'b101
`define OP_BEQ      3'b110
`define OP_JALR     3'b111

