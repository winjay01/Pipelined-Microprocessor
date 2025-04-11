`timescale 1ns / 1ps

module mux2 # (parameter WIDTH = 8)
        (input logic [WIDTH-1:0] D0,
         input logic [WIDTH-1:0] D1,
         input logic S,
         output logic [WIDTH-1:0] Y);
     assign Y = (S ? D1 : D0);
endmodule