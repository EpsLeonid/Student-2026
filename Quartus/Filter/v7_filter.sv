// Module: v7_filter
// Description: Implements a Trapezoidal response profile based on Formula Set B.
// Core logic executes a difference equation followed by dual integrations.

import package_settings::*;
import package_settings_v_7::*;

module v7_filter (
    input  wire clk,                                   // Main system clock driver
    input  wire reset,                                 // Asynchronous reset line
    input  wire [SIZE_ADC_DATA-1:0] input_data,        // Raw data sample stream from ADC
    output wire [SIZE_FILTER_DATA-1:0] output_data     // Processed filter output stream
);

    // Shift register array pipeline tracking historical input samples
    // Allocation boundary spans the combined delay elements: (K7 + L7) entries
    logic [SIZE_ADC_DATA-1:0] v_delay [0:(K7+L7)-1];
    integer i;

    // Internal 24-bit integration accumulators to prevent overflow
    logic signed [23:0] p_reg;
    logic signed [23:0] s_reg;

    // 24-bit combinational nets for single-cycle intermediate math evaluations
    logic signed [23:0] d;
    logic signed [23:0] r;

    // Combinational Logic Stage:
    // Derives the primary finite difference value 'd' using tapped history nodes.
    // Prepending 1'b0 ensures unsigned ADC data is safely treated as positive before $signed().
    assign d = $signed({1'b0, input_data}) 
             - $signed({1'b0, v_delay[K7-1]}) 
             - $signed({1'b0, v_delay[L7-1]}) 
             + $signed({1'b0, v_delay[K7+L7-1]});

    // Scales the finite difference value alongside the accumulator status
    assign r = p_reg + (M7 + 1) * d;

    // Sequential Registers Stage:
    // Handles memory updates, pipeline shifts, and accumulation loops
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Hardware state initialization on system reset
            p_reg <= '0;
            s_reg <= '0;
            for (i = 0; i < (K7+L7); i = i + 1) begin
                v_delay[i] <= '0;
            end
        end else begin
            // Shift history array window rightward and inject incoming data sample
            v_delay[0] <= input_data;
            for (i = 1; i < (K7+L7); i = i + 1) begin
                v_delay[i] <= v_delay[i-1];
            end

            // Dual stage numeric integration updates
            p_reg <= p_reg + d;
            s_reg <= s_reg + r;
        end
    end

    // Extract the upper 16 bits ([23:8]) of the 24-bit accumulator to scale and prevent overflow
    assign output_data = s_reg[23:8];

endmodule
