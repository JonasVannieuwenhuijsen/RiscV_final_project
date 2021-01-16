
//---------------------------------------------------------------------------
module if_id_register(if_id_pc_in, if_id_instructions_in, if_id_pc_out, if_id_instructions_out,
					  enable, clock, reset, if_id_flush);
//---------------------------------------------------------------------------

`include "RISCV.h"

parameter size = XLEN;

input [size-1:0] if_id_pc_in, if_id_instructions_in;
output reg [size-1:0] if_id_pc_out, if_id_instructions_out;
input clock, enable, reset, if_id_flush;

always @ (posedge clock)
	if (reset || if_id_flush) begin
		if_id_pc_out <= 0;
		if_id_instructions_out <= 0;
	end else if (enable) begin
		if_id_pc_out <= if_id_pc_in;
		if_id_instructions_out <= if_id_instructions_in;
	end
endmodule
		