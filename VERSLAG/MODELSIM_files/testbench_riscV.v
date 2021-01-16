module RISCV_testbench();

`timescale 1ns/1ps
`include "RISCV.h"

wire [XLEN-1:0] PC_in, PC_in0, PC_out, PC_inc, PC_branch, Imm_Out, RegWriteData, ReadData1, ReadData2, MemWriteData, MemReadData,
                ALU_in1, ALU_in2, ALUOut;
wire [31:0] Instruction;
wire Zero, Branch, Branch_select, MemWrite, ALUSrc, RegWrite, ALUPC, MemtoReg;
wire [3:0] ALUOp;
wire [5:0] Imm_extend; 

reg clock = 0;
reg reset = 0;
reg [9:0] switch;
reg [1:0] key;

always begin
   #10 clock = !clock;
end

initial begin
   // reset the processor in the first clock period
   #5 reset = 1;
   #10 reset = 0;
   #10 switch = 1;
   #5 key = 2'b11;
   #1000 key = 2'b00;
   // Initialize some values in the register file
   /*
   cpu.register.regfile[5]  = 32'h00000003;  // t0
   cpu.register.regfile[6]  = 32'h00000005;  // t1
   cpu.register.regfile[7]  = 32'h00000015;  // t2
   cpu.register.regfile[28] = 32'h00000000;  // t3
   cpu.register.regfile[29] = 32'h00000000;  // t4
   cpu.register.regfile[30] = 32'h00000001;  // t5
   cpu.register.regfile[31] = 32'h10000000;  // t6 Used here as address for data segment
   */
end

initial #500 $stop;

// simulation output
always begin // Print header line every 20 lines
   $display ("Time |    PC    Instruct | IFEX |    PC    Instruct | IDEX |    PC    | IMM_E B MtR MW MT  AOp  PCs AS RW | ReadDat1 ReadDat2 WriteReg Imm_out  | EXMEM | PCbranch | B MtR MW MT  RW Z | ALUout   ReadDat2 WriteReg | MEMWB | MtR RW | MemRdDat ALUout   WriteReg | ");
   $display ("---- + -------- -------- + ---- + -------- -------- + ---- + -------- + ----- - --- -- --- ---- --- -- -- + -------- -------- -------- -------- + ----- + -------- + - --- -- --- -- - + -------- -------- -------- + ----- + --- -- + -------- -------- -------- | ");
   
  #400 $display (" ");
end

always 
   #20 $display ("%4d | %8h %8h | IFEX | %8h %8h | IDEX | %8h | %5b %1b   %1b  %1b %3b %4b   %1b  %1b  %1b | %8h %8h %8h %8h | EXMEM | %8h | %1b   %1b  %1b %3b  %1b %1b | %8h %8h %8h | MEMWB |   %1b  %1b | %8h %8h %8h | ", 
                 ($time/20), cpu.PC.out, cpu.Instruction_memory.data_out,
				 // IF_EX
				 cpu.if_id_register.if_id_pc_out, cpu.if_id_register.if_id_instructions_out, 
				 // ID_EX
				 cpu.id_ex_register.id_ex_pc_out, cpu.control.Imm_extend, cpu.id_ex_register.id_ex_Branch_out, cpu.id_ex_register.id_ex_MemtoReg_out, cpu.id_ex_register.id_ex_MemWrite_out, cpu.id_ex_register.id_ex_Type_Select_out, cpu.id_ex_register.id_ex_ALUOp_out, cpu.id_ex_register.id_ex_PCSrc_out, cpu.id_ex_register.id_ex_ALUSrc_out, cpu.id_ex_register.id_ex_RegWrite_out, cpu.id_ex_register.id_ex_readdata1_out, cpu.id_ex_register.id_ex_readdata2_out, cpu.id_ex_register.id_ex_WriteReg_out, cpu.id_ex_register.id_ex_imm_gen_out,
				 // EX_MEM
				 cpu.ex_mem_register.ex_mem_pc_out, cpu.ex_mem_register.ex_mem_Branch_out, cpu.ex_mem_register.ex_mem_MemtoReg_out, cpu.ex_mem_register.ex_mem_MemWrite_out, cpu.ex_mem_register.ex_mem_Type_Select_out, cpu.ex_mem_register.ex_mem_RegWrite_out, cpu.ex_mem_register.ex_mem_zero_out, cpu.ex_mem_register.ex_mem_alu_result_out, cpu.ex_mem_register.ex_mem_readdata2_out, cpu.ex_mem_register.ex_mem_WriteReg_out, 
				 // MEM_WB
				 cpu.mem_wb_register.mem_wb_MemtoReg_out, cpu.mem_wb_register.mem_wb_RegWrite_out, cpu.mem_wb_register.mem_wb_read_data_out, cpu.mem_wb_register.mem_wb_alu_result_out, cpu.mem_wb_register.mem_wb_WriteReg_out
                 ) ;
   // in the previous $display you can also use the "." dot notation to access specific signals.
   // instead of PC_out we can also write:
   // cpu.PC.out 

RiscV_cpu cpu (.clock(clock), .reset(reset), .step(1'b1), .switch(switch), .key(key));

endmodule 



