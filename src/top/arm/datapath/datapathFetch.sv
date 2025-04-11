`timescale 1ns / 1ps

module datapathFetch(input logic clk, reset, StallF,
                     input logic PCSrcW, // Controller --> Mux
                     input logic BranchTakenE,
                     input logic [31:0] ALUResultE,
                     input logic [31:0] ResultW, // Writeback --> Mux
                     output logic [31:0] PCF,
                     output logic [31:0] PCPlus8D);
    logic [31:0] PCNext0, PCNext, PCPlus4F;
    // calc next PC
    mux2 #(32) pcmux1(PCPlus4F, ResultW, PCSrcW, PCNext0);
    mux2 #(32) pcmux2(PCNext0, ALUResultE, BranchTakenE, PCNext);
    flopenr #(32) pcreg(clk, reset, ~StallF, PCNext, PCF);
    adder #(32) pcadd1(PCF, 32'b100, PCPlus4F);
    adder #(32) pcadd2(PCPlus4F, 32'b100, PCPlus8D);
endmodule