

//-----------------------------------------------------//
module nopMux(Branch, MemtoReg, MemWrite, ALUSrc, RegWrite, PCSource, nopMux_Select, ALUOp, Type_Select, Branch_nopMux, MemtoReg_nopMux, MemWrite_nopMux, ALUSrc_nopMux, RegWrite_nopMux, PCSource_nopMux, ALUOp_nopMux, Type_Select_nopMux);
//-----------------------------------------------------//
`include "RISCV.h"

input Branch, MemtoReg, MemWrite, ALUSrc, RegWrite, PCSource, nopMux_Select;
input [3:0] ALUOp;
input [2:0] Type_Select;
output reg Branch_nopMux, MemtoReg_nopMux, MemWrite_nopMux, ALUSrc_nopMux, RegWrite_nopMux, PCSource_nopMux;
output reg [3:0] ALUOp_nopMux;
output reg [2:0] Type_Select_nopMux;

always @(*) begin
	Branch_nopMux = 0; MemtoReg_nopMux = 0; MemWrite_nopMux = 0; ALUSrc_nopMux = 0; RegWrite_nopMux = 0; PCSource_nopMux = 0; ALUOp_nopMux = 0; Type_Select_nopMux = 0;
	case (nopMux_Select)
		0 :  begin Branch_nopMux = Branch; MemtoReg_nopMux = MemtoReg; MemWrite_nopMux = MemWrite; ALUSrc_nopMux = ALUSrc; RegWrite_nopMux = RegWrite; PCSource_nopMux = PCSource; ALUOp_nopMux = ALUOp; Type_Select_nopMux = Type_Select; end
		1 :  begin Branch_nopMux = 0; MemtoReg_nopMux = 0; MemWrite_nopMux = 0; ALUSrc_nopMux = 0; RegWrite_nopMux = 0; PCSource_nopMux = 0; ALUOp_nopMux = 0; Type_Select_nopMux = 0; end
	default: ;

 endcase

end

endmodule
