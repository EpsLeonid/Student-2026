module d_ff (
    input  logic clk,
    input  logic d,
    output logic out
);

    always_ff @(posedge clk) begin
        out <= d;
    end

endmodule