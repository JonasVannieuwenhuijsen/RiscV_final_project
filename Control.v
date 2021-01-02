
//----------------------------------------------------------------//
module control (input [31:0] Instruction,
output reg Branch, MemtoReg, MemWrite, ALUSrc, PCSrc, JALRSrc, RegWrite,
output reg [3:0] ALUOp,
output reg [2:0] Type_Select,
output reg [4:0] Imm_extend);
//----------------------------------------------------------------//

`include "RISCV.h"
wire [4:0] opcode = Instruction[ 6: 2];
wire [2:0] funct3 = Instruction[14:12];
wire [6:0] funct7 = Instruction[31:25];

// RV32I instruction
wire std32 = (Instruction[1:0] == 2'b11); // standard 32 bit instruction

// instruction group
wire lui_gr = (opcode == 5'b01101); // lui
wire aui_gr = (opcode == 5'b00101); // auipc
wire jal_gr = (opcode == 5'b11011); // jal
wire jlr_gr = (opcode == 5'b11001); // jalr
wire bra_gr = (opcode == 5'b11000); // branch group
wire loa_gr = (opcode == 5'b00000); // load group
wire sto_gr = (opcode == 5'b01000); // store group
wire rim_gr = (opcode == 5'b00100); // arithmetic & logic immediate group
wire reg_gr = (opcode == 5'b01100); // arithmetic & logic R-type instructions
wire fen_gr = (opcode == 5'b00011); // fence instructions group
wire csr_gr = (opcode == 5'b11100); // csr instructions group

// wires indicating selected instruction
wire beq_inst = std32 && bra_gr && (funct3 == 3'b000);
wire lw_inst 	= std32 && loa_gr && (funct3 == 3'b010);
wire sw_inst 	= std32 && sto_gr && (funct3 == 3'b010);
wire add_inst 	= std32 && reg_gr && (funct3 == 3'b000) && (funct7 == 7'b0000000);
wire sub_inst 	= std32 && reg_gr && (funct3 == 3'b000) && (funct7 == 7'b0100000);
wire or_inst 	= std32 && reg_gr && (funct3 == 3'b110) && (funct7 == 7'b0000000);
wire ori_inst 	= std32 && rim_gr && (funct3 == 3'b110);
wire and_inst 	= std32 && reg_gr && (funct3 == 3'b111) && (funct7 == 7'b0000000);
wire andi_inst 	= std32 && rim_gr && (funct3 == 3'b111);
wire addi_inst 	= std32 && rim_gr && (funct3 == 3'b000);
wire lui_inst 	= std32 && lui_gr;
wire auipc_inst = std32 && aui_gr;
wire jal_inst 	= std32 && jal_gr;
wire jlr_inst 	= std32 && jlr_gr && (funct3 == 3'b000);
wire bne_inst 	= std32 && bra_gr && (funct3 == 3'b001);
wire blt_inst 	= std32 && bra_gr && (funct3 == 3'b100);
wire bltu_inst 	= std32 && bra_gr && (funct3 == 3'b110);
wire bge_inst 	= std32 && bra_gr && (funct3 == 3'b101);
wire bgeu_inst 	= std32 && bra_gr && (funct3 == 3'b111);

wire lb_inst 	= std32 && loa_gr && (funct3 == 3'b000);
wire lbu_inst 	= std32 && loa_gr && (funct3 == 3'b100);
wire lh_inst 	= std32 && loa_gr && (funct3 == 3'b001);
wire lhu_inst 	= std32 && loa_gr && (funct3 == 3'b101);

wire sb_inst 	= std32 && sto_gr && (funct3 == 3'b000);
wire sh_inst 	= std32 && sto_gr && (funct3 == 3'b001);

wire slti_inst 	= std32 && rim_gr && (funct3 == 3'b010);
wire sltiu_inst = std32 && rim_gr && (funct3 == 3'b011);
wire slt_inst 	= std32 && reg_gr && (funct3 == 3'b010) && (funct7 == 7'b0000000);
wire sltu_inst 	= std32 && reg_gr && (funct3 == 3'b011) && (funct7 == 7'b0000000);

wire xori_inst 	= std32 && rim_gr && (funct3 == 3'b100);
wire xor_inst 	= std32 && reg_gr && (funct3 == 3'b100) && (funct7 == 7'b0000000);

wire sll_inst 	= std32 && reg_gr && (funct3 == 3'b001) && (funct7 == 7'b0000000);
wire slli_inst 	= std32 && rim_gr && (funct3 == 3'b001);
wire srl_inst 	= std32 && reg_gr && (funct3 == 3'b101) && (funct7 == 7'b0000000);
wire srli_inst 	= std32 && rim_gr && (funct3 == 3'b101) && (funct7 == 7'b0000000);

wire sra_inst	= std32 && reg_gr && (funct3 == 3'b101) && (funct7 == 7'b0100000);
wire srai_inst	= std32 && rim_gr && (funct3 == 3'b101) && (funct7 == 7'b0100000);

always @* begin
   Branch = 0; MemtoReg = 0; MemWrite = 0; ALUSrc = 0; PCSrc = 0; JALRSrc = 0; RegWrite = 0; ALUOp = 0; Imm_extend = 0; Type_Select = 0;
   case (1'b1)
	beq_inst 	: begin ALUOp = ALU_SUB; Branch = 1; Imm_extend = B_IMM; end
	lb_inst 	: begin Imm_extend = I_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemtoReg = 1; RegWrite = 1; Type_Select = BYTE; end
	lbu_inst	: begin Imm_extend = I_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemtoReg = 1; RegWrite = 1; Type_Select = BYTEU; end
	lh_inst 	: begin Imm_extend = I_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemtoReg = 1; RegWrite = 1; Type_Select = HALF_WORD; end
	lhu_inst	: begin Imm_extend = I_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemtoReg = 1; RegWrite = 1; Type_Select = HALF_WORDU; end
	lw_inst 	: begin Imm_extend = I_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemtoReg = 1; RegWrite = 1; Type_Select = WORD; end
	sb_inst 	: begin Imm_extend = S_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemWrite = 1; Type_Select = BYTE; end
	sh_inst 	: begin Imm_extend = S_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemWrite = 1; Type_Select = HALF_WORD; end
	sw_inst 	: begin Imm_extend = S_IMM; ALUOp = ALU_ADD; ALUSrc = 1; MemWrite = 1; Type_Select = WORD; end
	add_inst 	: begin ALUOp = ALU_ADD; RegWrite = 1; end
	sub_inst 	: begin ALUOp = ALU_SUB; RegWrite = 1; end
	or_inst 	: begin ALUOp = ALU_OR; RegWrite = 1; end
	ori_inst 	: begin Imm_extend = I_IMM; ALUOp = ALU_OR; ALUSrc = 1; RegWrite = 1; end
	and_inst 	: begin ALUOp = ALU_AND; RegWrite = 1; end
	andi_inst 	: begin ALUOp = ALU_AND; RegWrite = 1; Imm_extend = I_IMM; ALUSrc = 1; end
	addi_inst 	: begin Imm_extend = I_IMM; RegWrite = 1; ALUSrc = 1; ALUOp = ALU_ADD; end
	lui_inst 	: begin  Imm_extend = U_IMM; RegWrite = 1; ALUOp = ALU_ADD; ALUSrc = 1; end
	auipc_inst 	: begin Imm_extend = U_IMM; PCSrc = 1; ALUOp = ALU_ADD; ALUSrc = 1; RegWrite = 1; end 
	jal_inst 	: begin Imm_extend = J_IMM; Branch = 1; PCSrc = 1; ALUOp = ALU_JAL; RegWrite = 1; end 
	jlr_gr 		: begin Imm_extend = I_IMM; PCSrc = 1; JALRSrc = 1; ALUOp = ALU_JAL; RegWrite = 1; end 
	bne_inst	: begin Imm_extend = B_IMM; ALUOp = ALU_BRANCH; Branch = 1; end
	blt_inst	: begin Imm_extend = B_IMM; ALUOp = ALU_BLT; Branch = 1; end
	bltu_inst	: begin Imm_extend = B_IMM; ALUOp = ALU_BLTU; Branch = 1; end
	bge_inst	: begin Imm_extend = B_IMM; ALUOp = ALU_BGE; Branch = 1; end
	bgeu_inst	: begin Imm_extend = B_IMM; ALUOp = ALU_BGEU; Branch = 1; end
	slti_inst	: begin Imm_extend = I_IMM; ALUSrc = 1; ALUOp = ALU_SLT; RegWrite = 1; end
	sltiu_inst	: begin Imm_extend = I_IMM; ALUSrc = 1; ALUOp = ALU_SLTU; RegWrite = 1; end
	slt_inst	: begin ALUOp = ALU_SLT; RegWrite = 1; end
	sltu_inst	: begin ALUOp = ALU_SLTU; RegWrite = 1; end
	xori_inst	: begin Imm_extend = I_IMM; ALUSrc = 1; ALUOp = ALU_XOR; RegWrite = 1; end
	xor_inst	: begin ALUOp = ALU_XOR; RegWrite = 1; end
	slli_inst	: begin Imm_extend = I_IMM; ALUSrc = 1; ALUOp = ALU_SLL; RegWrite = 1; end
	sll_inst	: begin ALUOp = ALU_SLL; RegWrite = 1; end
	srli_inst	: begin Imm_extend = I_IMM; ALUSrc = 1; ALUOp = ALU_SRL; RegWrite = 1; end
	srl_inst	: begin ALUOp = ALU_SRL; RegWrite = 1; end
	sra_inst	: begin ALUOp = ALU_SRA; RegWrite = 1; end
	srai_inst	: begin Imm_extend = I_IMM; ALUSrc = 1; ALUOp = ALU_SRA; RegWrite = 1; end
	
	default: ; // Here we need to implement an exception (currently NOP)
   endcase
end

endmodule
