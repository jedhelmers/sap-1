`include "mux2_4.v"
module mux2_4_tb();
  reg clk = 0;

  reg [3:0] address_1 = 4'b0000;
  reg [3:0] address_2 = 4'b0000;
  reg select = 1'b0;
  wire [3:0] address_out = 4'bzzzz;

  initial begin
    clk = 1'b0;
    forever #2 clk = ~clk;
  end

  mux2_4 mx24(
    .address_1(address_1),
    .address_2(address_2),
    .select(select),
    .address_out(address_out)
    );

  initial begin
    $dumpfile("mux2_4_tb.vcd");
    $dumpvars(0, mux2_4_tb);

    for(integer i = 0; i < 12; i++) begin
      address_1++;
      address_2--;
      select++; #1;
      $display("address_out:%b address_1:%b address_2:%b select:%b", address_out, address_1, address_2, select); #20;
    end

    $display("Howdy");
    $finish;
  end
endmodule
