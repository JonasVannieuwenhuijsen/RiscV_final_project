
//-----------------------------------------------------//
module hazard_detection_unit(if_id_rs1, if_id_rs2, id_ex_WriteReg, id_ex_MemtoReg_out, PCWrite, if_id_write, nopMux_select, clock, enable, reset,
							MemWrite, id_ex_RegWrite_out);
//-----------------------------------------------------//
`include "RISCV.h"


input [4:0] if_id_rs1, if_id_rs2, id_ex_WriteReg;
input id_ex_MemtoReg_out, id_ex_RegWrite_out, clock, enable, reset, MemWrite;

output reg PCWrite, if_id_write, nopMux_select;

integer i;

always @(*) begin 
	if (i == 0) begin
		if (id_ex_MemtoReg_out && ((id_ex_WriteReg == if_id_rs1) || (id_ex_WriteReg == if_id_rs2))) begin
			PCWrite <= 0;
			if_id_write <= 0;
			nopMux_select <= 1;
		end else begin
			PCWrite <= 1;
			if_id_write <= 1;
			nopMux_select <= 0;
		end
	end else begin
		PCWrite <= 0;
		if_id_write <= 0;
		nopMux_select <= 1;
	end
end

always @ (posedge clock) begin
	if(reset) begin
		i = 0;
	end else if (i != 0) begin
		i = i - 1;
	end else if (MemWrite && id_ex_RegWrite_out && id_ex_MemtoReg_out) begin
		i = 3;
	end
end
endmodule
