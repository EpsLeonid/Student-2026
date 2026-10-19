module reg_arithmetic_param #(
    parameter WIDTH_A   = 8,
    parameter WIDTH_B   = 8,
    parameter WIDTH_C   = 8,
    parameter WIDTH_OUT = 17 
) (
    input  wire                 clk,
    input  wire [WIDTH_A-1:0]   A,
    input  wire [WIDTH_B-1:0]   B,
    input  wire [WIDTH_C-1:0]   C,
    output reg  [WIDTH_OUT-1:0] DATA_OUT
);

    always @(posedge clk) begin
        DATA_OUT <= (A * B) + C;
    end

endmodule