module controller(
    input debug,
    input clk,
    input rst,
    input [3:0] opcode,
    input [3:0] flags,
    // control signals
    output halt,
    output reg_a_in,
    output reg_a_out,
    output reg_b_in,
    output reg_b_out,
    output alu_out,
    output alu_sub,
    output instr_in,
    output instr_out,
    output mar_in,
    output ram_in,
    output ram_out,
    output reg_out_in,
    output pc_inc,
    output pc_out,
    output pc_jmp,
    output [3:0] reg_flags_in,
    // debug
    output [3:0] step_out
  );

  integer NOP = 0;
  integer LDA = 1;
  integer LDB = 2;
  integer ADD = 3;
  integer SUB = 4;
  integer STA = 5;
  integer LDI = 6;
  integer JMP = 7;
  integer JC = 8;
  integer JZ = 9;
  integer OUT = 10;
  integer HLT = 11;

  integer CARRY = 0;
  integer ZERO = 1;
  integer SIGN = 2;
  integer PARITY = 3;

  reg [3:0] step = 2'b00;

  assign step_out = step;

  reg [17:0] control_bits = 18'b00_0000_0000_0000_0000;


  assign halt = control_bits[16];
  assign reg_a_in = control_bits[15];
  assign reg_a_out = control_bits[14];
  assign reg_b_in = control_bits[13];
  assign reg_b_out = control_bits[12];
  assign alu_out = control_bits[11];
  assign alu_sub = control_bits[10];
  assign instr_in = control_bits[9];
  assign instr_out = control_bits[8];
  assign mar_in = control_bits[7];
  assign ram_in = control_bits[6];
  assign ram_out = control_bits[5];
  assign reg_out_in = control_bits[4];
  assign pc_inc = control_bits[3];
  assign pc_out = control_bits[2];
  assign pc_jmp = control_bits[1];
  assign reg_flags_in = control_bits[0];


  always @(posedge clk or posedge rst)
  begin
    if (rst) begin
      step <= 0;
    end
    else if(!halt) begin
      // control_bits <= 18'b10_1010_1010_1010_0101;
      // case (step)
      //   2:
      //     // step 2
      //     begin
      //       if (debug) $display( \t en\t%b", step, control_bits);
      //       control_bits <= 18'b00_0000_0000_0000_0000;
      //       step <= step + 1;
      //     end
      //   3:
      //     // step 3
      //     begin
      //       if (debug) $display( \ten \t%b", step, control_bits);
      //       control_bits <= 18'b00_0000_0000_0000_0000;
      //       step <= step + 1;
      //     end
      // endcase
      if (step == 0) begin
        // fetch 0: pc_out + mar_in
        if (debug) $display("FCH_0\t%d  %d  %H", step, opcode, control_bits);
        control_bits <= 18'b00_0000_0000_1000_0100;
        step <= step + 1;
      end
      else if(step == 1) begin
        // fetch 1: instr_in + ram_out + pc_inc
        if (debug) $display("FCH_1\t%d  %d  %H", step, opcode, control_bits);
        control_bits <= 18'b00_0000_0010_0010_1000;
        step <= step + 1;
      end
      else begin
        case (opcode)
          NOP:
            begin
              case (step)
                2:
                  // step 2
                  begin
                    if (debug) $display("NOP_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
          LDA:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + mar_in
                  begin
                    if (debug) $display("LDA_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0001_1000_0000;
                    step <= step + 1;
                  end
                3:
                  // step 3
                  // ram_out + reg_a_in
                  begin
                    if (debug) $display("LDA_3\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_1000_0000_0010_0000;
                    step <= 0;
                  end
              endcase
            end
          LDB:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + mar_in
                  begin
                    if (debug) $display("LDB_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0001_1000_0000;
                    step <= step + 1;
                  end
                3:
                  // step 3
                  // ram_out + reg_b_in
                  begin
                    if (debug) $display("LDB_3\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0010_0000_0010_0000;
                    step <= 0;
                  end
              endcase
            end
          ADD:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + mar_in
                  begin
                    if (debug) $display("ADD_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0001_1000_0000;
                    step <= step + 1;
                  end
                3:
                  // step 3
                  // ram_out + reg_b_in
                  begin
                    if (debug) $display("ADD_3\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= step + 1;
                  end
                4:
                  // step 3
                  // alu_out + reg_a_in + reg_flags_in
                  begin
                    if (debug) $display("ADD_4\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_1000_1000_0000_0001;
                    step <= 0;
                  end
              endcase
            end
          SUB:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + mar_in
                  begin
                    if (debug) $display("SUB_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0001_1000_0000;
                    step <= step + 1;
                  end
                3:
                  // step 3
                  // ram_out + reg_b_in
                  begin
                    if (debug) $display("SUB_3\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0010_0000_0010_0000;
                    step <= step + 1;
                  end
                4:
                  // step 3
                  // alu_sub + alu_out + reg_a_in + reg_flags_in
                  begin
                    if (debug) $display("SUB_4\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_1000_1100_0000_0001;
                    step <= 0;
                  end
              endcase
            end
          STA:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + mar_in
                  begin
                    if (debug) $display("STA_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= step + 1;
                  end
                3:
                  // step 3
                  // reg_a_out + ram_in
                  begin
                    if (debug) $display("STA_3\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
          LDI:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + reg_a_in
                  begin
                    if (debug) $display("LDI_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
          JMP:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + pc_jmp
                  begin
                    if (debug) $display("JMP_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
          JC:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + jump
                  if (flags[CARRY]) begin
                    if (debug) $display( "JC_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
                  else begin
                    // NOP
                    if (debug) $display("NOP_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
          JZ:
            begin
              case (step)
                2:
                  // step 2
                  // instr_out + jmp
                  if (flags[ZERO]) begin
                    if (debug) $display( "JZ_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0001_0000_0010;
                    step <= 0;
                  end
                  else begin
                    // nop
                    if (debug) $display("NOP_2\t%d  %d  %H\n", step, opcode, control_bits);
                    control_bits <= 18'b00_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
          OUT:
            begin
              case (step)
                2:
                  // step 2
                  // reg_a_out + reg_out_in
                  begin
                    if (debug) $display("OUT_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b00_0100_0000_0001_0000;
                    step <= 0;
                  end
              endcase
            end
          HLT:
            begin
              case (step)
                2:
                  // step 2
                  // halt
                  begin
                    if (debug) $display("HLT_2\t%d  %d  %H", step, opcode, control_bits);
                    control_bits <= 18'b01_0000_0000_0000_0000;
                    step <= 0;
                  end
              endcase
            end
        endcase
      end
    end
  end













endmodule
