
//-----------------------------------------------------//
module mux(a, b, select, out);
//-----------------------------------------------------//
`include "RISCV.h"

input [XLEN-1:0] a, b;
input select;

output reg [XLEN-1:0] out;

always @(select or a or b) begin
	out = 0;
	case (select)
 
		0 :  out = a;
		1 : out = b;
	default: ;

 endcase

end

endmodule