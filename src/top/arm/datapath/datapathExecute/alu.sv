`timescale 1ns / 1ps

module alu(input logic [31:0] A,
           input logic [31:0] B,
           input logic [1:0] ALUControl,
           output logic [31:0] Result,
           output logic [3:0] ALUFlags);
    
    // Intermediate Signals
    logic [31:0] Mux_result;
    logic [32:0] Sum; // extra bit for carry
    logic [31:0] AND_result;
    logic [31:0] OR_result;
    mux2 # (32) B_Mux (B, ~B, ALUControl[0], Mux_result);
    
    assign Sum = A + Mux_result + ALUControl[0];
    assign AND_result = A & B;
    assign OR_result = A | B;
    // 4 Input Multiplexer for Result
    always_comb
    begin
        case (ALUControl)
            2'b00: Result = Sum[31:0];
            2'b01: Result = Sum[31:0];
            2'b10: Result = AND_result[31:0];
            2'b11: Result = OR_result[31:0];
            default: Result = 0;
        endcase
    end
    // Flags (N Z C V) [3 2 1 0]
    assign ALUFlags[3] = Sum[31]; // N
    assign ALUFlags[2] = (Result[31:0] == 0); // Z
    assign ALUFlags[1] = ~ALUControl[1] & Sum[32]; // C
    assign ALUFlags[0] = (~ALUControl[1] & ~(ALUControl[0] ^ A[31] ^ B[31]) & (A[31] ^ Sum[31])); // V
endmodule