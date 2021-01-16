
parameter XLEN = 32;

// ALU operations coding
parameter ALU_AND 		= 4'b0000;
parameter ALU_OR 		= 4'b0001;
parameter ALU_ADD 		= 4'b0010;
parameter ALU_SUB 		= 4'b0011;
parameter ALU_JAL 		= 4'b0100;
parameter ALU_BRANCH 	= 4'b0101;
parameter ALU_BLTU		= 4'b0110;
parameter ALU_BGEU 		= 4'b0111;
parameter ALU_SLTU		= 4'b1000;
parameter ALU_XOR		= 4'b1001;
parameter ALU_SLL		= 4'b1010;		
parameter ALU_SRL		= 4'b1011;
parameter ALU_BLT		= 4'b1100;
parameter ALU_BGE		= 4'b1101;
parameter ALU_SLT 		= 4'b1110;
parameter ALU_SRA		= 4'b1111;

// Immediate Types
parameter I_IMM = 5'b00001; // I-Type: Immediates and Loads
parameter B_IMM = 5'b00010; // B-Type: conditional branches
parameter S_IMM = 5'b00100; // S-Type: stores
parameter U_IMM = 5'b01000; // U-Type: upper immediates
parameter J_IMM = 5'b10000; // J-Type: unconditional jumps

// store & load types
parameter WORD = 3'b010;
parameter HALF_WORDU = 3'b001;
parameter BYTEU = 3'b000;
parameter BYTE = 3'b011;
parameter HALF_WORD = 3'b100;