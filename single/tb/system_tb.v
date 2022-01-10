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
`include "RiSC16_system.v"

module system_tb;

    reg clk = 0;
    reg pen = 1;
    reg rst = 1;
    reg [15:0] instr = 16'h0000;
    reg [15:0] addr = 16'h0000;


    RiSC16_system #(
        .WORD_LENGTH(16)
    ) system (
        .clk(clk), 
        .addr(addr),
        .pen(pen), 
        .instr(instr), 
        .rst(rst)
    );


    initial begin
        

        $monitor("%g: pc %h, IR %h", $time, system.PC, system.IR);
        $dumpfile("system_tb.vcd");
        $dumpvars(0, system_tb);
        $dumpvars(0, system_tb.system.rf.dataRegister[2]);

        $display("System Purge");

        $display("System Programming");
        $display("b0110101000000000 lui 2, 0x200");
        #6      instr   <= 16'b0110101000000000;
                addr    <= 16'h0000;
                rst     <= 0;

        $display("b0110110100000000 lui 3, 0x100");
        #4     instr   <= 16'b0110110100000000;
                addr    <= 16'h0001;

        $display("b0000100100000011 add 2, 2, 3");
        #4     instr   <= 16'b0000100100000011;
               addr    <= 16'h0002;
        
        $display("Finish Programming to Reset");
        #4     pen     <= 0;
                rst     <= 1;

        #4     rst     <= 0;

        #16     $finish;

    end

    always #2 clk <= ~clk;

endmodule

