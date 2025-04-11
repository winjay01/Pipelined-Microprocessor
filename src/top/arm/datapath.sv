`timescale 1ns / 1ps

module datapath(input logic clk, reset,
                // Instruction memory ports
                output logic [31:0] PCF,
                input logic [31:0] InstrF,
                // Data memory ports
                output logic [31:0] ALUOutM, WriteDataM,
                input logic [31:0] ReadDataM,
                // Controller ports
                input logic PCSrcW, BranchTakenE, RegWriteW,
                input logic [1:0] RegSrcD, ImmSrcD,
                input logic ALUSrcE, MemtoRegW,
                input logic [1:0] ALUControlE,
                output logic [3:0] ALUFlags,
                output logic [31:12] InstrC,
                // Hazard Unit ports
                input logic StallF, StallD, FlushD, FlushE,
                input logic [1:0] ForwardAE, ForwardBE,
                output logic [4:0] Match);
    // decode logic
    logic [31:0] InstrD, PCPlus8D;
    logic [31:0] SrcAD, SrcBD;
    logic [3:0] WA3D;
    logic [31:0] ExtImmD;
    logic [3:0] RA1D, RA2D;
    
    // execute logic
    logic [3:0] RA1E, RA2E;
    logic [31:0] RD1E, RD2E;
    logic [3:0] WA3E;
    logic [31:0] ExtImmE;
    logic [31:0] ALUResultE;
    logic [31:0] WriteDataE;
    
    // memory logic
    logic [3:0] WA3M;
    
    // writeback logic
    logic [3:0] WA3W;
    logic [31:0] ALUOutW;
    logic [31:0] ResultW;
    logic [31:0] ReadDataW;
    
    // fetch -> decode
    //flopenr #(32) FREG(clk, reset, ~StallD, InstrF, InstrD);
    flushenreg #(32) FREG(clk, reset, FlushD, ~StallD, InstrF, InstrD);
    
    // decode -> execute
    flushreg #(32) DREG1(clk, reset, FlushE, SrcAD, RD1E);
    flushreg #(32) DREG2(clk, reset, FlushE, SrcBD, RD2E);
    flushreg #(4) DREG3(clk, reset, FlushE, WA3D, WA3E);
    flushreg #(32) DREG4(clk, reset, FlushE, ExtImmD, ExtImmE);
    flushreg #(4) DREG5(clk, reset, FlushE, RA1D, RA1E);
    flushreg #(4) DREG6(clk, reset, FlushE, RA2D, RA2E);
    
    // execute -> memory
    flopr #(4) EREG1(clk, reset, WA3E, WA3M);
    flopr #(32) EREG2(clk, reset, ALUResultE, ALUOutM);
    flopr #(32) EREG3(clk, reset, WriteDataE, WriteDataM);
    
    // memory -> writeback
    flopr #(4) MREG1(clk, reset, WA3M, WA3W);
    flopr #(32) MREG2(clk, reset, ReadDataM, ReadDataW);
    flopr #(32) MREG3(clk, reset, ALUOutM, ALUOutW);
    
    datapathFetch dpf(clk, reset, StallF, PCSrcW, BranchTakenE, ALUResultE, ResultW, PCF, PCPlus8D);
    datapathDecode dpd(clk, reset, RegSrcD, ImmSrcD, InstrD, PCPlus8D, WA3W, ResultW, RegWriteW, SrcAD, SrcBD, WA3D, ExtImmD, RA1D, RA2D);
    datapathExecute dpe(RD2E, ExtImmE, RD1E, ALUResultE, ALUFlags, ALUSrcE, ALUControlE, WriteDataE, ALUOutM, ResultW, ForwardAE, ForwardBE);
    //datapathMemory dpm(clk, reset);
    datapathWriteback dpw(ReadDataW, ALUOutW, MemtoRegW, ResultW);
    
    // Controller outputs
    assign InstrC = InstrD[31:12];
    // Hazard outputs
    logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
    assign Match_1E_M = (RA1E == WA3M);
    assign Match_1E_W = (RA1E == WA3W);
    assign Match_2E_M = (RA2E == WA3M);
    assign Match_2E_W = (RA2E == WA3W);
    assign Match_12D_E = (RA1D == WA3E) | (RA2D == WA3E);
    assign Match = {Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E};
endmodule