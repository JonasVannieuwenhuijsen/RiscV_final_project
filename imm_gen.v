
//---------------------------------------------------------//
module imm_gen (input [31:0] Instruction, input [4:0] Imm_extend, output reg signed[31:0] Imm_out);
//---------------------------------------------------------//

`include "RISCV.h"

always @(Imm_extend or Instruction) begin
	Imm_out = 32'd0;
   case (Imm_extend)
	  I_IMM : Imm_out[31:0] = {{(XLEN - 11){Instruction[31]}}, Instruction[30:20]};
	  B_IMM : Imm_out[31:0] = {{(XLEN - 12){Instruction[31]}}, Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
	  S_IMM : Imm_out[31:0] = {{(XLEN - 11){Instruction[31]}}, Instruction[30:25], Instruction[11:7]};
	  U_IMM : Imm_out[31:0] = {Instruction[31:12], 12'b0};
	  J_IMM : Imm_out[31:0] = {{(XLEN - 18){Instruction[31]}}, Instruction[19:12], Instruction[20], Instruction[30:21], 1'b0};
	  default: ;
   endcase
end
endmodule

