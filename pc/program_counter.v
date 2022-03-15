module program_counter(
  input debug,
  input rst,
  input inc,
  input out_en,
  output [7:0] cnt
  );

  reg [3:0] _cnt = 4'b0000;
  reg [7:0] _cnt_buffer = 8'bzzzzzzzz;

  assign cnt = _cnt_buffer;

  always @(posedge inc) begin
    if(debug) $display("PC++: %b", _cnt);
    _cnt++;
  end

  always @(out_en) begin
    if (out_en) begin
      _cnt_buffer = {4'b0000, _cnt};
      if(debug) $display("Cast cnt to 8-bit: %b", {4'b0000, _cnt});
    end
    else begin
      _cnt_buffer = 8'bzzzzzzzz;
    end
  end

  always @(posedge rst) begin
    if(debug) $display("PC rst: %b", _cnt);
    _cnt <= 4'b0000;
  end
endmodule
