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
`include "RiSC16_memory.v"


module memory_tb;

    wire [15:0] dataOut;
    
    reg [15:0] address = 16'b0000;
    reg [15:0] dataIn = 16'b0000;
    reg clk = 0;
    reg writeEn = 0;
    reg rst = 0;

    RiSC16_memory #(
        .WORD_LENGTH(16),
        .MEM_SIZE(65536)
    ) mem (
        .dataOut(dataOut),
        .address(address), 
        .dataIn(dataIn), 
        .clk(clk), 
        .writeEn(writeEn),
        .rst(rst)
    );

    initial begin
        $monitor("%g: writeEn %h, rst %h, address %h, dataIn %h, dataOut %h", 
            $time, writeEn, rst, address, dataIn, dataOut);

        $dumpfile("memory_tb.vcd");
        $dumpvars(0, memory_tb);

        #10         address     <= 15'h1222;
                    dataIn      <= 15'h2000;
                    writeEn     <= 1;
                    rst         <= 0;
        
        #10         rst         <= 1;
                    writeEn     <= 0;

        #10         $finish;
    end

    always #7 clk <= ~clk;

endmodule