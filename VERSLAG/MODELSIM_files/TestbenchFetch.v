
module testbench_fetch;

reg clock;
reg reset;
wire [31:0] Instruction;

fetch test (.clock(clock), .reset(reset), .Instruction(Instruction));

initial
   begin
	clock = 1;
	reset = 1;
	#20 clock = 0;
	reset = 1;
	#20 clock = 1;
	reset = 1;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
	#20 clock = 0;
	reset = 0;
	#20 clock = 1;
	reset = 0;
   end
endmodule
