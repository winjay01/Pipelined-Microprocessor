`timescale 1ns / 1ps

module datapathDecode(input logic clk, reset,
                      input logic [1:0] RegSrcD, ImmSrcD,
                      input logic [31:0] InstrD, PCPlus8D,
                      input logic [3:0] WA3W, //from W
                      input logic [31:0] ResultW, //from W
                      input logic RegWriteW,//from W
                      output logic [31:0] SrcAD, SrcBD,
                      output logic [3:0] WA3D,
                      output logic [31:0] ExtImmD,
                      // For hazard unit
                      output logic [3:0] RA1D, RA2D); 
    //logic [3:0] RA1D, RA2D; //rf
    // regfile
    mux2 #(4) rfmux1(InstrD[19:16], 4'b1111, RegSrcD[0], RA1D);
    mux2 #(4) rfmux2(InstrD[3:0], InstrD[15:12], RegSrcD[1], RA2D);
    regfile rfile(~clk, reset, RegWriteW, RA1D, RA2D, WA3W, ResultW, PCPlus8D, SrcAD, SrcBD);
    
    assign WA3D = InstrD[15:12];
    extend ext(InstrD[23:0], ImmSrcD, ExtImmD);
endmodule