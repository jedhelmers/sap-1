`include "program_counter.v"
module program_counter_tb();
  reg clk = 0;
  reg inc = 0;
  reg debug = 1;
  reg out_en = 1;
  reg rst = 0;
  wire [7:0] bus;

  initial begin
    clk = 1'b0;
    forever #2 clk = ~clk;
  end

  program_counter pc(
    .debug(debug),
    .out_en(out_en),
    .rst(rst),
    .inc(inc),
    .cnt(bus)
    );

  initial begin
    $dumpfile("program_counter_tb.vcd");
    $dumpvars(0, program_counter_tb);

    for(integer i = 0; i < 40; i++) begin
      inc = (i % 2 == 0); #20;
      out_en = !out_en;
      rst = !(i % 10 == 0);
    end

    $display("Howdy");
    $finish;
  end
endmodule
