// module name: reg_op
// implements an 8-bit registered unit: DATA_OUT <= A*B + C
// designed to operate synchronously at 200 MHz (clock period = 5 ns)
module reg_op (
    input  logic       clk,       // 200 MHz clock input
    input  logic [7:0] a,         // 8-bit input operand A
    input  logic [7:0] b,         // 8-bit input operand B
    input  logic [7:0] c,         // 8-bit input operand C
    output logic [7:0] data_out   // 8-bit registered output 
);

    // synchronous process triggered on the rising edge of the 200 MHz clock
    always_ff @(posedge clk) begin
        // perform multiplication and addition; the result is assigned to the 8-bit register
        data_out <= (a * b) + c;
    end

// end of module declaration
endmodule