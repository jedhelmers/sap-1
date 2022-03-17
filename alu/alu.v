module alu(
  input [7:0] a, b,
  input sub, debug, sum_wr,
  output carry_flg, zero_flg,
  output [7:0] bus
  );

  reg [8:0] sum = 9'b000000000;
  reg carry_flg_ = 1'b0;
  reg zero_flg_ = 1'b0;

  assign carry_flg = carry_flg_;
  assign zero_flg = zero_flg_;
  assign bus = sum_wr ? sum : 8'bzzzzzzzz;

  always @(posedge sum_wr) begin
    sum = sub ? a + ~b + 1'b1 : a + b;
    carry_flg_ = sum[8];
    zero_flg_ = sum == 9'b000000000;
    if (debug) $display("%d %s %d = %d CARRY: %b ZERO: %b", a, sub ? "-" : "+", b, sum, carry_flg, zero_flg);
  end
endmodule
