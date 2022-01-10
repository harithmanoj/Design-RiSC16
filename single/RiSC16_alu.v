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
    @param  WORD_LENGTH                         : World Length (16).

    @port   src1            in  [WORD_LENGTH]   : input Source.
    @port   src2            in  [WORD_LENGTH]   : input Source.
    @port   result          out [WORD_LENGTH]   : output Result.
    @port   state           out                 : true if zero out.
    @port   funct           in  [ALU_FUNCT_LEN] : Alu opcode.
                                ALU_ADD         : add operation.
                                ALU_NAND        : nand operation.
                                ALU_PASSA       : pass src1 to result.
                                ALU_SUB         : subtraction result.
*/
module RiSC16_alu #(
    parameter WORD_LENGTH = 16
) (
    src1, src2, result, state, funct
);

    output reg [WORD_LENGTH - 1 : 0] result = 0;
    output reg state = 0;

    input [WORD_LENGTH - 1 : 0] src1;
    input [WORD_LENGTH - 1 : 0] src2;
    input [`ALU_FUNCT_LEN - 1 : 0] funct;

    always @(*) begin
        
        case(funct)

            `ALU_ADD:   result <= src1 + src2;
            `ALU_NAND:  result <= ~(src1 & src2);
            `ALU_PASSA: result <= src1;
            `ALU_SUB:   result <= src1 - src2;
            default:    result <= 0;

        endcase

        state = &(~result);

    end
    
endmodule