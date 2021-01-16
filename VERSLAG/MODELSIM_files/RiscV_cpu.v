

//---------------------------------------------------//
module RiscV_cpu(input clock, input reset, input step, input [9:0] switch, input [1:0] key);
//---------------------------------------------------//

`include "RISCV.h"

wire [XLEN-1:0] PC_out, PC_inc, PC_in, PC_i, Instruction, RegWriteData, ReadData1, ReadData2, Imm_out, ALU_in1, ALU_in2, Imm_out_sl, PC_branch, MemReadData, ALUOut,
				if_id_pc_out, if_id_instructions_out, id_ex_pc_out, id_ex_readdata1_out, id_ex_readdata2_out, id_ex_imm_gen_out, ex_mem_pc_out, ex_mem_readdata2_out,
				ex_mem_alu_result_out, mem_wb_read_data_out, mem_wb_alu_result_out, forwarding_A_out, forwarding_B_out, forwarding_A_BranchCalculator_out, forwarding_B_BranchCalculator_out;
				
wire Branch, MemtoReg, MemWrite, ALUSrc, PCSrc, JALRSrc, RegWrite, zero, Branch_select, id_ex_Branch_out, id_ex_MemtoReg_out, id_ex_MemWrite_out, id_ex_ALUSrc_out, id_ex_PCSrc_out, id_ex_RegWrite_out,
     ex_mem_zero_out, ex_mem_Branch_out, ex_mem_MemtoReg_out, ex_mem_MemWrite_out, ex_mem_RegWrite_out, mem_wb_MemtoReg_out, mem_wb_RegWrite_out, PCWrite, if_id_write, nopMux_select,
	 Branch_nopMux, MemtoReg_nopMux, MemWrite_nopMux, RegWrite_nopMux, PCSource_nopMux, branch_calculator_select, flush;
	 
wire [3:0] ALUOp, id_ex_ALUOp_out, ALUOp_nopMux;
wire [2:0] Type_Select, id_ex_Type_Select_out, ex_mem_Type_Select_out, Type_Select_nopMux;
wire [4:0] Imm_extend, id_ex_WriteReg_out, ex_mem_WriteReg_out, mem_wb_WriteReg_out, id_ex_rs1_out, id_ex_rs2_out, id_ex_imm_extend_out;
wire [1:0] fw_a, fw_b, fw_a_Calculator, fw_b_Calculator;




mux mux_jalr (.a(PC_i), .b(ReadData1), .select(JALRSrc), .out(PC_in));
programCounter PC (.in(PC_in), .out(PC_out), .enable(PCWrite), .clock(clock), .reset(reset));
instructionMemory Instruction_memory (.address(PC_out), .data_out(Instruction));
ADD Add_4(.a(PC_out), .b(4), .out(PC_inc));

if_id_register if_id_register(.if_id_pc_in(PC_out), .if_id_instructions_in(Instruction), .if_id_pc_out(if_id_pc_out), .if_id_instructions_out(if_id_instructions_out),
							  .enable(if_id_write), .clock(clock), .reset(reset), .if_id_flush(flush));


control control (.Instruction(if_id_instructions_out), .Branch(Branch), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .PCSrc(PCSrc), .JALRSrc(JALRSrc), .RegWrite(RegWrite), .ALUOp(ALUOp), .Type_Select(Type_Select),
                 .Imm_extend(Imm_extend));
register register (.Read_register_1(if_id_instructions_out[19:15]), .Read_register_2(if_id_instructions_out[24:20]), .Write_register(mem_wb_WriteReg_out), .Write_data(RegWriteData),
				   .RegWrite(mem_wb_RegWrite_out), .Read_data_1(ReadData1), .Read_data_2(ReadData2), .Imm_extend(Imm_extend), .clock(clock), .reset(reset));
				   
mux3input mux3ABranchCalc(.a(ReadData1), .b(MemReadData), .c(ALUOut), .select(fw_a_Calculator), .out(forwarding_A_BranchCalculator_out));
mux3input mux3BBranchCalc(.a(ReadData2), .b(MemReadData), .c(ALUOut), .select(fw_b_Calculator), .out(forwarding_B_BranchCalculator_out));

forwarding_Unit_Calc forw_u_Calc(.rs1(if_id_instructions_out[19:15]), .rs2(if_id_instructions_out[24:20]), .ex_mem_WriteReg(id_ex_WriteReg_out), .ex_mem_RegWrite(id_ex_RegWrite_out), .ex_mem_MemtoReg(id_ex_MemtoReg_out),
								.mem_wb_WriteReg(ex_mem_WriteReg_out), .mem_wb_RegWrite(ex_mem_RegWrite_out), .mem_wb_MemtoReg(ex_mem_MemtoReg_out), .fw_a(fw_a_Calculator), .fw_b(fw_b_Calculator), .Imm_extend(Imm_extend),
								.id_ex_MemWrite(id_ex_MemWrite_out));

branch_calculator branch_Calc(.Read_data_1(forwarding_A_BranchCalculator_out), .Read_data_2(forwarding_B_BranchCalculator_out), .operation(ALUOp_nopMux), .branch_calculator_select(branch_calculator_select));

imm_gen imm_gen(.Instruction(if_id_instructions_out), .Imm_extend(Imm_extend), .Imm_out(Imm_out));

hazard_detection_unit hazard_detection_unit(.if_id_rs1(if_id_instructions_out[19:15]), .if_id_rs2(if_id_instructions_out[24:20]), .id_ex_WriteReg(id_ex_WriteReg_out),
										    .id_ex_MemtoReg_out(id_ex_MemtoReg_out), .PCWrite(PCWrite), .if_id_write(if_id_write), .nopMux_select(nopMux_select), .clock(clock), .enable(step), .reset(reset),
											.MemWrite(MemWrite), .id_ex_RegWrite_out(id_ex_RegWrite_out));

nopMux nopMux (.Branch(Branch), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .PCSource(PCSrc), .nopMux_Select(nopMux_select), .ALUOp(ALUOp), .Type_Select(Type_Select),
			   .Branch_nopMux(Branch_nopMux), .MemtoReg_nopMux(MemtoReg_nopMux), .MemWrite_nopMux(MemWrite_nopMux), .ALUSrc_nopMux(ALUSrc_nopMux), .RegWrite_nopMux(RegWrite_nopMux),
			   .PCSource_nopMux(PCSource_nopMux), .ALUOp_nopMux(ALUOp_nopMux), .Type_Select_nopMux(Type_Select_nopMux));
			   		   
		   
assign Branch_select = Branch_nopMux & branch_calculator_select;
assign flush = Branch_select || JALRSrc;

ADD add_sum(.a(if_id_pc_out), .b(Imm_out), .out(PC_branch));

id_ex_register id_ex_register(.id_ex_pc_in(if_id_pc_out), .id_ex_pc_out(id_ex_pc_out), .id_ex_readdata1_in(ReadData1), .id_ex_readdata1_out(id_ex_readdata1_out),
					  .id_ex_readdata2_in(ReadData2), .id_ex_readdata2_out(id_ex_readdata2_out), .id_ex_imm_gen_in(Imm_out), .id_ex_imm_gen_out(id_ex_imm_gen_out),
					  .enable(step), .clock(clock), .reset(reset), .id_ex_Branch_in(Branch_nopMux), .id_ex_MemtoReg_in(MemtoReg_nopMux), .id_ex_MemWrite_in(MemWrite_nopMux), .id_ex_ALUSrc_in(ALUSrc_nopMux), .id_ex_PCSrc_in(PCSource_nopMux), .id_ex_RegWrite_in(RegWrite_nopMux),
					  .id_ex_Branch_out(id_ex_Branch_out), .id_ex_MemtoReg_out(id_ex_MemtoReg_out), .id_ex_MemWrite_out(id_ex_MemWrite_out), .id_ex_ALUSrc_out(id_ex_ALUSrc_out), .id_ex_PCSrc_out(id_ex_PCSrc_out), 
					  .id_ex_RegWrite_out(id_ex_RegWrite_out), .id_ex_ALUOp_in(ALUOp_nopMux), .id_ex_Type_Select_in(Type_Select_nopMux), .id_ex_Instructies_in(if_id_instructions_out), .id_ex_ALUOp_out(id_ex_ALUOp_out),
					  .id_ex_Type_Select_out(id_ex_Type_Select_out), .id_ex_WriteReg_out(id_ex_WriteReg_out), .id_ex_rs1_out(id_ex_rs1_out), .id_ex_rs2_out(id_ex_rs2_out),
					  .id_ex_imm_extend_in(Imm_extend), .id_ex_imm_extend_out(id_ex_imm_extend_out));



mux3input mux3fa(.a(id_ex_readdata1_out), .b(RegWriteData), .c(ex_mem_alu_result_out), .select(fw_a), .out(forwarding_A_out));
mux3input mux3fb(.a(id_ex_readdata2_out), .b(RegWriteData), .c(ex_mem_alu_result_out), .select(fw_b), .out(forwarding_B_out));

forwarding_Unit forw_u(.rs1(id_ex_rs1_out), .rs2(id_ex_rs2_out), .ex_mem_WriteReg(ex_mem_WriteReg_out), .ex_mem_RegWrite(ex_mem_RegWrite_out), .ex_mem_MemtoReg(ex_mem_MemtoReg_out),
								.mem_wb_WriteReg(mem_wb_WriteReg_out), .mem_wb_RegWrite(mem_wb_RegWrite_out), .mem_wb_MemtoReg(mem_wb_MemtoReg_out), .fw_a(fw_a), .fw_b(fw_b), .Imm_extend(id_ex_imm_extend_out));


mux mux_aluReg(.a(forwarding_B_out), .b(id_ex_imm_gen_out), .select(id_ex_ALUSrc_out), .out(ALU_in2));

ALU alu(.a(ALU_in1), .b(ALU_in2), .operation(id_ex_ALUOp_out), .out(ALUOut), .zero(zero));

mux muxPC(.a(forwarding_A_out), .b(id_ex_pc_out), .select(id_ex_PCSrc_out), .out(ALU_in1));

ex_mem_register ex_mem_register(.ex_mem_pc_in(PC_branch), .ex_mem_pc_out(ex_mem_pc_out), .ex_mem_readdata2_in(forwarding_B_out), .ex_mem_readdata2_out(ex_mem_readdata2_out),
					   .ex_mem_zero_in(zero), .ex_mem_zero_out(ex_mem_zero_out), .ex_mem_alu_result_in(ALUOut), .ex_mem_alu_result_out(ex_mem_alu_result_out),
					   .enable(step), .clock(clock), .reset(reset), .ex_mem_Branch_in(id_ex_Branch_out), .ex_mem_MemtoReg_in(id_ex_MemtoReg_out), .ex_mem_MemWrite_in(id_ex_MemWrite_out), .ex_mem_RegWrite_in(id_ex_RegWrite_out),
					   .ex_mem_Branch_out(ex_mem_Branch_out), .ex_mem_MemtoReg_out(ex_mem_MemtoReg_out), .ex_mem_MemWrite_out(ex_mem_MemWrite_out), .ex_mem_RegWrite_out(ex_mem_RegWrite_out),
					   .ex_mem_Type_Select_in(id_ex_Type_Select_out), .ex_mem_WriteReg_in(id_ex_WriteReg_out), .ex_mem_Type_Select_out(ex_mem_Type_Select_out), .ex_mem_WriteReg_out(ex_mem_WriteReg_out));


mux mux_pc(.a(PC_inc), .b(PC_branch), .select(Branch_select), .out(PC_i));

ram Data_memory(.address(ex_mem_alu_result_out), .data_in(ex_mem_readdata2_out), .data_out(MemReadData), .enable(step), .reset(reset), .write_enable(ex_mem_MemWrite_out), .Type_Select(ex_mem_Type_Select_out),
						 .clock(clock), .SW(switch), .KEY(key));

mem_wb_register mem_wb_register(.mem_wb_read_data_in(MemReadData), .mem_wb_read_data_out(mem_wb_read_data_out), .mem_wb_alu_result_in(ex_mem_alu_result_out), .mem_wb_alu_result_out(mem_wb_alu_result_out),
							    .mem_wb_MemtoReg_in(ex_mem_MemtoReg_out), .mem_wb_RegWrite_in(ex_mem_RegWrite_out), .mem_wb_MemtoReg_out(mem_wb_MemtoReg_out), .mem_wb_RegWrite_out(mem_wb_RegWrite_out),
								.mem_wb_WriteReg_in(ex_mem_WriteReg_out), .mem_wb_WriteReg_out(mem_wb_WriteReg_out), .enable(step), .clock(clock), .reset(reset));
								
mux mux_memData(.a(mem_wb_alu_result_out), .b(mem_wb_read_data_out), .select(mem_wb_MemtoReg_out), .out(RegWriteData));




endmodule