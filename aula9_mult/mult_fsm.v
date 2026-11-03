`define STATE_IDLE	2'b00
`define STATE_OP 		2'b01
`define STATE_DONE	2'b10

module mult_fsm (
	input rst,
	input clk,
	//Sinais de estado (vindo do datapath)
	input zero,
	//Sinais de entrada (do usuário)
	input start,
	//Sinais de controle (indo para o datapath)
	output load,
	output clear,
	//Sinais de saída (para o usuário)
	output done
);

	reg [1:0] state;
	reg [1:0] nextState;

	//Motor de estados
	always @(posedge clk) begin
		if(rst)
			state <= `STATE_IDLE;
		else
			state <= nextState;
	end
	
	//Lógica do próximo estado
	always @(*) begin
	end
	
	//Sinais de saída
	
endmodule
