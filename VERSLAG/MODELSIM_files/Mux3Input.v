
//-----------------------------------------------------//
module mux3input(a, b, c, select, out);
//-----------------------------------------------------//
`include "RISCV.h"

input [XLEN-1:0] a, b, c;
input [1:0] select;

output reg [XLEN-1:0] out;

always @(*) begin
	case (select)
 
		2'b00 : out = a;
		2'b10 : out = c;
		2'b01 : out = b;
	
	default: ;

 endcase

end

endmodule