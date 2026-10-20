// Simulador do portão (completa o esqueleto do gate_counter da aula 6).
//
// A posição do portão é um número de 0 (fechado) a 9 (aberto).
// Com o motor ligado (enable = 1), o portão anda uma posição por borda de
// clock, no sentido indicado por dir. Na aula 7 ele roda no clock de 1 s,
// então leva 9 s para abrir ou fechar por completo.
//
// Os fins de curso avisam a FSM: start_stop em 0 (fechado), end_stop em 9 (aberto).
module gate_counter (
	input rst,
	input clk,				// clock de 1 s
	input enable,			// motor_power
	input dir,				// motor_direction: 1 = abrindo, 0 = fechando
	output start_stop,		// 1 com o portão totalmente fechado
	output end_stop,		// 1 com o portão totalmente aberto
	output reg [9:0] led_bar
);

	reg [3:0] count;		// posição atual (0 a 9)
	reg [3:0] nextCount;

	//Registrador de posição
	always @(posedge clk or posedge rst) begin
		if (rst)
			count <= 4'd0;
		else
			count <= nextCount;
	end

	//Lógica da próxima posição
	always @(*) begin
		nextCount = count;						// por padrão, fica parado
		if (enable) begin
			if (dir == 1'b1 && count != 4'd9)
				nextCount = count + 1'b1;		// abrindo
			else if (dir == 1'b0 && count != 4'd0)
				nextCount = count - 1'b1;		// fechando
		end
	end

	//Lógica de saída
	assign start_stop = (count == 4'd0);
	assign end_stop   = (count == 4'd9);

	// Barra de LEDs: acende até o LED da posição atual
	// (posição 0 = só LEDR0 aceso, posição 9 = os 10 LEDs acesos)
	integer i;
	always @(*) begin
		for (i = 0; i < 10; i = i + 1)
			led_bar[i] = (i <= count);
	end

endmodule
