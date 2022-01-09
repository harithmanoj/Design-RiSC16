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
`include "RiSC16_registerFile.v"

module registerFile_tb;

    reg [2:0] addr1 = 3'b000;
    reg [2:0] addr2 = 3'b000;
    reg [2:0] addrT = 3'b000;
    reg [15:0] trgt = 16'h0000;
    reg wen = 0;
    reg clk = 0;
    reg rst = 0;


    wire [15:0] src1;
    wire [15:0] src2;

    RiSC16_registerFile #(
        .WORD_LENGTH(16),
        .REG_ADDR_LEN(3),
        .REG_NUM(8)
    ) regFile (
        .addr1(addr1), 
        .src1(src1), 
        .addr2(addr2), 
        .src2(src2), 
        .addrT(addrT), 
        .trgt(trgt),
        .wen(wen), 
        .clk(clk), 
        .rst(rst)
    );

    initial begin
        
        $dumpfile("registerFile_tb.vcd");
        $dumpvars(0, registerFile_tb);

        #10     rst     <= 1;

        #10     rst     <= 0;

        #10     addrT   <= 3'b001;
                trgt    <= 16'h1234;
                wen     <= 1;

        #10     wen     <= 0;
        
        #10     addr1   <= 3'b001;
        
        #10     rst     <= 1;

        #10     rst     <= 0;

        #10     addrT   <= 3'b000;
                trgt    <= 16'h2356;
                wen     <= 1;
                addr1   <= 3'b000;
            
        #10     wen     <= 0;

        #10     $finish;
    end

    always #7 clk <= ~clk;

endmodule
