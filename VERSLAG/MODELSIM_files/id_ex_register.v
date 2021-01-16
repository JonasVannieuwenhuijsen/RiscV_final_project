

//---------------------------------------------------------------------------
module id_ex_register(id_ex_pc_in, id_ex_pc_out, id_ex_readdata1_in, id_ex_readdata1_out,
					  id_ex_readdata2_in, id_ex_readdata2_out, id_ex_imm_gen_in, id_ex_imm_gen_out,
					  enable, clock, reset, id_ex_Branch_in, id_ex_MemtoReg_in, id_ex_MemWrite_in, id_ex_ALUSrc_in, id_ex_PCSrc_in, id_ex_RegWrite_in,
					  id_ex_Branch_out, id_ex_MemtoReg_out, id_ex_MemWrite_out, id_ex_ALUSrc_out, id_ex_PCSrc_out, id_ex_RegWrite_out,
					  id_ex_ALUOp_in, id_ex_Type_Select_in, id_ex_Instructies_in, id_ex_ALUOp_out, id_ex_Type_Select_out, id_ex_WriteReg_out, id_ex_rs1_out, id_ex_rs2_out,
					  id_ex_imm_extend_in, id_ex_imm_extend_out);
//---------------------------------------------------------------------------

`include "RISCV.h"

parameter size = XLEN;

input [size-1:0] id_ex_pc_in, id_ex_readdata1_in, id_ex_readdata2_in, id_ex_imm_gen_in, id_ex_Instructies_in;
output reg [size-1:0] id_ex_pc_out, id_ex_readdata1_out, id_ex_readdata2_out, id_ex_imm_gen_out;
input clock, enable, reset, id_ex_Branch_in, id_ex_MemtoReg_in, id_ex_MemWrite_in, id_ex_ALUSrc_in, id_ex_PCSrc_in, id_ex_RegWrite_in;
output reg id_ex_Branch_out, id_ex_MemtoReg_out, id_ex_MemWrite_out, id_ex_ALUSrc_out, id_ex_PCSrc_out, id_ex_RegWrite_out;
input [3:0] id_ex_ALUOp_in;
input [2:0] id_ex_Type_Select_in;
input [4:0] id_ex_imm_extend_in;
output reg [4:0] id_ex_imm_extend_out;
output reg [3:0] id_ex_ALUOp_out;
output reg [2:0] id_ex_Type_Select_out;
output reg [4:0] id_ex_WriteReg_out, id_ex_rs1_out, id_ex_rs2_out;

always @ (posedge clock)
	if (reset) begin
		id_ex_pc_out <= 0;
		id_ex_readdata1_out <= 0;
		id_ex_readdata2_out <= 0;
		id_ex_imm_gen_out <= 0;
		id_ex_Branch_out <= 0;
        id_ex_MemtoReg_out <= 0;
        id_ex_MemWrite_out <= 0;
        id_ex_ALUSrc_out <= 0;
        id_ex_RegWrite_out <= 0;
        id_ex_PCSrc_out <= 0;
        id_ex_ALUOp_out <= 0;
        id_ex_Type_Select_out <= 0;
        id_ex_WriteReg_out <= 0;
		id_ex_rs1_out <= 0;
		id_ex_rs2_out <= 0;
		id_ex_imm_extend_out <= 0;
	end else if (enable) begin
		id_ex_pc_out <= id_ex_pc_in;
		id_ex_readdata1_out <= id_ex_readdata1_in;
		id_ex_readdata2_out <= id_ex_readdata2_in;
		id_ex_imm_gen_out <= id_ex_imm_gen_in;
		id_ex_Branch_out <= id_ex_Branch_in;
        id_ex_MemtoReg_out <= id_ex_MemtoReg_in;
        id_ex_MemWrite_out <= id_ex_MemWrite_in;
        id_ex_ALUSrc_out <= id_ex_ALUSrc_in;
        id_ex_RegWrite_out <= id_ex_RegWrite_in;
        id_ex_PCSrc_out <= id_ex_PCSrc_in;
        id_ex_ALUOp_out <= id_ex_ALUOp_in;
        id_ex_Type_Select_out <= id_ex_Type_Select_in;
        id_ex_WriteReg_out <= id_ex_Instructies_in[11:7];
		id_ex_rs1_out <= id_ex_Instructies_in[19:15];
		id_ex_rs2_out <= id_ex_Instructies_in[24:20];
		id_ex_imm_extend_out <= id_ex_imm_extend_in;
	end
endmodule
		
