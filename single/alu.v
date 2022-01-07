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

`include "defines.v"

/**
    @param  WORD_LENGTH                         : World Length.

    @port   srcA            in  [WORD_LENGTH]   : input Source.
    @port   srcB            in  [WORD_LENGTH]   : input Source.
    @port   result          out [WORD_LENGTH]   : output Result.
    @port   state           out                 : true if zero out.
    @port   funct           in  [ALU_FUNCT_LEN] : Alu opcode.
                                ALU_ADD         : add operation.
                                ALU_NAND        : nand operation.
                                ALU_PASSA       : pass srcA to result.
                                ALU_SUB         : subtraction result.
*/
module RiSC16_alu #(
    WORD_LENGTH = 16
) (
    srcA, srcB, result, state, funct
);

    output reg [WORD_LENGTH - 1 : 0] result;
    output reg state;

    input [WORD_LENGTH - 1 : 0] srcA;
    input [WORD_LENGTH - 1 : 0] srcB;
    input [`ALU_FUNCT_LEN - 1 : 0] srcA;

    always @(*) begin
        
        case(funct):

            `ALU_ADD:   result <= srcA + srcB
            `ALU_NAND:  result <= ~(srcA & srcB)
            `ALU_PASSA: result <= srcA
            `ALU_SUB:   result <= srcA - srcB
            default:    resut <= WORD_LENGTH'b0

        endcase

        state <= &(~result)

    end
    
endmodule