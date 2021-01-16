

//---------------------------------------------------------------------------
module mem_wb_register(mem_wb_read_data_in, mem_wb_read_data_out, mem_wb_alu_result_in, mem_wb_alu_result_out,
					   mem_wb_MemtoReg_in, mem_wb_RegWrite_in, mem_wb_MemtoReg_out, mem_wb_RegWrite_out, mem_wb_WriteReg_in, mem_wb_WriteReg_out,
					   enable, clock, reset);
//---------------------------------------------------------------------------

`include "RISCV.h"

parameter size = XLEN;

input [size-1:0] mem_wb_read_data_in, mem_wb_alu_result_in;
output reg [size-1:0] mem_wb_read_data_out, mem_wb_alu_result_out;
input clock, enable, reset, mem_wb_MemtoReg_in, mem_wb_RegWrite_in;
input [4:0] mem_wb_WriteReg_in;
output reg [4:0] mem_wb_WriteReg_out;
output reg mem_wb_MemtoReg_out, mem_wb_RegWrite_out;

always @ (posedge clock)
	if (reset) begin
		mem_wb_read_data_out <= 0;
		mem_wb_alu_result_out <= 0;
		mem_wb_WriteReg_out <= 0;
		mem_wb_MemtoReg_out <= 0;
		mem_wb_RegWrite_out <= 0;
	end else if (enable) begin
		mem_wb_read_data_out <= mem_wb_read_data_in;
		mem_wb_alu_result_out <= mem_wb_alu_result_in;
		mem_wb_WriteReg_out <= mem_wb_WriteReg_in;
		mem_wb_MemtoReg_out <= mem_wb_MemtoReg_in;
		mem_wb_RegWrite_out <= mem_wb_RegWrite_in;
	end
endmodule