`timescale 1ns / 1ps

// Combined controller and datapath and hazard unit

module arm(input logic clk, reset,
           // Instruction memory ports
           output logic [31:0] PCF,
           input logic [31:0] InstrF,
           // Data memory ports
           output logic MemWriteM,
           output logic [31:0] ALUOutM, WriteDataM,
           input logic [31:0] ReadDataM);
    // Intermediate Signals
    logic [3:0] ALUFlags;
    logic RegWriteW, ALUSrcE, MemtoRegW, PCSrcW;
    logic [1:0] RegSrcD, ImmSrcD, ALUControlE;
    logic [19:0] InstrC;
    logic BranchTakenE;
    // Hazard unit signals
    logic RegWriteM, MemtoRegE, PCSrcD, PCSrcE, PCSrcM;
    logic StallF, StallD, FlushD, FlushE;
    logic [1:0] ForwardAE, ForwardBE;
    logic [4:0] Match;
    
    // Datapath
    datapath d(clk, reset, PCF, InstrF, ALUOutM, WriteDataM, ReadDataM, PCSrcW, BranchTakenE, RegWriteW, RegSrcD, ImmSrcD, ALUSrcE, MemtoRegW, ALUControlE, ALUFlags, InstrC, StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE, Match); 
    
    // Controller
    controller c(clk, reset, ALUFlags, InstrC, RegSrcD, ImmSrcD, ALUSrcE, ALUControlE, MemWriteM, MemtoRegW, RegWriteW, PCSrcW, RegWriteM, MemtoRegE, BranchTakenE, FlushE, PCSrcD, PCSrcE, PCSrcM); 
    
    // Hazard Unit
    hazard_unit hu(StallF, StallD, FlushD, FlushE, ForwardAE, ForwardBE, Match, RegWriteM, RegWriteW, MemtoRegE, PCSrcD, PCSrcE, PCSrcM, PCSrcW, BranchTakenE);
endmodule