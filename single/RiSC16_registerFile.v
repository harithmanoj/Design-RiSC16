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
    @param  REG_ADDR_LEN                        : Register addressing length (3).
    @param  REG_NUM                             : Number of registers.

    @port   srcA            out [WORD_LENGTH]   : A source register out.
    @port   srcB            out [WORD_LENGTH]   : B source register out.
    @port   adrrA           out [REG_ADDR_LEN]  : A register address.
    @port   addrB           out [REG_ADDR_LEN]  : B register address.
    @port   trgt            in  [WORD_LENGTH]   : Write data.
    @port   addrT           in  [REG_ADDR_LEN]  : Write Address.
    @port   wen             in                  : Write Enable.
    @port   clk             in                  : clock.
    @port   rst             in                  : reset.
*/
module RiSC16_registerFile #(
    WORD_LENGTH = 16,
    REG_ADDR_LEN = 3,
    REG_NUM = 8
) (
    addrA, srcA, addrB, srcB, addrT, trgt,
    wen, clk, rst
);

    input [REG_ADDR_LEN - 1 : 0] addrA;
    input [REG_ADDR_LEN - 1 : 0] addrB;
    input [REG_ADDR_LEN - 1 : 0] addrT;
    input [WORD_LENGTH - 1 : 0] trgt;

    input wen;
    input clk;
    input rst;

    output [WORD_LENGTH - 1 : 0] srcA;
    output [WORD_LENGTH - 1 : 0] srcB;

    reg [WORD_LENGTH - 1 : 0] dataRegister [0 : REG_NUM - 1]

    assign srcA = dataRegister[addrA];
    assign srcB = dataRegister[addrB];

    integer i;

    always @(negedge clk) begin
        if(wen)
            dataRegister[addrT] <= trgt;
        else if(rst)
            for ( i = 0; i < REG_NUM; i = i + 1) begin
                dataRegister[i] <= 0
            end
    end

    
endmodule