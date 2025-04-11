`timescale 1ns / 1ps

module alu_decoder(input logic [4:0] Funct,
                   input logic ALUOp,
                   output logic [1:0] ALUControl,
                   output logic [1:0] FlagW);
    // [ALUControl[1:0] | FlagW[1:0]]
    logic [3:0] truth_table_output;
    
    logic [3:0] cmd;
    logic S;
    assign cmd = Funct[4:1];
    assign S = Funct[0];
    // ALU Decoder Truth Table
    always_comb
    begin
        if (ALUOp == 0) 
        begin
            ALUControl = 2'b00;
            FlagW = 2'b00;
        end 
        
        else 
        begin
            case(cmd)
                // ADD
                4'b0100: ALUControl = 2'b00;
                // SUB
                4'b0010: ALUControl = 2'b01;
                // AND
                4'b0000: ALUControl = 2'b10;
                // ORR
                4'b1100: ALUControl = 2'b11;
                default: ALUControl = 2'b00;
            endcase
            // Update Flags
            FlagW[1] = S;
            FlagW[0] = S & (ALUControl == 2'b00 | ALUControl == 2'b01);
        end
    end
endmodule