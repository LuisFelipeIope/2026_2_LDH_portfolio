`define STATE_CLOSED 	2'b00
`define STATE_CLOSING 	2'b01
`define STATE_OPEN 		2'b10
`define STATE_OPENING 	2'b11

`define DIR_OPEN			1'b1
`define DIR_CLOSE			1'b0

module fsm_gate_ctrl(
	input rst,
	input clk,
	// sinais de controle
	input user_button,
	input start_stop,
	input end_stop,
	//saidas
	output reg motor_power,
	output reg motor_direction
);

	reg [1:0] state;
	reg [1:0] next_state;
	
	//motor de estados
	always @(posedge clk) begin
		if (rst) begin
			state <= `STATE_CLOSED;
		end else begin
			state <= next_state;
		end
	end
	
	//logíca de transição
	always @(*) begin
		case(state)
		
			`STATE_CLOSED : begin
				if(user_button == 1'b0) begin
					next_state = `STATE_CLOSED; 
				end else begin
					next_state = `STATE_OPENING;
				end
			end
		
			`STATE_CLOSING : begin
				if(start_stop == 1'b0) begin
					next_state = `STATE_CLOSING; 
				end else begin
					next_state = `STATE_CLOSED;
				end
			end
			
			`STATE_OPEN : begin
				if(user_button == 1'b0) begin
					next_state = `STATE_OPEN; 
				end else begin
					next_state = `STATE_CLOSING;
				end
			end
			
			`STATE_OPENING : begin
				if(end_stop == 1'b0) begin
					next_state = `STATE_OPENING; 
				end else begin
					next_state = `STATE_OPEN;
				end
			end
			
		endcase
	end
	
	//logíca de saída
	always @(*) begin
		case(state)
			
			`STATE_CLOSED : begin
				motor_power = 1'b0;
				motor_direction = `DIR_OPEN;
			end
			
			`STATE_CLOSING : begin
				motor_power = 1'b1;
				motor_direction = `DIR_CLOSE;
			end
			
			`STATE_OPEN : begin
				motor_power = 1'b0;
				motor_direction = `DIR_CLOSE;
			end
			
			`STATE_OPENING : begin
				motor_power = 1'b1;
				motor_direction = `DIR_OPEN;
			end
			
		endcase
	end
	
endmodule 