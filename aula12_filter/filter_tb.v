`timescale 100ns/100ns

module filter_tb;

	reg 	rst, 		clk;
	reg 	[11:0] 	x;
	wire 	[11:0] 	y;
	
	always #5 clk = ~clk;
	
	movavg_filter (
		.rst(rst), .clk(clk),
		.x(x), y(y)
	);
	
	initial begin
		rst = 1;
		#15;
		rst = 0;
		x = 12'b1000 0000 0000;
		#10
		x = 12'd0;
		#50
		$finish;
	end
		
endmodule
		