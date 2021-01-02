
//----------------------------------------------------------------------//
module ALU(a, b, operation, out, zero);
//----------------------------------------------------------------------//

`include "RISCV.h"

input [XLEN-1:0] a, b;
reg signed [XLEN-1:0] sra;
input [3:0] operation;
output zero;
output [XLEN-1:0] out;
reg [XLEN-1:0] out, a_temp, b_temp, out_temp;
reg zero, a_neg, b_neg;
reg signed [XLEN-1:0] a_signed, rsa_signed;

integer b_int;


always @(a or b or operation) begin
	out = 0;
	sra = 0;
	sra[31] = 1;
   case (operation) //
	ALU_AND 	: out = a & b; // and
	ALU_OR 		: out = a | b; // or
	ALU_ADD 	: out = a + b; // add
	ALU_SUB 	: out = a - b; // subtract
	ALU_BRANCH 	: out = a - b;
	ALU_JAL 	: out = a + 4;
	ALU_SLTU 	: out[0] = (a < b);
	ALU_SLT 	: begin 
					a_neg = 0;
					b_neg = 0;
					if (a[31]) begin
						a_temp <= ~a + 1;
						a_neg = 1;
					end else begin
						a_temp <= a;
					end
					if (b[31]) begin
						b_temp <= ~b + 1;
						b_neg = 1;
					end else begin
						b_temp <= b;
					end
					if (a_neg && b_neg) out[0] = (a < b);
					else if (a_neg) out[0] = 1;
					else if (b_neg) out[0] = 0;
					else out[0] = (a < b);
				  end
	ALU_XOR 	: out = a ^ b;
	ALU_SLL 	: out = a << b;
	ALU_SRL 	: out = a >> b;
	ALU_SRA		: begin
					b_temp = b;
					b_temp[10] = 0;
					if(a[31]) begin
						b_int = b_temp - 1;
						rsa_signed = sra >>> b_int;
						a_signed = a >> b_temp;
						out = (rsa_signed + a_signed);
					end else begin
						out =a >> b_temp;
					end
				  end
	default 	: out = 0;
   endcase
   
	if(operation == ALU_JAL)
		zero <= 1'b1;
	else if (operation == ALU_BRANCH)
		zero <= ~(out == {XLEN{1'b0}});
	else if (operation == ALU_BLTU)
		zero <= (a < b);
	else if (operation == ALU_BGEU)
		zero <= (a >= b);
	else if (operation == ALU_BLT) begin
		a_neg = 0;
		b_neg = 0;
		if (a[31]) begin
			a_temp <= ~a + 1;
			a_neg = 1;
		end else begin
			a_temp <= a;
		end
		if (b[31]) begin
			b_temp <= ~b + 1;
			b_neg = 1;
		end else begin
			b_temp <= b;
		end
		if (a_neg && b_neg) zero <= (a_temp > b_temp);
		else if (a_neg) zero <= 1;
		else if (b_neg) zero <= 0;
		else zero <= (a < b);
	end else if (operation == ALU_BGE) begin
		a_neg = 0;
		b_neg = 0;
		if (a[31]) begin
			a_temp <= ~a + 1;
			a_neg = 1;
		end else begin
			a_temp <= a;
		end
		if (b[31]) begin
			b_temp <= ~b + 1;
			b_neg = 1;
		end else begin
			b_temp <= b;
		end
		if (a_neg && b_neg) zero <= (b_temp >= a_temp);
		else if (a_neg) zero <= 0;
		else if (b_neg) zero <= 1;
		else zero <= (a >= b);
	end else
		zero <= (out == {XLEN{1'b0}});
end
endmodule