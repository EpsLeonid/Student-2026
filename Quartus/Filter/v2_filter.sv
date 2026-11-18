// Module: v2_filter
// Description: Implements a Triangular/Trapezoidal response profile (Variant 2).
// Core logic executes a difference equation followed by dual integrations.

import package_settings::*;
import package_settings_v_2::*;

module v2_filter (
    input  wire                        clk,            // Main system clock driver
    input  wire                        reset,          // Asynchronous reset line
    input  wire [SIZE_ADC_DATA-1:0]    input_data,     // Raw data sample stream from ADC
    output wire [SIZE_FILTER_DATA-1:0] output_data     // Processed filter output stream
);

    // Shift register array pipeline tracking historical input samples
    logic [SIZE_ADC_DATA-1:0] v_delay [0:(k2+l2)-1];
    integer i;

    // Internal integration accumulators (24-bit signed prevents overflow)
    logic signed [23:0] p_reg;
    logic signed [23:0] s_reg;

    // Combinational nets for single-cycle intermediate math evaluations
    logic signed [23:0] d;
    logic signed [23:0] p_next;
    logic signed [23:0] r;

    // Combinational Logic Stage:
    // Derives the primary finite difference value 'd' using tapped history nodes
    assign d = $signed({1'b0, input_data}) - $signed({1'b0, v_delay[k2-1]}) - $signed({1'b0, v_delay[l2-1]}) + $signed({1'b0, v_delay[k2+l2-1]});

    // 1. Updated accumulator p(n) = p(n-1) + d(n)
    assign p_next = p_reg + d;

    // 2. Scales the finite difference value alongside current p(n) (m2 == M)
    assign r = p_next + 24'(m2 * d);

    // Sequential Registers Stage:
    // Handles memory updates, pipeline shifts, and accumulation loops
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Hardware state initialization on system reset
            p_reg <= 24'sd0;
            s_reg <= 24'sd0;
            for (i = 0; i < (k2+l2); i = i + 1) begin
                v_delay[i] <= {SIZE_ADC_DATA{1'b0}};
            end
        end else begin
            // Shift history array window rightward and inject incoming data sample
            v_delay[0] <= input_data;
            for (i = 1; i < (k2+l2); i = i + 1) begin
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
