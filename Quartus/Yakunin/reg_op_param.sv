
// module Name: reg_op_param
// description: parameterized MAC unit with external parameter header inclusion
// clock Rate:  200 MHz (Clock period = 5.0 ns)


// inclusion of the external parameter definition file
`include "params.vh"

module reg_op_param #(
    parameter DATA_IN_W  = IN_WIDTH,   // defaults to 8 from params.vh
    parameter DATA_OUT_W = OUT_WIDTH   // defaults to 16 from params.vh
)(
    input  logic                   clk,      // 200 MHz clock
    input  logic [DATA_IN_W-1:0]  a,        // input operand A
    input  logic [DATA_IN_W-1:0]  b,        // input operand B
    input  logic [DATA_IN_W-1:0]  c,        // input operand C
    output logic [DATA_OUT_W-1:0] data_out  // output register [15:0] (no overflow)
);

    // sequential process triggered on rising clock edge
    always_ff @(posedge clk) begin
        data_out <= (a * b) + c;
    end

endmodule