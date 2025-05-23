`timescale 1ns / 1ps

module regfile(input  logic        clk, reset,
               input  logic        we3, 
               input  logic [3:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, r15,
               output logic [31:0] rd1, rd2);
  logic [31:0] rf[15:0];
  // three ported register file
  // read two ports combinationally
  // write third port on falling edge of clock
  // register 15 reads PC+8 instead
  always_ff @(posedge clk)
  begin
    if (reset) for (int i = 0; i < 16; i++) rf[i] <= 0;
    else if (we3) rf[wa3] <= wd3;
  end

  assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
  assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
endmodule