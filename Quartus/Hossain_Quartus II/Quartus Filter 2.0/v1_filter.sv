// Module: v1_filter
// Description: Implements a Triangular/Trapezoidal response profile (Variant 1).
// Core logic executes a difference equation followed by dual integrations.

import package_settings::*;
import package_settings_v_1::*;

module v1_filter (
    input  wire                        clk,            // Main system clock driver
    input  wire                        reset,          // Asynchronous active-low reset
    input  wire [SIZE_ADC_DATA-1:0]    input_data,     // Raw data sample stream from ADC
    output wire [SIZE_FILTER_DATA-1:0] output_data     // Processed filter output stream
);

    // Shift register array pipeline tracking historical input samples
    logic [SIZE_ADC_DATA-1:0] v_delay [0:(K+L)-1];
    integer i;

    // Internal integration accumulators (24-bit signed prevents overflow)
    logic signed [23:0] p_reg;
    logic signed [23:0] s_reg;

    // Combinational nets for single-cycle intermediate math evaluations
    logic signed [23:0] d;
    logic signed [23:0] p_next;
    logic signed [23:0] r;

    // Step 1: Double finite difference d(n) = v(n) - v(n-K) - v(n-L) + v(n-K-L)
    assign d = $signed({1'b0, input_data})
             - $signed({1'b0, v_delay[K-1]})
             - $signed({1'b0, v_delay[L-1]})
             + $signed({1'b0, v_delay[K+L-1]});

    // Step 2: Updated accumulator p(n) = p(n-1) + d(n)
    assign p_next = p_reg + d;

    // Step 3: Scales the finite difference value alongside current p(n)
    // (Set M = 0 or replace with `assign r = p_next;` if pole-zero cancellation is unused in v1)
    assign r = p_next + 24'(M * d);

    // Sequential Registers Stage
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            p_reg <= 24'sd0;
            s_reg <= 24'sd0;
            for (i = 0; i < (K+L); i = i + 1) begin
                v_delay[i] <= {SIZE_ADC_DATA{1'b0}};
            end
        end else begin
            // Shift history array window rightward and inject incoming data sample
            v_delay[0] <= input_data;
            for (i = 1; i < (K+L); i = i + 1) begin
                v_delay[i] <= v_delay[i-1];
            end

            // Dual stage numeric integration updates
            p_reg <= p_next;
            s_reg <= s_reg + r;
        end
    end

    // Assign scaled final accumulator value to 16-bit output bus (divide by 256)
    assign output_data = s_reg[23:8];

endmodule
