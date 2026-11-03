module seq_mult (
	input rst,
	input clk,
	
	input		[3:0] a,
	input		[3:0] b,
	output 	[7:0] m
);

	mult_fsm fsm (
		.rst(rst),
		.clk(clk),
		//Sinais de controle
	);
	
	mult_datapath dp (
		//Dados
		.a(),
		.b(),
		.m(),
		//Sinais de controle
	);

endmodule
