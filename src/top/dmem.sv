`timescale 1ns / 1ps

module dmem(input  logic clk, reset, we,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);

  logic [31:0] RAM[127:0];

  assign rd = RAM[a[31:2]]; // word aligned

  always_ff @(posedge clk)
  begin
    if (reset) for (int i = 0; i < 128; i++) RAM[i] <= 0;
    else if (we) RAM[a[31:2]] <= wd;
  end
endmodule