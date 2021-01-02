
//-------------------------------------------------------------------------------//
module register(Read_register_1, Read_register_2, Write_register, Write_data, RegWrite, Read_data_1, Read_data_2, Imm_extend, clock, reset);
//-------------------------------------------------------------------------------//

`include "RISCV.h"

input [4:0] Read_register_1, Read_register_2, Write_register, Imm_extend;
input [XLEN-1:0] Write_data;
input RegWrite, clock, reset;
output [XLEN-1:0] Read_data_1, Read_data_2;

reg [XLEN-1:0] regfile [31:0];
wire [XLEN-1:0] Read_data_1, Read_data_2;
reg [XLEN-1:0] Read_data_1_temp, Read_data_2_temp;

integer i;


always @ (*) begin

	Read_data_1_temp = 0;
	Read_data_2_temp = 0;
	
	if (Write_register == 0) begin 
		Read_data_1_temp = regfile[Read_register_1];
		Read_data_2_temp = regfile[Read_register_2];
	end else if (Write_register == Read_register_1 && Write_register == Read_register_2) begin
		if (Imm_extend == I_IMM) begin
			Read_data_1_temp = Write_data;
			Read_data_2_temp = regfile[Read_register_2];
		end else begin
			Read_data_1_temp = Write_data;
			Read_data_2_temp = Write_data;
		end
	end else if (Write_register == Read_register_2 && Imm_extend != I_IMM) begin
		Read_data_1_temp = regfile[Read_register_1];
		Read_data_2_temp = Write_data;
	end else if (Write_register == Read_register_1) begin
		Read_data_1_temp = Write_data;
		Read_data_2_temp = regfile[Read_register_2];
	end else begin
		Read_data_1_temp = regfile[Read_register_1];
		Read_data_2_temp = regfile[Read_register_2];
	end
	
end

assign Read_data_1 = Read_data_1_temp;
assign Read_data_2 = Read_data_2_temp;

always @(posedge clock) begin
   if (reset) begin
		for (i = 0; i < 32; i = i + 1) regfile[i] = {XLEN{1'b0}};
		regfile[2] = 'h7ffffff0;
   end else begin
		if (RegWrite && (Write_register != 5'b0)) // reg x0 is always zero!
			regfile[Write_register] <= Write_data;
   end
end
endmodule