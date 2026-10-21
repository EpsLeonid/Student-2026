// task_5_parameterized_register.sv - Parameterized register module
`include "task_5_params.sv"

module task_5_parameterized_register #(
    parameter int IN_W  = INPUT_WIDTH,
    parameter int OUT_W = OUTPUT_WIDTH
)(
    input  logic              clk,      // Clock signal (200 MHz)
    input  logic [IN_W-1:0]   A,        // Input signal A
    input  logic [IN_W-1:0]   B,        // Input signal B
    input  logic [IN_W-1:0]   C,        // Input signal C
    output logic [OUT_W-1:0]  DATA_OUT  // Output register with no overflow
);

    // Synchronous block executing at the 200 MHz clock frequency
    always_ff @(posedge clk) begin
        DATA_OUT <= (A * B) + C;
    end

endmodule
