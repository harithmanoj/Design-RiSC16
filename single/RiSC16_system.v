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
`include "RiSC16_memory.v"

module RiSC16_system #(
    WORD_LENGTH = 16
) (
    clk, pen, instr
);
    input pen;
    input [WORD_LENGTH - 1 : 0] instr;
    input clk;

    reg [WORD_LENGTH - 1 : 0] PC = 0;
    reg [WORD_LENGTH - 1 : 0] IR = 0;
    
    reg i_wen = 0;
    reg i_rst = 0

    module RiSC16_memory #(
            .WORD_LENGTH(16),
            .MEM_SIZE(65536) ) instr_mem (
            .dataOut(IR), .address(PC), .dataIn(instr), .clk(clk), .writeEn(i_wen), .rst(i_rst) );

    always @(posedge pen) begin
        if(rst) begin
            i_rst = 1;
        end
    end

    always @(negedge rst) begin
        if(pen) begin
            i_wen = 1;
            i_rst = 0;
            PC <= 0
        end
    end

    always @(negedge pen) begin
        if(~rst) begin
            i_wen = 0;
            PC <= 0;
        end
    end
        
    
    
endmodule