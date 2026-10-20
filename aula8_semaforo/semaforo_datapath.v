module semaforo_datapath (
    input        clk,
    input        clear,
    //sinais de controle vindo da fsm
    input  [1:0] sel,
    //sinais de controle indo para a fsm
    output       top
);

    wire cnt;
    reg [4:0] sel_time;

    counter u1 (
        .rst(clear),
        .clk(clk),
        .cnt_out(cnt)
    );

    //comparador de match da contagem de tempo com o topo
    assign top = (cnt==sel_time);


    //multiplexador para seleção do tempo
    always @(*) begin
        case(sel)
            0: sel_time = 20;
            1: sel_time = 2;
            2: sel_time = 10;
            default: sel_time = 31;
        endcase
    end

endmodule
