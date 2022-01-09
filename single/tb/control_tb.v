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
`include "RiSC16_control.v"

module control_tb;

    reg [2:0] op = 3'b000;
    reg state = 0;
    reg pen = 0;
    wire [1:0] aluFunct;
    wire muxSrc1; 
    wire muxSrc2;
    wire d_wen;
    wire reg_wen;
    wire [1:0] muxTrgt;
    wire muxAddr2;
    wire [1:0] muxPc;

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
                                                    10 to pass PC + 1
        @port   muxAddr2        out                 : 0 to pass rC
                                                    1 to pass rA
        @port   muxPc           out [2]             : 00 to pass PC + 1
                                                    10 to pass PC + 1 + Sign Extended Value
                                                    11 to pass PC + 1 + ALU out

    */
    RiSC16_control #(
        .OP_LEN(3)
    ) control (
        .op(op), 
        .state(state), 
        .pen(pen), 
        .aluFunct(aluFunct),
        .muxSrc1(muxSrc1), 
        .muxSrc2(muxSrc2), 
        .d_wen(d_wen), 
        .reg_wen(reg_wen), 
        .muxTrgt(muxTrgt), 
        .muxAddr2(muxAddr2), 
        .muxPc(muxPc) 
    );

    integer i;
    initial begin
        
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);

        
        for ( i = 0; i< 8; i = i + 1) begin
            #10 op <= op + 1;
        end

        #10 pen <= 1;

        for ( i = 0; i< 8; i = i + 1) begin
            #10 op <= op + 1;
        end

        #10 pen <= 0;
            state <= 1;
        
        for ( i = 0; i< 8; i = i + 1) begin
            #10 op <= op + 1;
        end

        #10 pen <= 1;
            state <= 1;

        for ( i = 0; i< 8; i = i + 1) begin
            #10 op <= op + 1;
        end

        #10 $finish;

    end



endmodule