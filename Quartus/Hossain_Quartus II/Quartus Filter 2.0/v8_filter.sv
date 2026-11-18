//-----------------------------------------------------------------------------
// Title       : Triangular Shaping Filter - Variant 8
// File        : v8_filter.sv
// Author      : Yakunin Arseniy
// Description : Hardware implementation of triangular shaping filter (Variant 8):
//               k = V8_K (7), l = V8_L (7), M = V8_M (16)
//-----------------------------------------------------------------------------
import package_settings::*;
import package_settings_v_8::*;

module v8_filter (
    input  wire                        clk,            // Main system clock driver
    input  wire                        reset,          // Asynchronous active-low reset (!reset)
    input  wire [SIZE_ADC_DATA-1:0]    input_data,     // Raw unsigned data sample stream from ADC
    output wire [SIZE_FILTER_DATA-1:0] output_data     // Processed 16-bit filter output stream
);

    // Shift register array pipeline tracking historical input samples (k + l = 14)
    logic [SIZE_ADC_DATA-1:0] v_delay_v8 [0:(V8_K + V8_L)-1];
    integer i;

    // Internal integration accumulators (24-bit signed prevents overflow)
    logic signed [23:0] p_reg_v8;
    logic signed [23:0] s_reg_v8;

    // Combinational nets for single-cycle intermediate math evaluations
    logic signed [23:0] d_v8;
    logic signed [23:0] p_next_v8;
    logic signed [23:0] r_v8;

    // Step 1: Double finite difference d(n) = v(n) - v(n-k) - v(n-l) + v(n-k-l)
    assign d_v8 = $signed({1'b0, input_data})
                - $signed({1'b0, v_delay_v8[V8_K - 1]})
                - $signed({1'b0, v_delay_v8[V8_L - 1]})
                + $signed({1'b0, v_delay_v8[V8_K + V8_L - 1]});

    // Step 2: First digital integrator p(n) = p(n-1) + d(n)
    assign p_next_v8 = p_reg_v8 + d_v8;

    // Step 3: Deconvolution / decay compensation r(n) = p(n) + M * d(n)
    assign r_v8 = p_next_v8 + 24'(V8_M * d_v8);

    // Sequential Registers Stage (active-low reset)
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            p_reg_v8 <= 24'sd0;
            s_reg_v8 <= 24'sd0;
            for (i = 0; i < (V8_K + V8_L); i = i + 1) begin
                v_delay_v8[i] <= {SIZE_ADC_DATA{1'b0}};
            end
        end else begin
            // Shift delay pipeline
            v_delay_v8[0] <= input_data;
            for (i = 1; i < (V8_K + V8_L); i = i + 1) begin
                v_delay_v8[i] <= v_delay_v8[i-1];
            end

            // Update integrators
            p_reg_v8 <= p_next_v8;
            s_reg_v8 <= s_reg_v8 + r_v8;
        end
    end

    // Step 4: Output scaled final accumulator value to 16-bit bus (divide by 16)
    assign output_data = s_reg_v8[23:8];

endmodule