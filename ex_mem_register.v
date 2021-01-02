
//---------------------------------------------------------------------------
module ex_mem_register(ex_mem_pc_in, ex_mem_pc_out, ex_mem_readdata2_in, ex_mem_readdata2_out,
					   ex_mem_zero_in, ex_mem_zero_out, ex_mem_alu_result_in, ex_mem_alu_result_out,
					   enable, clock, reset, ex_mem_Branch_in, ex_mem_MemtoReg_in, ex_mem_MemWrite_in, ex_mem_RegWrite_in,
					   ex_mem_Branch_out, ex_mem_MemtoReg_out, ex_mem_MemWrite_out, ex_mem_RegWrite_out,
					   ex_mem_Type_Select_in, ex_mem_WriteReg_in, ex_mem_Type_Select_out, ex_mem_WriteReg_out);
//---------------------------------------------------------------------------

`include "RISCV.h"

parameter size = XLEN;

input [size-1:0] ex_mem_pc_in, ex_mem_readdata2_in, ex_mem_alu_result_in;
output reg [size-1:0] ex_mem_pc_out, ex_mem_readdata2_out, ex_mem_alu_result_out;
input ex_mem_zero_in, clock, enable, reset, ex_mem_Branch_in, ex_mem_MemtoReg_in, ex_mem_MemWrite_in, ex_mem_RegWrite_in;
input [2:0] ex_mem_Type_Select_in;
input [4:0] ex_mem_WriteReg_in;
output reg [2:0] ex_mem_Type_Select_out;
output reg [4:0] ex_mem_WriteReg_out;
output reg ex_mem_zero_out, ex_mem_Branch_out, ex_mem_MemtoReg_out, ex_mem_MemWrite_out, ex_mem_RegWrite_out;

always @ (posedge clock) begin
	if (reset) begin
		ex_mem_pc_out <= 0;
		ex_mem_readdata2_out <= 0;
		ex_mem_alu_result_out <= 0;
		ex_mem_zero_out <= 0;
		ex_mem_Branch_out <= 0;
		ex_mem_MemtoReg_out <= 0;
		ex_mem_MemWrite_out <= 0;
		ex_mem_RegWrite_out <= 0;
		ex_mem_Type_Select_out <= 0;
		ex_mem_WriteReg_out <= 0;
	end else if (enable) begin
		ex_mem_pc_out <= ex_mem_pc_in;
		ex_mem_readdata2_out <= ex_mem_readdata2_in;
		ex_mem_alu_result_out <= ex_mem_alu_result_in;
		ex_mem_zero_out <= ex_mem_zero_in;
		ex_mem_Branch_out <= ex_mem_Branch_in;
		ex_mem_MemtoReg_out <= ex_mem_MemtoReg_in;
		ex_mem_MemWrite_out <= ex_mem_MemWrite_in;
		ex_mem_RegWrite_out <= ex_mem_RegWrite_in;
		ex_mem_Type_Select_out <= ex_mem_Type_Select_in;
		ex_mem_WriteReg_out <= ex_mem_WriteReg_in;
		end 
	end
endmodule
		