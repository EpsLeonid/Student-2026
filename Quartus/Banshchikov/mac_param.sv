module mac_param #(
    parameter IN_WIDTH  = 8,                          // Ўирина входных шин (по умолчанию 8)
    parameter OUT_WIDTH = (2 * IN_WIDTH) + 1          // Ўирина выходной шины дл€ предотвращени€ переполнени€ (17 бит)
)(
    input  logic                  clk,
    input  logic [IN_WIDTH-1:0]   a,
    input  logic [IN_WIDTH-1:0]   b,
    input  logic [IN_WIDTH-1:0]   c,
    output logic [OUT_WIDTH-1:0]  data_out
);

    always_ff @(posedge clk) begin
        // ”множение и сложение с сохранением в регистр по тактовому сигналу
        data_out <= (a * b) + c;
    end

endmodule