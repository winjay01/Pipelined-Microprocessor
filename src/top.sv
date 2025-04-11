`timescale 1ns / 1ps
// Top level module:
// Combine datapath + controller + hazard unit, data memory, instruction memory

module top(input logic clk, reset,
           output logic [31:0] DataWD, DataA,
           output logic DataWE);
           
    // Intermediate Signals
    // Instruction Memory
    logic [31:0] InstrA, InstrRD;
    // InstrA is PCF, InstrRD is InstrF
    
    // Data Memory
    logic [31:0] DataRD;
    // DataRD is ReadDataM
    
    // Instruction memory
    imem im(InstrA, InstrRD);
    // Data Memory
    dmem dm(clk, reset, DataWE, DataA, DataWD, DataRD);
    // Datapath + Controller module. Includes register file
    arm dc(clk, reset, InstrA, InstrRD, DataWE, DataA, DataWD, DataRD);
endmodule