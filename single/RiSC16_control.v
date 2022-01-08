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

/**

    @param  OP_LEN                              : OpCode Length (3).

    @port   op              in  [OP_LEN]        : instruction opcode.
    @port   state           in                  : True if result is zero.
    @port   pen             in                  : Enable Program Memory Setup.
    @port   aluFunct        out [ALU_FUNCT_LEN] : ALU opcode.
    @port   muxSrc1         out                 : 0 to pass Register value,
                                                  1 to pass Left Shifted Immediate Value.
    @port   muxSrc2         out                 : 0 to pass Register value,
                                                  1 to pass Sign Extended Value.
    @port   d_wen           out                 : Write Data Memory Enable.
    @port   reg_wen         out                 : Write Register File Enable.
    @port   muxTrgt         out [2]             : 00 to pass data memory out,
                                                  01 to pass ALU out,
                                                  10 to pass PC + 2
    @port   muxAddr2        out                 : 0 to pass rC
                                                  1 to pass rA
    @port   muxPc           out [2]             : 00 to pass PC + 2
                                                  10 to pass PC + 2 + Sign Extended Value
                                                  11 to pass PC + 2 + ALU out

*/
module RiSC16_control #(
    OP_LEN = 3
) (
    op, state, pen, 
    aluFunct, muxSrc1, muxSrc2, 
    d_wen, reg_wen, muxTrgt, muxAddr2, muxPc
);

    input [OP_LEN - 1 : 0] op;
    input state;
    input pen;

    output [`ALU_FUNCT_LEN - 1 : 0] aluFunct;
    output muxSrc1;
    output muxSrc2;
    output d_wen;
    output reg_wen;
    output [1:0] muxTrgt;
    output muxAddr2;
    output [1:0] muxPc;

    always @(*) begin
        
        case (op)
            `OP_ADD:    begin
                aluFunct    <= `ALU_ADD;
                muxSrc1     <= 0;
                muxSrc2     <= 0;
                d_wen       <= 0;
                reg_wen     <= 1;
                muxTrgt     <= 2'b01;
                muxAddr2    <= 0;
                muxPc       <= 2'b00;
            end

            `OP_ADDI:   begin
                aluFunct    <= `ALU_ADD;
                muxSrc1     <= 0;
                muxSrc2     <= 1;
                d_wen       <= 0;
                reg_wen     <= 1;
                muxTrgt     <= 2'b01;
                muxAddr2    <= 0;
                muxPc       <= 2'b00;
            end

            `OP_NAND:   begin
                aluFunct    <= `ALU_NAND;
                muxSrc1     <= 0;
                muxSrc2     <= 0;
                d_wen       <= 0;
                reg_wen     <= 1;
                muxTrgt     <= 2'b01;
                muxAddr2    <= 0;
                muxPc       <= 2'b00;
            end

            `OP_LUI:    begin
                aluFunct    <= `ALU_PASSA;
                muxSrc1     <= 1;
                muxSrc2     <= 0;
                d_wen       <= 0;
                reg_wen     <= 1;
                muxTrgt     <= 2'b01;
                muxAddr2    <= 0;
                muxPc       <= 2'b00;
            end

            `OP_SW:     begin
                aluFunct    <= `ALU_ADD;
                muxSrc1     <= 0;
                muxSrc2     <= 1;
                d_wen       <= 1;
                reg_wen     <= 0;
                muxTrgt     <= 2'b00;
                muxAddr2    <= 1;
                muxPc       <= 2'b00;
            end

            `OP_LW:     begin
                aluFunct    <= `ALU_ADD;
                muxSrc1     <= 0;
                muxSrc2     <= 1;
                d_wen       <= 0;
                reg_wen     <= 1;
                muxTrgt     <= 2'b00;
                muxAddr2    <= 0;
                muxPc       <= 2'b00;
            end

            `OP_BEQ:     begin
                aluFunct    <= `ALU_SUB;
                muxSrc1     <= 0;
                muxSrc2     <= 0;
                d_wen       <= 0;
                reg_wen     <= 0;
                muxTrgt     <= 2'b00;
                muxAddr2    <= 1;
                muxPc       <= 2'b10;
            end
            
            `OP_JALR:     begin
                aluFunct    <= `ALU_PASSA;
                muxSrc1     <= 0;
                muxSrc2     <= 0;
                d_wen       <= 0;
                reg_wen     <= 1;
                muxTrgt     <= 2'b10;
                muxAddr2    <= 0;
                muxPc       <= 2'b11;
            end
            default:        begin
                aluFunct    <= `ALU_ADD;
                muxSrc1     <=  0;
                muxSrc2     <=  0;
                d_wen       <=  0;
                reg_wen     <=  0;
                muxTrgt     <=  2'b00;
                muxAddr2    <=  0;
                muxPC       <=  2'b00;
            end
        endcase

    end
    
endmodule