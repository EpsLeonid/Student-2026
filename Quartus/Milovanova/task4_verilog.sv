// 8-bit edge-clocked register clk.
// At the moment of the edge, the following is executed: DATA_OUT <= A * B + C.
// A, B, C are 8-bit inputs, DATA_OUT are the lower 8 bits of the sum.
// A * B is counted in the 16-bit product signal so that the higher ones
// bits of the product are not lost before adding with C.

module task4_verilog (
    input  logic clk,             // Clock signal, 200 MHz (5 ns)
    input  logic [7:0] A,         // A,
    input  logic [7:0] B,         // B,
    input  logic [7:0] C,         // C,
    output logic [7:0] DATA_OUT   // Result
);

    // Product A*B: the result of multiplying two 8-bit numbers
    // takes up to 16 bits, so the product must be 16-bit. 
    // If it were made 8-bit, the high-order bits would be lost.
    logic [15:0] product;

    // Multiplication is performed combinatorially (without a clock signal)
    assign product = A * B;

    // On the rising edge of clk, the lower 8 bits of the sum
    // product + C are written to DATA_OUT.
    always_ff @(posedge clk) begin
        DATA_OUT <= product + C;
    end

endmodule
