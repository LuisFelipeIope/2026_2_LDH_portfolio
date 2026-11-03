module mult_datapath (
	input clk,
	input [3:0] a,
	input [3:0] b,
	output [7:0] m,
	//Sinais de controle
	input load,
	input clear,
	//Sinais de estado
	output zero
);

	reg [7:0] acc;
	reg [3:0] reg_a;
	reg [3:0] reg_b;
	
	wire [3:0] shift_a;
	wire [3:0] shift_b;
	
	wire [3:0] sel_a;
	wire [3:0] sel_b;
	wire [7:0] s_out;
	wire acc_enable;
	
	ripple_carry_adder #(.BITS(7)) adder (
		.a(),
		.b(),
		.s(s_out)
	);	

	//Lógica do acumulador
	always @(posedge clk) begin
        if (clear) begin
            acc <= 0;
        end else begin
            if (acc_enable) begin
                acc <= s_out;
            end
        end
    end

endmodule
