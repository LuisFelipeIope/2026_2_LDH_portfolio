// Temporizador do fechamento automático (aula 7).
//
// Roda no clock de 1 s. Conta um por segundo enquanto o portão está ABERTO
// (gate_open = 1) e avisa a FSM (timeout = 1) quando chega em 5.
//
// Quando o portão sai de ABERTO (gate_open = 0), a contagem volta para zero,
// para que a próxima abertura comece a contar do zero de novo.
module gate_timer (
	input rst,
	input clk,				// clock de 1 s
	input gate_open,		// vem da FSM: 1 enquanto o estado é ABERTO
	output timeout,			// vai para a FSM: 1 quando passaram 5 s
	output reg [2:0] count	// segundos contados (0 a 5)
);

	localparam LIMIT = 3'd5;	// tempo de espera em segundos

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			count <= 3'd0;
		end else if (!gate_open) begin
			count <= 3'd0;				// portão não está aberto: zera
		end else if (count != LIMIT) begin
			count <= count + 1'b1;		// aberto: conta mais um segundo
		end
		// ao chegar em LIMIT, para de contar e espera a FSM fechar
	end

	// O "&& gate_open" derruba o timeout na mesma hora em que a FSM sai de
	// ABERTO, sem esperar a próxima borda do clock de 1 s zerar o contador.
	assign timeout = gate_open && (count == LIMIT);

endmodule
