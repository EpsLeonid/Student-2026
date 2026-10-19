module reg_arithmetic (
    input  wire       clk,
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [7:0] C,
    output reg  [16:0] DATA_OUT
);

    always @(posedge clk) begin
        DATA_OUT <= (A * B) + C;
    end

endmodule