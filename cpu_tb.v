`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`include "cpu.v"
module cpu_tb;
  localparam period = 20;
  reg [7:0] bus = 8'b00000000;

  reg pr_mode;
  reg [3:0] pr_address;
  reg [7:0] pr_data;

  reg debug;
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

  assign _program[0] = 0;
  assign _program[1] = 1;
  assign _program[2] = 2;
  assign _program[3] = 3;
  assign _program[4] = 4;
  assign _program[5] = 5;
  assign _program[6] = 6;
  assign _program[7] = 7;
  assign _program[8] = 8;
  assign _program[9] = 9;
  assign _program[10] = 10;
  assign _program[11] = 11;

  cpu cpu_(
    .clk(clk),
    .rst(rst),
    .pr_mode(pr_mode),
    .pr_address(pr_address),
    .pr_data(pr_data)
  );

  initial begin
    clk = 1'b0;
    forever #2 clk = ~clk;
  end

  initial begin
    debug = 1'b1;
    flags = 4'b0011;
  end

  always @(posedge clk) begin
    if(pc_out) begin
      // $display("CNT:%d\tPC_OUT: %b \t OPCODE: %d", _cnt, pc_out, _program[_cnt]);
      _cnt <= _cnt + 1;
    end
  end

  initial begin
    $dumpfile("cpu_tb.vcd");
    $dumpvars(0, cpu_tb);

    for(integer i = 0; i < 12; i = i + 1) begin
      opcode  <= _program[_cnt]; #period;
      bus = i * 10; #120;
    end

    // opcode = 1;
    // bus = 12; #20;

    $display("Howdy");
    $finish;
  end
endmodule
