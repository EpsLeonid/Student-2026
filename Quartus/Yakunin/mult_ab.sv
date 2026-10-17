// module name: mult_ab
// implements 1-bit multiplication: c = a * b (equivalent to AND gate)
module mult_ab (
    input  logic a,  // 1-bit input a
    input  logic b,  // 1-bit input b
    output logic c   // 1-bit output c
);

    assign c = a * b;

endmodule