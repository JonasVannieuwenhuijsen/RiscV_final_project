//-----------------------------------------------------//
module forwarding_Unit_Calc(rs1, rs2, ex_mem_WriteReg, ex_mem_RegWrite, ex_mem_MemtoReg, mem_wb_WriteReg, mem_wb_RegWrite, mem_wb_MemtoReg, fw_a, fw_b, Imm_extend, id_ex_MemWrite);
//-----------------------------------------------------//
`include "RISCV.h"

input [4:0] rs1, rs2, ex_mem_WriteReg, mem_wb_WriteReg, Imm_extend;
input ex_mem_RegWrite, ex_mem_MemtoReg, mem_wb_RegWrite, mem_wb_MemtoReg, id_ex_MemWrite;

output reg [1:0] fw_a, fw_b;


always @(*) begin

	fw_a = 0; fw_b = 0;
	
	if ((mem_wb_RegWrite) && (mem_wb_WriteReg != 0) && (mem_wb_WriteReg == rs1))
        begin
            if ((ex_mem_RegWrite) && (ex_mem_WriteReg != 0) && (ex_mem_WriteReg == rs1)) begin end
			else if (id_ex_MemWrite) begin end
            else begin fw_a <= 2'b01; end
        end
    if ((mem_wb_RegWrite) && (mem_wb_WriteReg != 0) && (mem_wb_WriteReg == rs2) && (Imm_extend != 5'b00001)) 
        begin
            if ((ex_mem_RegWrite) && (ex_mem_WriteReg != 0) && (ex_mem_WriteReg == rs2)) begin end
            else begin fw_b <= 2'b01; end 
        end
	if ((ex_mem_RegWrite) && (ex_mem_WriteReg != 0) && (ex_mem_WriteReg == rs1)) begin fw_a <= 2'b10; end
    if ((ex_mem_RegWrite) && (ex_mem_WriteReg != 0) && (ex_mem_WriteReg == rs2) && (Imm_extend != 5'b00001)) begin fw_b <= 2'b10; end
	
end

endmodule

