`timescale 1ns / 1ps

module datapathWriteback(input logic [31:0] ReadDataW, ALUOutW,
                         input logic MemtoRegW,
                         output logic [31:0] ResultW); 
    // writeback
    mux2 #(32) wb(ALUOutW, ReadDataW, MemtoRegW, ResultW);
endmodule