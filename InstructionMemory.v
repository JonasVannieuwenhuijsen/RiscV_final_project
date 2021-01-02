
//----------------------------------------------------------------//
module instructionMemory(address, data_out);
//----------------------------------------------------------------//


`include "RISCV.h"
parameter logwords = 8; 	// default max address bit (log2(words))
parameter words = 2**logwords; 	// default number of words
parameter size = 32; 		// default number of data bits per instruction word
parameter addr_size = XLEN; 	// default address size
parameter contents = "instructions.hex";	// default rom contents

input [addr_size-1:0] address;
output [size-1:0] data_out;

reg [size-1:0] memory [0:words-1];
reg [size-1:0] data_out;

initial // Initialize the Instruction ROM contents
$readmemh(contents, memory);

always @*
	data_out = memory[address[logwords+1:2]];

endmodule 