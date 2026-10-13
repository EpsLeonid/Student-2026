// module name: mult_ab
module mult_ab (
	// input:
	// logic is data type (replaces wire/reg)
	// [7:0] defines an 8-bit bus (values range from 0 to 255)
	
    input  logic [7:0]  a, // first operand
    input  logic [7:0]  b, // second operand 

	// output port:
	// [15:0] defines a 16-bit bus, which is required to prevent overflow
	// when multiplying two 8-bit unsigned numbers (max: 255 * 255 = 65025 < 65536)
    output logic [15:0] c // product output: C = A * B
);
	// assign - Ccntinuous assignment statement
	// whenever an input 'a' or 'b' changes, output 'c' updates asynchronously, without waiting for a clock edge
    assign c = a * b;
// end of module declaration
endmodule