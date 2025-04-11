`timescale 1ns / 1ps

module datapathExecute(input logic [31:0] RD2E, ExtImmE, // DEreg --> Mux
                       //input logic [31:0] SrcBE, // Mux --> ALU
                       input logic [31:0] RD1E, // DEreg --> ALU
                       output logic [31:0] ALUResultE, // ALU --> EMreg
                       output logic [3:0] ALUFlags, // ALU --> Controller
                       input logic ALUSrcE, // Controller --> Mux
                       input logic [1:0] ALUControlE, // Controller --> ALU
                       // For hazards
                       output logic [31:0] WriteDataE,
                       input logic [31:0] ALUOutM, ResultW,
                       // Hazard Unit signals
                       input logic [1:0] ForwardAE, ForwardBE); 
    // Mux
    logic [31:0] SrcAE, SrcBE;
    mux4 # (32) ae_mux(RD1E, ResultW, ALUOutM, RD1E, ForwardAE, SrcAE);
    mux4 # (32) be_mux(RD2E, ResultW, ALUOutM, RD2E, ForwardBE, WriteDataE);
    mux2 #(32) alumux(WriteDataE, ExtImmE, ALUSrcE, SrcBE);
    // ALU
    alu al(SrcAE, SrcBE, ALUControlE, ALUResultE, ALUFlags);
endmodule