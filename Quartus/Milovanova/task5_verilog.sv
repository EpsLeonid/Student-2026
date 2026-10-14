// The bit widths of A, B, C, and DATA_OUT are derived from the task5_params.vh file,
// so changing WIDTH updates all buses simultaneously.
// DATA_OUT has a width of 2*WIDTH because the product of two WIDTH-bit
// numbers requires up to 2*WIDTH bits, and adding C does not exceed this
// limit, so no overflow occurs.

module task5_verilog (
    input  logic clk,                        // Clock signal,
    input  logic [WIDTH-1:0]     A,          // A,
    input  logic [WIDTH-1:0]     B,          // B,
    input  logic [WIDTH-1:0]     C,          // C,
    output logic [OUT_WIDTH-1:0] DATA_OUT    // Result: A*B + C.
);

    `include "task5_params.vh"

    // Product A*B: width PROD_WIDTH = 2*WIDTH, so that
    // the multiplication result is not truncated. For WIDTH=8, this is 16 bits.
    logic [PROD_WIDTH-1:0] product;

    // assign — combinational logic: product is recalculated
    // immediately upon a change in A or B, without a clock signal.
    assign product = A * B;

    // On the rising edge of clk, the operation DATA_OUT <= product + C is performed.
    // The most significant bits of the sum are discarded, and only the least significant bits
    // are assigned to DATA_OUT, because DATA_OUT has a width of 2*WIDTH, whereas
    // the sum product + C may require more bits.
    always_ff @(posedge clk) begin
        DATA_OUT <= product + C;
    end

endmodule