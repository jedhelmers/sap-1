`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`include "register.v"
module register_tb();
  reg clk;

  reg debug = 1;
  reg rst;
  reg data_load;
  reg data_send;
  reg [7:0] bus;
  wire [7:0] bus_out;
  wire [7:0] unbuffered_out;

  register register_1 (
      .debug(debug),
      .rst(rst),
      .data_load(data_load),
      .data_send(data_send),
      .bus(bus),
      .bus_out(bus_out),
      .unbuffered_out(unbuffered_out)
    );

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1'b0;
    data_load = 1'b0;
    data_send = 1'b0;
    bus = 8'b0;
  end


  initial
    begin
      $dumpfile("register.vcd");
      $dumpvars(0, register_tb);
      for(integer i = 0; i < 12; i = i + 1) begin
        data_load = i % 2 == 0;
        data_send = !(i % 2 == 0);
        rst = i % 6 == 0;
        bus = i * 10; #20;
      end

      $display("Howdy");
      $finish;
    end
endmodule
