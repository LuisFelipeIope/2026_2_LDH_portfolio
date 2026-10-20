// Portão eletrônico com fechamento automático (aula 7) - núcleo do projeto.
//
// Recebe os dois clocks já prontos (1 ms e 1 s). Assim ele pode ser
// simulado direto no testbench, com os clocks gerados por dois always,
// sem precisar simular milhões de ciclos de 50 MHz no divisor.
// Na placa, quem gera os clocks é o DE10_LITE_Golden_Top (com clk_div).
//
//   botão --> edge_detector --> fsm_gate_ctrl --> motor --> gate_counter
//              (1 ms)              (1 ms)  ^  |              (1 s)
//                                          |  | gate_open      |
//                                  timeout |  v                | start_stop
//                                        gate_timer            | end_stop
//                                          (1 s)               v
//                                                         volta p/ FSM
module portao (
	input rst,
	input clk_1ms,
	input clk_1s,
	input button,				// botão em lógica positiva (1 = apertado)
	output [9:0] led_bar,		// posição do portão nos LEDs
	output [2:0] timer_count,	// segundos contados com o portão aberto
	output motor_power,
	output motor_direction,
	output gate_open
);

	wire btn_pulse;		// pulso de 1 ms a cada aperto do botão
	wire start_stop;	// fim de curso fechado
	wire end_stop;		// fim de curso aberto
	wire timeout;		// passaram 5 s com o portão aberto

	edge_detector u_edge (
		.rst(rst),
		.clk(clk_1ms),
		.in(button),
		.pulse(btn_pulse)
	);

	fsm_gate_ctrl u_fsm (
		.rst(rst),
		.clk(clk_1ms),
		.user_button(btn_pulse),
		.start_stop(start_stop),
		.end_stop(end_stop),
		.timeout(timeout),
		.motor_power(motor_power),
		.motor_direction(motor_direction),
		.gate_open(gate_open)
	);

	gate_timer u_timer (
		.rst(rst),
		.clk(clk_1s),
		.gate_open(gate_open),
		.timeout(timeout),
		.count(timer_count)
	);

	gate_counter u_gate (
		.rst(rst),
		.clk(clk_1s),
		.enable(motor_power),
		.dir(motor_direction),
		.start_stop(start_stop),
		.end_stop(end_stop),
		.led_bar(led_bar)
	);

endmodule
