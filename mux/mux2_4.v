module mux2_4(
  input [3:0] address_1,
  input [3:0] address_2,
  input select,
  output [3:0] address_out
  );

  assign address_out = select ? address_1 : address_2;

endmodule
