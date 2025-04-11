`timescale 1ns / 1ps

module mux4 # (parameter WIDTH = 8)
        (input logic [WIDTH-1:0] D0, D1, D2, D3,
         input logic [1:0] S,
         output logic [WIDTH-1:0] Y);
     always_comb
        case(S)
            2'b00: Y = D0;
            2'b01: Y = D1;
            2'b10: Y = D2;
            2'b11: Y = D3;
            default: Y = 0;
        endcase
endmodule