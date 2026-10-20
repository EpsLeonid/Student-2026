// Task_5_Parameterization_and_Mathematical_Width_Calculation.v
module Task_5_Parameterization_and_Mathematical_Width_Calculation #(
    // Parameters are declared cleanly at the top
    parameter INPUT_WIDTH  = 8,
    parameter OUTPUT_WIDTH = 16 // Set to 16 bits to prevent overflow
)(
    input  wire                    clk,      // 200 MHz clock input
    input  wire [INPUT_WIDTH-1:0]  A,        // 8-bit input A
    input  wire [INPUT_WIDTH-1:0]  B,        // 8-bit input B
    input  wire [INPUT_WIDTH-1:0]  C,        // 8-bit input C
    output reg  [OUTPUT_WIDTH-1:0] DATA_OUT  // 16-bit registered output
);

    // Sequential logic block triggered on the rising edge of the clock
    // Classic Verilog syntax for a flip-flop/register
    always @(posedge clk) begin
        DATA_OUT <= (A * B) + C;
    end

endmodule