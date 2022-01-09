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
`timescale 1us/1ns

`include "defines.v"
`include "RiSC16_alu.v"


module alu_tb;


    reg [15:0] src1;
    reg [15:0] src2;
    reg [`ALU_FUNCT_LEN - 1:0] funct;

    wire [15:0] result;
    wire state;


    RiSC16_alu #(      
        .WORD_LENGTH(16)
    ) alu (
        .src1(src1), 
        .src2(src2), 
        .result(result), 
        .state(state), 
        .funct(funct)
    );

    initial begin
        
        $monitor("%g : src1 %h O src2 %h (%h funct) => ( %h state, %h result)", 
            $time, src1, src2, funct, state, result );
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        #10     src1    <= 16'h1111;
                src2    <= 16'heaaa;
                funct   <= `ALU_ADD;

        #10     src1    <= 16'h2222;
                src2    <= 16'h2222;
                funct   <= `ALU_SUB;


        #10     $finish;

    end

endmodule