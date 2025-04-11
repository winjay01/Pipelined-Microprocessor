`timescale 1ns / 1ps

module main_decoder(input logic [1:0] Op,
                    input logic [5:0] Funct,
                    output logic Branch,
                    output logic RegW, MemW,
                    output logic MemtoReg, ALUSrc,
                    output logic [1:0] ImmSrc, RegSrc,
                    output logic ALUOp);
    // [Branch | MemtoReg | MemW | ALUSrc | ImmSrc[1:0] | RegW | RegSrc[1:0] | ALUOp]
    logic [9:0] truth_table_output;
    
    // Main Decoder Truth Table
    always_comb
    begin
        casex(Op)
            // DP
            2'b00: if (Funct[5] == 0) truth_table_output = 10'b0000001001; // DP Reg
                   else               truth_table_output = 10'b0001001001; // DP Imm
            // Memory
            2'b01: if (Funct[0] == 0) truth_table_output = 10'b0011010100; // STR
                   else               truth_table_output = 10'b0101011000; // LDR
            // B
            2'b10:                    truth_table_output = 10'b1001100010;
            default:                  truth_table_output = 10'bx;
        endcase
    end
    
    assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp} = truth_table_output;
endmodule