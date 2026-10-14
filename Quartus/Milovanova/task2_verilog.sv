// A and B are single-bit input signals.
// C is a single-bit output signal.
// When A and B are 1 bit in size, the product A*B is also 1 bit.

module task2_verilog (
    input  logic A,   // A,
    input  logic B,   // B
    output logic C    // A * B, 1 bit.
);

    // Continuous assignment: C is recalculated when A or B changes.
    assign C = A * B;

endmodule
