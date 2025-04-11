`timescale 1ns / 1ps

module flushenreg # (parameter WIDTH = 8)
                 (input logic clk, reset, flush, en,
                  input logic [WIDTH-1:0] D,
                  output logic [WIDTH-1:0] Q);
    always_ff @ (posedge clk, posedge reset)
        if (reset || flush)   Q <= 0;
        else if (en) Q <= D;
endmodule