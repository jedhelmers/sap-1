`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`include "ram.v"
module ram_tb();
  reg clk = 0;
  reg debug = 1;
  reg prg_mode = 0;
  reg [7:0] prg_data;
  reg [3:0] address;
  reg wr_en= 1;
  reg re_en;
  wire [7:0] bus;

  reg [7:0] bus_strap;

  assign bus = !re_en ? bus_strap : 8'bzzzzzzzz;
  ram r(
    .debug(debug),
    .prg_mode(prg_mode),
    .prg_data(prg_data),
    .address(address),
    .wr_en(wr_en),
    .re_en(re_en),
    .bus(bus)
    );

  initial begin
    clk = 1'b0;
    forever #2 clk = ~clk;
  end

  initial begin
    $dumpfile("ram_tb.vcd");
    $dumpvars(0, ram_tb);

    debug = 0;
    $display("\nread from file");
    for(integer i = 0; i < 16; i = i + 1) begin
      prg_mode = 0;
      re_en = 1;
      address = i; #20;
      $display("bus: %b", bus);
    end
    debug = 1;

    for(integer j = 0; j < 2; j++) begin
      prg_mode = !j;

      for(integer i = 0; i < 12; i = i + 1) begin
        wr_en = i % 2 == 0;
        prg_data = i * 12;
        bus_strap = i * 3;
        address = i; #20;
      end
      $display("\nprg_mode: %b", prg_mode);

      for(integer i = 0; i < 12; i = i + 1) begin
        re_en = i % 2 == 0;
        prg_data = i * 12;
        address = i; #20;
      end
    end

    $display("Howdy");
    $finish;
  end
endmodule
