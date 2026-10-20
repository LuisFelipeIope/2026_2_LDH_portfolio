// Detector de borda de subida do botão.
//
// Gera um pulso de exatamente 1 ciclo de clk quando o botão passa de
// solto (0) para apertado (1). Assim, segurar o botão conta como UM aperto
// só, e a FSM não pula dois estados de uma vez.
//
// Na aula 7 ele roda no clock de 1 ms. Amostrar o botão devagar também
// ajuda a ignorar boa parte do bounce mecânico da tecla.
module edge_detector (
	input rst,
	input clk,
	input in,		// botão em lógica positiva (1 = apertado)
	output pulse	// 1 durante um ciclo de clk na borda de subida
);

	reg in_sync;	// amostra atual do botão (sincronizada com clk)
	reg in_prev;	// amostra do ciclo anterior

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			in_sync <= 1'b0;
			in_prev <= 1'b0;
		end else begin
			in_sync <= in;
			in_prev <= in_sync;
		end
	end

	// agora apertado E antes solto = borda de subida
	assign pulse = in_sync & ~in_prev;

endmodule
