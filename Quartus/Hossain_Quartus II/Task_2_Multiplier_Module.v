
// Module: Task_2_Multiplier_Module
// Description: Multiplies two 8-bit inputs and outputs a 16-bit product.

module Task_2_Multiplier_Module (
    input  [7:0]  A,  // 8-bit input operand A (no 'logic' keyword)
    input  [7:0]  B,  // 8-bit input operand B
    output [15:0] C   // 16-bit output result
);

    // Continuous assignment for combinational multiplication
    assign C = A * B;

endmodule
 