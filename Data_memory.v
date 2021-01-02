//----------------------------------------------------------------//
module Data_memory(address, data_in, data_out, enable, reset, write_enable, Type_Select ,clock, SW, KEY);
//----------------------------------------------------------------//

`include "RISCV.h"

parameter logwords = 6; // default max address bit (log2(words))
parameter words = 2**logwords; // default number of words
parameter size = XLEN; // default number of data bits
parameter addr_size = XLEN; // default address size
parameter contentsMemory = "ram.hex"; // default rom contents
parameter contentsStack = "stack.hex";

input [addr_size-1:0] address;
input [size-1:0] data_in;
input [9:0] SW;
input [2:0] KEY;
input [2:0] Type_Select;
output reg [size-1:0] data_out;
reg [size-1:0] data_out_temp;
input write_enable, clock, enable, reset;

reg [size-1:0] memory [0:words-1];
reg [size-1:0] stack [0:words-1];

reg [size-1:0] LED_reg;
reg [size-1:0] SW_reg;
reg [size-1:0] KEY_reg;
reg [size-1:0] HEX0_reg;
reg [size-1:0] HEX1_reg;
reg [size-1:0] HEX2_reg;
reg [size-1:0] HEX3_reg;
reg [size-1:0] HEX4_reg;
reg [size-1:0] HEX5_reg;
reg [size-1:0] HEXValue_reg;
reg [size-1:0] HEXMode_reg;


initial $readmemh(contentsMemory, memory); // Initialize the RAM contents
initial $readmemh(contentsStack, stack); // Initialize the RAM contents

reg Memory_select, LEDR_select, SW_select, KEY_select, HEX0_select, HEX1_select, HEX2_select, HEX3_select, HEX4_select, HEX5_select, HEXValue_select, HEXMode_select, Stack_select;


always @* begin

	Memory_select = 0; LEDR_select = 0; SW_select = 0; KEY_select = 0; HEX0_select = 0; HEX1_select = 0; HEX2_select = 0; HEX3_select = 0; HEX4_select = 0; HEX5_select = 0;
	HEXValue_select = 0; HEXMode_select = 0; Stack_select = 0;
	
	case(address[XLEN-1:12])
	
		{{(XLEN-32){1'b0}}, 20'h10000} : Memory_select = 1;
		{{(XLEN-32){1'b0}}, 20'h7ffff} : Stack_select = 1;
		{{(XLEN-32){1'b0}}, 20'h40000} : case (address[11:8])
		
														0: LEDR_select = 1;
														1: SW_select = 1;
														2: KEY_select = 1;
														3: case (address[7:0])
																
																8'h0:		HEX0_select = 1;
																8'h4:		HEX1_select = 1;
																8'h8:		HEX2_select = 1;
																8'hC:		HEX3_select = 1;
																8'h10:	HEX4_select = 1;
																8'h14:	HEX5_select = 1;
																8'h18:	HEXValue_select = 1;
																8'h1C:	HEXMode_select = 1;
																default: ;
															endcase
															default: ;
													endcase
			default: ;
	endcase
end


always @* begin

	data_out <= 0;
	data_out_temp <= 0;


	if (LEDR_select) data_out <= LED_reg;
	else if (SW_select) data_out <= {{(XLEN-10){1'b0}}, SW};
	else if (KEY_select) data_out <= {{(XLEN-4){1'b0}}, KEY, 1'b0};
	else if (HEX0_select) data_out <= HEX0_reg;
	else if (HEX1_select) data_out <= HEX1_reg;
	else if (HEX2_select) data_out <= HEX2_reg;
	else if (HEX3_select) data_out <= HEX3_reg;
	else if (HEX4_select) data_out <= HEX4_reg;
	else if (HEX5_select) data_out <= HEX5_reg;
	else if (HEXValue_select) data_out <= HEXValue_reg;
	else if (HEXMode_select) data_out <= HEXMode_reg;
	else if (Stack_select) begin
		data_out_temp <= stack[address[logwords+1:2]];
		case (Type_Select)
			WORD 		: data_out <= data_out_temp;
			HALF_WORDU 	: data_out <= data_out_temp[15:0];
			BYTEU 		: data_out <= data_out_temp[7:0];
			HALF_WORD	: data_out <= {{(XLEN - 16){data_out_temp[15]}}, data_out_temp[15:0]};
			BYTE		: data_out <= {{(XLEN - 8){data_out_temp[7]}}, data_out_temp[7:0]};
			default: ;
		endcase
		end
	else begin 
		data_out_temp <= memory[address[logwords+1:2]];
		case (Type_Select)
			WORD 		: data_out <= data_out_temp;
			HALF_WORDU 	: data_out <= data_out_temp[15:0];
			BYTEU 		: data_out <= data_out_temp[7:0];
			HALF_WORD	: data_out <= {{(XLEN - 16){data_out_temp[15]}}, data_out_temp[15:0]};
			BYTE		: data_out <= {{(XLEN - 8){data_out_temp[7]}}, data_out_temp[7:0]};
			default: ;
		endcase
		end
	end
	
always @(posedge clock) begin
	if (reset) begin
		$readmemh(contentsMemory, memory);
		$readmemh(contentsStack, stack);
		LED_reg <= 32'b0;
		//SW_reg <= 32'b0;
		//KEY_reg <= 32'b0;
		HEX0_reg <= 32'b0;
		HEX1_reg <= 32'b0;
		HEX2_reg <= 32'b0;
		HEX3_reg <= 32'b0;
		HEX4_reg <= 32'b0;
		HEX5_reg <= 32'b0;
		HEXValue_reg <= 32'b0;
		HEXMode_reg <= 32'b0;
	end
   else if(enable && write_enable) begin
				if(Memory_select)  begin 
					case (Type_Select)
						WORD 		: memory[address[logwords+1:2]] <= data_in;
						HALF_WORD 	: memory[address[logwords+1:2]] <= data_in[15:0];
						BYTE 		: memory[address[logwords+1:2]] <= data_in[7:0];
						default: ;
					endcase
				end else if (Stack_select) begin 
					case (Type_Select)
						WORD 		: stack[address[logwords+1:2]] <= data_in;
						HALF_WORD 	: stack[address[logwords+1:2]] <= data_in[15:0];
						BYTE 		: stack[address[logwords+1:2]] <= data_in[7:0];
						default: ;
					endcase
				end
				else if (LEDR_select) LED_reg <= data_in;
				else if (HEX0_select) HEX0_reg <= data_in;
				else if (HEX1_select) HEX1_reg <= data_in;
				else if (HEX2_select) HEX2_reg <= data_in;
				else if (HEX3_select) HEX3_reg <= data_in;
				else if (HEX4_select) HEX4_reg <= data_in;
				else if (HEX5_select) HEX5_reg <= data_in;
				else if (HEXValue_select) HEXValue_reg <= data_in;
				else if (HEXMode_select) HEXMode_reg <= data_in;
			end
		end
	

endmodule