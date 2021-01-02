
//-----------------------------------------------------//
module branch_calculator(Read_data_1, Read_data_2, operation, branch_calculator_select);
//-----------------------------------------------------//
`include "RISCV.h"

input [XLEN-1:0] Read_data_1, Read_data_2;
input [3:0] operation;

reg a_neg, b_neg;
reg [XLEN-1:0] temp, a_temp, b_temp;

output reg branch_calculator_select;


always @(*) begin
	branch_calculator_select = 0;
	temp = 0; a_temp = 0; b_temp = 0;
	a_neg = 0; b_neg = 0;
	
	case (operation)
	ALU_SUB		: begin
					temp = Read_data_1 - Read_data_2;
					branch_calculator_select = (temp == {XLEN{1'b0}});
				  end
	ALU_BLT		: begin
					a_neg = 0;
					b_neg = 0;
					if (Read_data_1[31]) begin
						a_temp = ~Read_data_1 + 1;
						a_neg = 1;
					end else begin
						a_temp = Read_data_1;
					end
					if (Read_data_2[31]) begin
						b_temp = ~Read_data_2 + 1;
						b_neg = 1;
					end else begin
						b_temp = Read_data_2;
					end
					if (a_neg && b_neg) branch_calculator_select = (a_temp > b_temp);
					else if (a_neg) branch_calculator_select = 1;
					else if (b_neg) branch_calculator_select = 0;
					else branch_calculator_select = (Read_data_1 < Read_data_2);
				  end
	ALU_BLTU	: branch_calculator_select = (Read_data_1 < Read_data_2);
	ALU_BRANCH	: begin
					temp = Read_data_1 - Read_data_2;
					branch_calculator_select = ~(temp == {XLEN{1'b0}});
				  end
	ALU_BGE		: begin
					a_neg = 0;
					b_neg = 0;
					if (Read_data_1[31]) begin
						a_temp = ~Read_data_1 + 1;
						a_neg = 1;
					end else begin
						a_temp = Read_data_1;
					end
					if (Read_data_2[31]) begin
						b_temp = ~Read_data_2 + 1;
						b_neg = 1;
					end else begin
						b_temp = Read_data_2;
					end
					if (a_neg && b_neg) branch_calculator_select = (b_temp >= a_temp);
					else if (a_neg) branch_calculator_select = 0;
					else if (b_neg) branch_calculator_select = 1;
					else branch_calculator_select = (Read_data_1 >= Read_data_2);
				  end
    ALU_BGEU	: branch_calculator_select = (Read_data_1 >= Read_data_2);
	ALU_JAL		: branch_calculator_select = 1'b1;
	default 	: ;
	endcase
end
endmodule