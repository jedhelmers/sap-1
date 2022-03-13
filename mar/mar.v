module mar(
  input debug,
  input rst,
  input [3:0] address_in,
  input enable_in,
  output [3:0] address_out
  );

  reg [3:0] _address = 4'b0000;
  assign address_out = _address;

  always @(address_in or posedge enable_in) begin
    if (enable_in) begin
      if(debug) $display("MAR load address: %b", address_in);
      _address = address_in;
    end
  end

  always @(posedge rst) begin
    if(debug) $display("MAR reset: %b", 4'b0000);
    _address = 4'b0000;
  end
endmodule
