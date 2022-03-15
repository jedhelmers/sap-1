module ram(
  input clk,
  input debug,
  input prg_mode,
  input [7:0] prg_data,
  input [3:0] address,
  input wr_en,
  input re_en,
  inout [7:0] bus
  );

  reg [7:0] ram [0:15];
  assign bus = re_en ? ram[address] : 8'bzzzzzzzz;

  initial begin
    for(integer i = 0; i < 16; i++) begin
      ram[i] = 8'b00000000;
    end
  end

  always @(posedge clk or posedge wr_en) begin
    if(prg_mode) begin
      if(debug) $display("Program RAM address: %b prg_data: %b", address, prg_data);
      ram[address] <= prg_data;
    end
    else begin
      if(debug) $display("RAM write address: %b bus: %b", address, bus);
      ram[address] <= bus;
    end
  end

  always @(posedge clk or posedge re_en) begin
    if(debug) $display("Read\tRAM address: %b  ram[address]: %b", address, ram[address]);
  end

endmodule
