`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`include "cpu.v"
module cpu_tb;
  localparam period = 20;
  wire [7:0] bus = 8'b00000000;
  reg [7:0] _bus;


  reg pr_mode;
  reg [3:0] pr_address;
  reg [7:0] pr_data;

  reg instr_load;
  reg address_send;

  reg debug = 1;
  reg clk;
  reg rst = 0;
  reg [3:0] opcode;
  reg [3:0] flags;
  // control signals
  wire halt;
  wire reg_a_in;
  wire reg_a_out;
  wire reg_b_in;
  wire reg_b_out;
  wire alu_out;
  wire alu_sub;
  wire instr_in;
  wire instr_out;
  wire mar_in;
  wire ram_in;
  wire ram_out;
  wire reg_out;
  wire pc_inc;
  wire pc_out;
  wire pc_jmp;
  wire [3:0] reg_flags_in;
  // debug
  wire [3:0] step_out;

  wire [3:0] _program [0:11];
  integer _cnt = 0;

  assign bus = instr_in ? 8'bzzzzzzzz : _bus;

  cpu cpu_(
    .clk(clk),
    .rst(rst),
    .pr_mode(pr_mode),
    .pr_address(pr_address),
    .pr_data(pr_data),
    .instr_load(instr_load),
    .address_send(address_send),
    .debug(debug)
  );

  initial begin
    clk = 1'b0;
    forever #2 clk = ~clk;
  end

  initial begin
    debug = 1'b1;
    flags = 4'b0011;
  end

  initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0, cpu_tb);

    for(integer i = 0; i < 12; i = i + 1) begin
      instr_load <= (i % 2 == 0); #1;
      opcode = i; #1;
      address_send <= !(i % 2 == 0); #1
      _bus = i * 10; #20;
    end

    // opcode = 1;
    // bus = 12; #20;

    $display("Howdy");
    $finish;
  end
endmodule
