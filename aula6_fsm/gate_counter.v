module gate_counter (
    input rst,
    input clk,
    input enable,
    input dir,
    output start_stop,
    output end_stop,
    output [9:0] led_bar
);

    reg [??] count;
    reg [??] nextCount;

    //Motor de estados
    always @(posedge clk) begin
    end

    //Lógica do próximo estado
    always @(*) begin
		if(count == 4'd9)
		//
	 else if (count == 0)
	   //
	 else 
		if(dir = 1) ...
			nextcount = count + 1;
		else
			next
    end

    //Lógica de saída
    always @(*) begin
    end
	 

endmodule