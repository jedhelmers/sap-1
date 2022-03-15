module instruction_register(
    input debug,
    input rst,
    input instr_load_in,
    input instr_send_in,
    input [7:0] bus_in,
    output [3:0] opcode,
    output [3:0] address_out
  );

  reg [3:0] high = 4'b0000;
  reg [3:0] low = 4'b0000;

  assign opcode = high;
  assign address_out = instr_send_in ? low : 4'bzzzz;

  always @(posedge rst) begin
    if(debug) $display("IR reset: %b", 8'b00000000);
    high <= 4'b0000;
    low <= 4'b0000;
  end

  always @(posedge instr_load_in or bus_in) begin
    if(debug) $display("IR loaded: %b %h", bus_in, opcode);
    high <= bus_in[7:4];
    low <= bus_in[3:0];
  end
endmodule
