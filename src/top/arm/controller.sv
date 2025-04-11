`timescale 1ns / 1ps

module controller(input logic clk, reset,
                  input logic [3:0] ALUFlags,
                  input logic [31:12] Instr,
                  // Decode stage outputs
                  output logic [1:0] RegSrcD,
                  output logic [1:0] ImmSrcD,
                  // Execute stage outputs
                  output logic ALUSrcE,
                  output logic [1:0] ALUControlE,
                  // Memory stage outputs
                  output logic MemWriteM,
                  // Writeback stage outputs
                  output logic MemtoRegW,
                  output logic RegWriteW,
                  output logic PCSrcW,
                  // Hazard signals
                  output logic RegWriteM, MemtoRegE, BranchTakenE,
                  input logic FlushE,
                  output logic PCSrcD, PCSrcE, PCSrcM);
    // Control Unit Signals
    logic [1:0] Op;
    logic [5:0] Funct;
    logic [3:0] Rd; 
    
    assign Op = Instr[27:26];
    assign Funct = Instr[25:20];
    assign Rd = Instr[15:12];
     
    // Intermediate Signals
    // Decode stage
    logic [1:0] ALUControlD;
    logic RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUSrcD;
    logic [1:0] FlagWriteD;
    logic [17:0] Din, Dout;
    
    // Execute stage
    logic [3:0] CondE;
    logic [3:0] FlagsE, FlagsNext;
    logic RegWriteE, MemWriteE, BranchE;
    logic [1:0] FlagWriteE;
    logic CondExE;
    logic [3:0] Ein, Eout;
    
    // Memory stage
    logic MemtoRegM;
    logic [2:0] Min, Mout;
    
    // Control Unit
    control_unit C(Op, Funct, Rd, PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD, BranchD, ALUSrcD, FlagWriteD, ImmSrcD, RegSrcD);
    
    // Execute stage logic
    cond_unit CU(clk, reset, FlagWriteE, CondE, ALUFlags, CondExE, FlagsNext);
    logic E1, E2, E3, E4;
    //assign E1 = (PCSrcE & CondExE) | (BranchE & CondExE);
    assign E1 = (PCSrcE & CondExE);
    assign E2 = RegWriteE & CondExE;
    assign E3 = MemtoRegE;
    assign E4 = MemWriteE & CondExE;
    assign BranchTakenE = (BranchE & CondExE);
    
    // Registers for each stage
    // Decode register
    assign Din = {PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUControlD[1:0], BranchD, ALUSrcD, FlagWriteD[1:0], Instr[31:28], FlagsNext};
    flushreg # (18) REGD(clk, reset, FlushE, Din, Dout);
    assign       {PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUControlE, BranchE, ALUSrcE, FlagWriteE, CondE, FlagsE} = Dout;
    
    // Execute register
    assign Ein = {E1, E2, E3, E4};
    flopr # (4) REGE(clk, reset, Ein, Eout);
    assign       {PCSrcM, RegWriteM, MemtoRegM, MemWriteM} = Eout;
    
    // Memory register
    assign Min = {PCSrcM, RegWriteM, MemtoRegM};
    flopr # (3) REGM(clk, reset, Min, Mout);
    assign       {PCSrcW, RegWriteW, MemtoRegW} = Mout;
endmodule