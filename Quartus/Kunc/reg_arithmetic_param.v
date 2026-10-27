`include "params.vh"

module reg_arithmetic_param (
    input clk,
    input [`WIDTH-1:0] A,
    input [`WIDTH-1:0] B,
    input [`WIDTH-1:0] C,
    output reg [`OUT_WIDTH-1:0] DATA_OUT
);

    always @(posedge clk) begin
        DATA_OUT <= (A * B) + C;
    end

endmodule