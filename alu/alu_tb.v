`timescale 1 ns/10 ps
`include "alu.v"
module alu_tb();
  reg clk = 0;
  reg [7:0] a, b;
  wire [1:0] flags;
  reg sub = 0, sum_wr;
  wire [7:0] bus;
  reg debug = 1;

  alu alu_(
    .a(a),
    .b(b),
    .sub(sub),
    .sum_wr(sum_wr),
    .carry_flg(carry_flg),
    .zero_flg(zero_flg),
    .bus(bus),
    .debug(debug)
    );

  initial begin
    clk = 1'b0;
    forever #2 clk = ~clk;
  end

  initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);

    for(integer i = 0; i < 12; i++) begin
      sum_wr = 1;
      b = 8'b00000000 + i;
      a = 8'b11111100 + i; #20;
      sum_wr = 0;
    end

    for(integer i = 0; i < 12; i++) begin
      sub = 1;
      sum_wr = 1;
      a = 8'b00001000;
      b = i; #20;
      sum_wr = 0;
    end

    $display("Howdy");
    $finish;
  end
endmodule
