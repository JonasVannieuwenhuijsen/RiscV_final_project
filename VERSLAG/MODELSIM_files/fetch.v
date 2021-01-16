
//---------------------------------------------------//
module fetch(clock, reset, Instruction);
//---------------------------------------------------//

`include "RISCV.h"
input clock;
input reset;
output [31:0] Instruction;
wire [XLEN-1:0] PC_out, PC_inc;
wire [31:0] Instruction;

	programCounter PC(.in(PC_inc), .out(PC_out), .enable(1'b1), .clock(clock), .reset(reset));
	instructionMemory Instruction_memory (.address(PC_out), .data_out(Instruction));
	ADD Add_4(.a(PC_out), .b(4), .out(PC_inc));

endmodule
