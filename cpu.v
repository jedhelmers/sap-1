`include "register/register.v"
`include "control/control.v"
`include "instruction_register/instruction_register.v"
`include "mar/mar.v"
`include "ram/ram.v"
`include "pc/program_counter.v"
`include "mux/mux2_4.v"
module cpu(
    input clk,
    input rst,
    input pr_mode,
    input [3:0] pr_address,
    input [7:0] pr_data,
    input instr_load,
    input debug,
    input address_send
  );

  wire data_load;
  wire data_send;
  wire [7:0] bus;
  wire [7:0] bus_out;
  wire [7:0] unbuffered_out;

  wire [3:0] mar_address;
  wire [3:0] ram_address;
  wire [3:0] opcode;

  wire [3:0] flags;
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
  wire reg_out_in;
  wire pc_inc;
  wire pc_out;
  wire pc_jmp;
  wire [3:0] reg_flags_in;
  wire [3:0] step_out;

  assign instr_in = instr_load; // TESTING: DELETE
  assign instr_out = address_send; // TESTING: DELETE

  mux2_4 mx24(
      .address_1(mar_address),
      .address_2(pr_address),
      .select(pr_mode),
      .address_out(ram_address)
    );

  program_counter pc(
      .debug(debug),
      .out_en(pc_out),
      .rst(rst),
      .inc(pc_inc),
      .cnt(bus)
    );

  ram r(
      .debug(debug),
      .prg_mode(pr_mode),
      .prg_data(pr_data),
      .address(ram_address),
      .wr_en(ram_in),
      .re_en(ram_out),
      .bus(bus)
    );

  instruction_register ir(
      .debug(debug),
      .rst(rst),
      .instr_load_in(instr_in),
      .instr_send_in(instr_out),
      .bus_in(bus),
      .opcode(opcode),
      .address_out(bus[3:0])
    );

  mar mar_(
      .debug(debug),
      .rst(rst),
      .address_in(bus[3:0]),
      .enable_in(mar_in),
      .address_out(mar_address)
    );

  register reg_a(
      .debug(debug),
      .rst(rst),
      .data_load(reg_a_in),
      .data_send(reg_a_out),
      .bus(bus),
      .bus_out(bus_out),
      .unbuffered_out(unbuffered_out)
    );

  register reg_b(
      .debug(debug),
      .rst(rst),
      .data_load(reg_b_in),
      .data_send(reg_b_out),
      .bus(bus),
      .bus_out(bus_out),
      .unbuffered_out(unbuffered_out)
    );

  register reg_out(
      .debug(debug),
      .rst(rst),
      .data_load(reg_out_in),
      .data_send(reg_b_out),
      .bus(bus),
      .bus_out(bus_out),
      .unbuffered_out(unbuffered_out)
    );

  controller c(
    .debug(debug),
    .clk(clk),
    .rst(rst),
    .opcode(opcode),
    .flags(flags),
    .halt(halt),
    .reg_a_in(reg_a_in),
    .reg_a_out(reg_a_out),
    .reg_b_in(reg_b_in),
    .reg_b_out(reg_b_out),
    .alu_out(alu_out),
    .alu_sub(alu_sub),
    .instr_in(instr_in),
    .instr_out(instr_out),
    .mar_in(mar_in),
    .ram_in(ram_in),
    .ram_out(ram_out),
    .reg_out_in(reg_out_in),
    .pc_inc(pc_inc),
    .pc_out(pc_out),
    .pc_jmp(pc_jmp),
    .reg_flags_in(reg_flags_in),
    .step_out(step_out)
  );

endmodule
