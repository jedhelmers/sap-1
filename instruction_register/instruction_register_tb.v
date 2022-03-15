`include "instruction_register.v"
module instruction_register_tb();
  reg clk;
  reg debug = 1;
  reg rst = 0;

  reg instr_load_in;
  reg instr_send_in;
  reg [7:0] bus_in;
  wire [3:0] opcode;
  wire [3:0] address_out;

  instruction_register ir(
      .debug(debug),
      .rst(rst),
      .instr_load_in(instr_load_in),
      .instr_send_in(instr_send_in),
      .bus_in(bus_in),
      .opcode(opcode),
      .address_out(address_out)
    );

    initial begin
      clk = 1'b0;
      forever #5 clk = ~clk;
    end

    initial begin
      rst = 1'b0;
      // bus_in = 8'b0;
    end

    initial begin
      $dumpfile("instruction_register_tb.vcd");
      $dumpvars(0, instruction_register_tb);

      for(integer i = 0; i < 12; i = i+1) begin
        bus_in = i * 10; #20;
        instr_load_in = i % 2 == 0;
        instr_send_in = !(i % 2 == 0);
        rst = (i % 6 == 0);
      end

      $display("Howdy");
      $finish;
    end

endmodule
