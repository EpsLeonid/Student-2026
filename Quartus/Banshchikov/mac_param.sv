`include "params.v"

module mac_param #(
    parameter W = IN_WIDTH,
    parameter OW = OUT_WIDTH
) (
    input  logic                  clk,
    input  logic [IN_WIDTH-1:0]   a,
    input  logic [IN_WIDTH-1:0]   b,
    input  logic [IN_WIDTH-1:0]   c,
    output logic [OUT_WIDTH-1:0]  data_out
);

    always_ff @(posedge clk) begin
        // Умножение и сложение с сохранением в регистр по тактовому сигналу
        data_out <= (a * b) + c;
    end

endmodule