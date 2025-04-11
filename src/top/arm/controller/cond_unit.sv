`timescale 1ns / 1ps

module cond_unit(input logic clk, reset,
                 input logic [1:0] FlagWrite,
                 input logic [3:0] Cond,
                 input logic [3:0] Flags,
                 output logic CondEx,
                 output logic [3:0] FlagsNext);
    // Intermediate Signals             
    logic [1:0] FlagWriteN;
                 
    assign FlagWriteN = FlagWrite & {2{CondEx}};
    flopenr # (2) R1(clk, reset, FlagWriteN[1], Flags[3:2], FlagsNext[3:2]);
    flopenr # (2) R2(clk, reset, FlagWriteN[0], Flags[1:0], FlagsNext[1:0]);
    
    // Condition Check from single-cycle conditional logic in control unit
    condition_check CC(Cond, FlagsNext, CondEx);
endmodule