
//---------------------------------------------------------//
module shift_left (input signed [31:0] Imm_out, output signed [31:0] out);
//---------------------------------------------------------//


	assign out = Imm_out << 1;


endmodule