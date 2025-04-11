`timescale 1ns / 1ps

module decoder(input logic [1:0] Op,
               input logic [5:0] Funct,
               input logic [3:0] Rd,
               output logic [1:0] FlagW,
               output logic PCS, RegW, MemW,
               output logic MemtoReg, ALUSrc,
               output logic [1:0] ImmSrc, RegSrc,
               output logic [1:0] ALUControl,
               output logic Branch);
    // Intermediate signals
    logic ALUOp;
    
    main_decoder MDC(Op, Funct, Branch, RegW, MemW, MemtoReg, ALUSrc, ImmSrc, RegSrc, ALUOp);
    alu_decoder ALUDC(Funct[4:0], ALUOp, ALUControl, FlagW);
    assign PCS = (((Rd == 15) & RegW) | Branch);
endmodule