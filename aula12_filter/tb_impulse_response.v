`timescale 100ns/100ns

module tb_impulse_response;

	reg 	rst, 		clk;
	reg 	[11:0] 	x;
	wire 	[11:0] 	y;
	
	always #5 clk = ~clk;
	
	movavg_filter dut (
		.rst(rst), .clk(clk),
		.x(x), .y(y)
	);
	
	initial begin
		clk = 0;
		rst = 1;
		#10;
		rst = 0;
		x = 12'b100000000000;
		#10;
		x = 12'd0;
		#100;
		$finish;
	end
		
endmodule
