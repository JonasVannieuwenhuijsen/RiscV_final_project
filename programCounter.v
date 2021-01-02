
//---------------------------------------------------//
module programCounter(in, out, enable, clock, reset);
//---------------------------------------------------//

`include "RISCV.h"

parameter size = XLEN; // default value
input [size-1:0] in;
output [size-1:0] out;
input clock, reset, enable;
reg [size-1:0] out;

always @(posedge clock)
	if (reset) out <= 0;
	else if (enable) out <= in;

endmodule 