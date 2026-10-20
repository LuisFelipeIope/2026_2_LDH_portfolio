`timescale 1ms/1us

// Testbench do portão com fechamento automático (aula 7).
//
// Os dois clocks são gerados direto aqui, com dois always de períodos
// diferentes (1 ms e 1 s), sem o divisor de 50 MHz. Com o timescale em ms,
// o tempo da simulação é o tempo real: #1000 = 1 s.
//
// Cenário 1: abre, fica aberto e fecha SOZINHO depois de 5 s.
// Cenário 2: abre e alguém aperta o botão antes dos 5 s (fecha na hora),
//            para conferir que o botão continua funcionando e que o
//            contador zera quando o portão sai de ABERTO.
module tb_portao;

	reg		rst;
	reg		clk_1ms;
	reg		clk_1s;
	reg		button;
	wire	[9:0] led_bar;
	wire	[2:0] timer_count;
	wire	motor_power;
	wire	motor_direction;
	wire	gate_open;

	portao dut (
		.rst(rst),
		.clk_1ms(clk_1ms),
		.clk_1s(clk_1s),
		.button(button),
		.led_bar(led_bar),
		.timer_count(timer_count),
		.motor_power(motor_power),
		.motor_direction(motor_direction),
		.gate_open(gate_open)
	);

	always #0.5 clk_1ms = ~clk_1ms;	// período de 1 ms
	always #500 clk_1s  = ~clk_1s;	// período de 1 s

	// Aperta o botão por 200 ms (bem mais que 1 ciclo de clk_1ms,
	// para mostrar que o detector de borda gera um pulso só)
	task apertar_botao;
		begin
			button = 1;
			#200;
			button = 0;
		end
	endtask

	// Mostra no console cada mudança de estado, com o tempo em segundos
	always @(motor_power or motor_direction or gate_open) begin
		if (motor_power && motor_direction)
			$display("t = %6.3f s -> ABRINDO", $realtime/1000.0);
		else if (motor_power)
			$display("t = %6.3f s -> FECHANDO", $realtime/1000.0);
		else if (gate_open)
			$display("t = %6.3f s -> ABERTO", $realtime/1000.0);
		else
			$display("t = %6.3f s -> FECHADO", $realtime/1000.0);
	end

	real t_aberto;	// instante em que o portão chegou em ABERTO

	initial begin
		clk_1ms = 0;
		clk_1s  = 0;
		button  = 0;
		rst     = 1;
		#10
		rst = 0;

		// ---------- Cenário 1: fecha sozinho ----------
		#990 apertar_botao;				// t = 1 s: aperta o botão
		@(posedge gate_open);			// espera abrir (9 posições = 9 s)
		t_aberto = $realtime;
		@(negedge gate_open);			// ninguém aperta nada...
		$display("   ficou aberto por %0.3f s (esperado: 5 s)", ($realtime - t_aberto)/1000.0);
		@(negedge motor_power);			// espera terminar de fechar
		#2000;

		// ---------- Cenário 2: botão antes dos 5 s ----------
		apertar_botao;					// abre de novo
		@(posedge gate_open);
		#2300 apertar_botao;			// aperta com ~2 s de portão aberto
		@(negedge motor_power);			// espera terminar de fechar
		#2000;

		$display("Fim da simulação: t = %0.3f s", $realtime/1000.0);
		$stop;	// $stop pausa o ModelSim sem fechar a janela de ondas
	end

endmodule
