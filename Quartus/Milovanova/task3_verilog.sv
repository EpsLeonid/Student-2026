// D flip-flop triggered by the rising edge of clk.
// When clk transitions from 0 to 1, the value of d is copied to out.
// The output out remains unchanged until the next rising edge of clk.

module task3_verilog (
    input  logic d,     // Data input, remember bit,
    input  logic clk,   // Clock signal: on its rising edge
                        // the trigger reads d and writes to out,
    output logic out    // Output: stores the last recorded value of d
                        // until the next rising edge of clk.
);

    // On the rising edge of clk, the value of d is copied to out.
    // The non-blocking assignment <= corresponds to flip-flop behavior.
    always_ff @(posedge clk) begin
        out <= d;
    end

endmodule
