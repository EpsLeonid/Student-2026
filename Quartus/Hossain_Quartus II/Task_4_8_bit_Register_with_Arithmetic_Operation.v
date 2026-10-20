// Module: Task_4_8_bit_Register_with_Arithmetic_Operation
// Description: Unsigned 8-bit synchronous register performing DATA_OUT = A * B + C.
//              The module name matches your Quartus project settings exactly.

module Task_4_8_bit_Register_with_Arithmetic_Operation (
    input            clk,       // 200 MHz clock signal input
    input      [7:0] A,         // 8-bit input operand A
    input      [7:0] B,         // 8-bit input operand B
    input      [7:0] C,         // 8-bit input operand C
    output reg [7:0] DATA_OUT   // 8-bit registered output
);

    // Dynamic execution on the rising edge of the clock signal
    always @(posedge clk) begin
        DATA_OUT <= (A * B) + C; // Perform the required calculation
    end

endmodule
