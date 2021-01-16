
//-----------------------------------------------------------//
module ADD(a, b, out);
//-----------------------------------------------------------//

`include "RISCV.h"
parameter size = XLEN; // default value
input signed [size-1:0] a, b;
output signed [size-1:0] out;
wire [size-1:0] out;

	assign out = a + b;

endmodule
