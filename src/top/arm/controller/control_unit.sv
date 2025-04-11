`timescale 1ns / 1ps

module control_unit(input logic [1:0] Op,
                    input logic [5:0] Funct,
                    input logic [3:0] Rd,
                    // Outputs
                    output logic PCSrc,
                    output logic RegWrite,
                    output logic MemtoReg,
                    output logic MemWrite,
                    output logic [1:0] ALUControl,
                    output logic Branch,
                    output logic ALUSrc,
                    output logic [1:0] FlagWrite,
                    output logic [1:0] ImmSrc,
                    output logic [1:0] RegSrc);
    // Decoder
    decoder DEC(Op, Funct, Rd, FlagWrite, PCSrc, RegWrite, MemWrite, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUControl, Branch);
endmodule