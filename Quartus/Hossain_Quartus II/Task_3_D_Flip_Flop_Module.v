
// Module: Task_3_D_Flip_Flop_Module
// Description: Corrected standard Verilog code for a D Flip-Flop.

module Task_3_D_Flip_Flop_Module (
    input  clk,  // Clock input
    input  d,    // Data input
    output reg out   // Registered output (declared as 'reg' for the procedural block)
);

    // This block executes strictly on the rising edge of the clock signal
    always @(posedge clk) begin
        out <= d;    // Non-blocking assignment for sequential logic
    end

endmodule
