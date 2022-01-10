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
    @param  MEM_SIZE                            : Memory Size (65536).

    @port   dataOut         out [WORD_LENGTH]   : data at address.
    @port   dataIn          in  [WORD_LENGTH]   : input data.
    @port   address         in  [WORD_LENGTH]   : address to use.
    @port   clk             in                  : clock.
    @port   writeEn         in                  : Write dataIn to memory.
    @port   rst             in                  : Reset Memory to 0.
*/
module RiSC16_memory #(
    parameter WORD_LENGTH = 16,
    parameter MEM_SIZE = 65536
) (
    dataOut, address, dataIn, clk, writeEn, rst
);

    input [WORD_LENGTH - 1 : 0] address;
    output reg [WORD_LENGTH - 1 : 0] dataOut;
    input writeEn;
    input [WORD_LENGTH - 1 : 0] dataIn;
    input clk;
    input rst;

    reg [WORD_LENGTH - 1 : 0] memoryArray [0 : MEM_SIZE - 1];

    integer i;
    
    always @(*) begin
        dataOut = memoryArray[address];
    end

    always @(negedge clk) begin
        if(rst)
            for (i = 0; i < MEM_SIZE; i = i + 1) begin
                memoryArray[i] <= 0;
            end
        else if(writeEn)
            memoryArray[address] <= dataIn;
    end

endmodule