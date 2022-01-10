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
`include "RiSC16_registerFile.v"
`include "RiSC16_alu.v"
`include "RiSC16_control.v"


/**
    @param  WORD_LENGTH                         : Word Length (16).

    @port   instr           in  [WORD_LENGTH]   : Instruction to write to memory.
    @port   addr            in  [WORD_LENGTH]   : Instruction Address.
    @port   clk             in                  : Clock.
    @port   rst             in                  : Reset System.
    @port   pen             in                  : Programming Enable.


    Operating Modes:
        Normal Operation:   Connect square wave oscillator to clk.
                            Set rst low, pen low, instr x.
                            System executes instructions in memory sequentialy.
                            Throughput 1 ipc.

        Reset System:       Connect square wave oscillator to clk.
                            Set rst high, pen low, instr x.
                            Systems clears data memory, sets PC to 0x0000 at clk negedge.

        Programming:        Connect square wave oscillator to clk.
                            (i)     Set rst high, pen high, instr x.
                                    System clears data, instruction memory, sets PC to 0x0000 at clk negedge.

                            (ii)    Set rst low, pen high, instr = I[PC].
                                    System writes instr to data memory at location of PC.
                                    Increments PC.
                                    Writes ar rate 1 ipc.
                                    
                            (iii)   Set rst high, pen low, instr = x.
                                    Resets System ( retains instruction memory).
                                    
                            (iv)    Set rst low, pen low, instr = x.
                                    Normal Operation initiate.

*/
module RiSC16_system #(
    parameter WORD_LENGTH = 16
) (
    clk, addr, pen, instr, rst
);
    input pen;
    input [WORD_LENGTH - 1 : 0] instr;
    input [WORD_LENGTH - 1 : 0] addr;
    input clk;
    input rst;

    reg [WORD_LENGTH - 1 : 0] PC = 0;
    reg [WORD_LENGTH - 1 : 0] PC_in = 0;
    reg [WORD_LENGTH - 1 : 0] IR = 0;
    wire [WORD_LENGTH - 1 : 0] IR_in;
    
    reg i_rst = 0;
    reg [WORD_LENGTH - 1 : 0] i_addr = 0;

    reg [2:0] rf_addr2 = 0;
    wire rf_wen;
    reg [WORD_LENGTH - 1 : 0] rf_tgt = 0 ;

    wire [WORD_LENGTH - 1 : 0] rf_src1;
    wire [WORD_LENGTH - 1 : 0] rf_src2;

    wire [WORD_LENGTH - 1 : 0] d_out;
    wire d_wen;

    reg [WORD_LENGTH - 1 : 0] alu_1 = 0;
    reg [WORD_LENGTH - 1 : 0] alu_2 = 0;
    wire alu_state;
    wire [`ALU_FUNCT_LEN - 1 : 0] alu_funct;
    wire [WORD_LENGTH - 1 : 0] alu_out;

    wire muxSrc1;
    wire muxSrc2;
    wire [1:0] muxTrgt;
    wire muxAddr2;
    wire [1:0] muxPc;

    reg [WORD_LENGTH - 1 : 0] pc_inc = 0;

    wire [2:0] op;
    wire [2:0] rf_addr1;
    wire [2:0] rf_addrT;

    assign op = IR[15:13];
    assign rf_addr1 = IR[9:7];
    assign rf_addrT = IR[12:10];

    RiSC16_control #(
        .OP_LEN(3)
    ) control (
        .op(op), 
        .state(alu_state), 
        .pen(pen), 
        .aluFunct(alu_funct), 
        .muxSrc1(muxSrc1), 
        .muxSrc2(muxSrc2),
        .d_wen(d_wen), 
        .reg_wen(rf_wen), 
        .muxTrgt(muxTrgt), 
        .muxAddr2(muxAddr2),  
        .muxPc(muxPc)
    );

    RiSC16_memory #(
        .WORD_LENGTH(16),
        .MEM_SIZE(65536) 
    ) data_mem (
        .dataOut(d_out), 
        .address(alu_out), 
        .dataIn(rf_src2), 
        .clk(clk), 
        .writeEn(d_wen), 
        .rst(rst) 
    );

    RiSC16_registerFile #(
        .WORD_LENGTH(16),
        .REG_ADDR_LEN(3),
        .REG_NUM(8)
    ) rf (
        .addr1(rf_addr1), 
        .src1(rf_src1), 
        .addr2(rf_addr2), 
        .src2(rf_src2), 
        .addrT(rf_addrT), 
        .trgt(rf_tgt),
        .wen(rf_wen), 
        .clk(clk), 
        .rst(rst)
    );

    RiSC16_alu #(
        .WORD_LENGTH(16)
    ) alu (
        .src1(alu_1), 
        .src2(alu_2), 
        .result(alu_out), 
        .state(alu_state), 
        .funct(alu_funct)
    );

    RiSC16_memory #(
        .WORD_LENGTH(16),
        .MEM_SIZE(65536) 
    ) instr_mem (
        .dataOut(IR_in), 
        .address(i_addr), 
        .dataIn(instr), 
        .clk(clk), 
        .writeEn(pen), 
        .rst(i_rst) 
    );

    always @(*) begin
        i_rst = rst & pen;
        pc_inc = PC + 1;

        if(rst & pen) begin
            PC_in <= 0;
            i_addr <= addr;
        end else if(pen & ~rst) begin
            PC_in <= pc_inc;
            i_addr <= addr;
        end else if(~pen & rst) begin
            PC_in <= 0;
            i_addr <= PC;
        end else if(~pen & ~rst) begin
            if(muxAddr2)
                rf_addr2 <= IR[12:10];
            else
                rf_addr2 <= IR[2:0];
            
            if(muxSrc1)
                alu_1 <= { IR[9:0], 6'b000000};
            else
                alu_1 <= rf_src1;

            if(muxSrc2)
                alu_2 <= { {9{IR[6]}}, IR[6:0]};
            else
                alu_2 <= rf_src2;

            case (muxTrgt)
                2'b00: rf_tgt <= d_out;
                2'b01: rf_tgt <= alu_out;
                2'b10: rf_tgt <= pc_inc;
                default: rf_tgt = d_out;
            endcase

            case (muxPc)
                
                2'b00: begin
                    PC_in <= pc_inc;
                end

                2'b10: begin
                    PC_in <= pc_inc + { {9{IR[6]}}, IR[6:0]};
                end

                2'b11: begin
                    PC_in <= pc_inc + alu_out;
                end

                default: begin
                    PC_in <= pc_inc;
                end
            endcase
            i_addr <= PC;

        end
    end

    always @(negedge clk) begin
        IR <= IR_in;     
        PC <= PC_in;
        
    end
        
endmodule