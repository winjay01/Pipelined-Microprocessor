`timescale 1ns / 1ps

module hazard_unit(output logic StallF, StallD, FlushD, FlushE,
                   output logic [1:0] ForwardAE, ForwardBE,
                   input logic [4:0] Match,
                   input logic RegWriteM, RegWriteW, MemtoRegE,
                   input logic PCSrcD, PCSrcE, PCSrcM, PCSrcW, BranchTakenE);
    // Get match signals
    logic Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E;
    assign {Match_1E_M, Match_1E_W, Match_2E_M, Match_2E_W, Match_12D_E} = Match;
    
    logic LDRstall, PCWrPendingF;
    
    always_comb
    begin
        if      (Match_1E_M * RegWriteM) ForwardAE = 2'b10; // SrcAE = ALUOutM
        else if (Match_1E_W * RegWriteW) ForwardAE = 2'b01; // SrcAE = ResultW
        else                             ForwardAE = 2'b00; // SrcAE from regfile
        if      (Match_2E_M * RegWriteM) ForwardBE = 2'b10; // SrcBE = ALUOutM
        else if (Match_2E_W * RegWriteW) ForwardBE = 2'b01; // SrcBE = ResultW
        else                             ForwardBE = 2'b00; // SrcBE from regfile
        LDRstall = Match_12D_E * MemtoRegE;
        PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;
        StallF = LDRstall | PCWrPendingF;
        StallD = LDRstall;
        FlushE = LDRstall | BranchTakenE;
        FlushD = PCWrPendingF | PCSrcW | BranchTakenE;
    end
endmodule