module multiplier (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [15:0] c
);

    assign c = a * b;

endmodule