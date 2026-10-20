`define STATE_CLOSED 	2'b00
`define STATE_CLOSING 	2'b01
`define STATE_OPEN 		2'b10
`define STATE_OPENING 	2'b11

// FSM do portão eletrônico (aula 6) com fechamento automático (aula 7).
//
// Mudanças da aula 7:
//   - entrada  timeout  : vem do gate_timer, indica que passaram 5 s em ABERTO
//   - saída    gate_open: avisa o gate_timer que o portão está ABERTO
//   - ABERTO -> FECHANDO agora acontece com o botão OU com o timeout
//   - reset passou a ser assíncrono, porque o clock de 1 ms vem do divisor,
//     que fica parado durante o reset (um reset síncrono nunca veria borda)
module fsm_gate_ctrl(
	input rst,
	input clk,				// clock de 1 ms
	//Sinais de controle
	input user_button,		// pulso do detector de borda
	input start_stop,		// fim de curso: portão totalmente fechado
	input end_stop,			// fim de curso: portão totalmente aberto
	input timeout,			// AULA 7: passaram 5 s com o portão aberto
	//Saídas
	output reg motor_power,
	output reg motor_direction,
	output reg gate_open	// AULA 7: 1 enquanto o estado é ABERTO
);

	reg [1:0] state;
	reg [1:0] nextState;

	//Motor de estados
	always @(posedge clk or posedge rst) begin
		if(rst) begin //reset assíncrono
			state <= `STATE_CLOSED;
		end else begin
			state <= nextState;
		end
	end

	//Lógica de transição
	always @(*) begin
		case(state)
			`STATE_CLOSED: begin
				if (user_button == 1'b0) begin
					nextState = `STATE_CLOSED;
				end else begin
					nextState = `STATE_OPENING;
				end
			end
			`STATE_OPENING: begin
				if (end_stop == 1'b0) begin
					nextState = `STATE_OPENING;
				end else begin
					nextState = `STATE_OPEN;
				end
			end
			`STATE_OPEN: begin
				// AULA 7: fecha se apertarem o botão OU se o tempo acabar
				if (user_button == 1'b0 && timeout == 1'b0) begin
					nextState = `STATE_OPEN;
				end else begin
					nextState = `STATE_CLOSING;
				end
			end
			`STATE_CLOSING: begin
				if (start_stop == 1'b0) begin
					nextState = `STATE_CLOSING;
				end else begin
					nextState = `STATE_CLOSED;
				end
			end
			default: begin
				nextState = `STATE_CLOSED;
			end
		endcase
	end

	//Lógica de saída (Moore: depende só do estado)
	always @(*) begin
		case(state)
			`STATE_OPENING: begin
				motor_power     = 1;
				motor_direction = 1;
				gate_open       = 0;
			end
			`STATE_CLOSING: begin
				motor_power     = 1;
				motor_direction = 0;
				gate_open       = 0;
			end
			`STATE_OPEN: begin
				motor_power     = 0;
				motor_direction = 0;
				gate_open       = 1;	// AULA 7: libera o contador de 5 s
			end
			default: begin
				motor_power     = 0;
				motor_direction = 0;
				gate_open       = 0;
			end
		endcase
	end

endmodule
