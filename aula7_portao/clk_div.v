// Divisor de clock parametrizável (evolução do clk_1s da aula 5).
//
// O clock de saída inverte a cada N ciclos do clock de entrada,
// então o período de saída é 2*N ciclos de entrada:
//   50 MHz -> 1 ms (1 kHz) : N = 25_000
//   50 MHz -> 1 s  (1 Hz)  : N = 25_000_000
//
// Correção em relação à aula 5: lá o contador nunca era zerado. Ele passava
// de 25.000.000 e ia até estourar em 2^25 = 33.554.432, então o clk_1s
// na verdade tinha período de ~1,34 s. Aqui o contador ZERA ao chegar em N-1.
//
// Reset assíncrono: o rst age na hora, sem depender de borda do clock.
module clk_div #(
	parameter N = 25000000		// ciclos de entrada por meio período de saída
)(
	input rst,
	input clk_in,
	output reg clk_out
);

	localparam W = $clog2(N+1);	// bits suficientes para contar até N-1

	reg [W-1:0] count;

	always @(posedge clk_in or posedge rst) begin
		if (rst) begin
			count   <= 0;
			clk_out <= 0;
		end else if (count == N-1) begin
			count   <= 0;			// zera a contagem ao atingir o valor desejado
			clk_out <= ~clk_out;	// e inverte o clock de saída
		end else begin
			count <= count + 1'b1;
		end
	end

endmodule
