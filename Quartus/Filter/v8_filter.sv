`include "v8_params.vh"
import package_settings::*;

module v8_filter #(
    parameter V8_K_PARAM  = V8_K,
    parameter V8_L_PARAM  = V8_L,
    parameter V8_KL_PARAM = V8_KL,
    parameter V8_M_PARAM  = V8_M
)(
    input  wire                                 clk,
    input  wire                                 reset,
    input  wire signed [SIZE_ADC_DATA-1:0]      input_data,  // v(n) from exp_sig_gen
    output reg  signed [SIZE_FILTER_DATA-1:0]   output_data  // s(n) filtered pulse
);

    // Shift registers for delaying input signal v(n)
    reg signed [SIZE_ADC_DATA-1:0] shift_reg_v8 [1:V8_KL_PARAM];

    // Internal calculation registers
    reg signed [SIZE_FILTER_DATA-1:0] d_v8; // Double difference
    reg signed [SIZE_FILTER_DATA-1:0] p_v8; // 1st accumulator state
    reg signed [SIZE_FILTER_DATA-1:0] r_v8; // Deconvolution signal

    // Taps from the delay pipeline
    wire signed [SIZE_ADC_DATA-1:0] v_n   = input_data;
    wire signed [SIZE_ADC_DATA-1:0] v_nk  = shift_reg_v8[V8_K_PARAM];
    wire signed [SIZE_ADC_DATA-1:0] v_nl  = shift_reg_v8[V8_L_PARAM];
    wire signed [SIZE_ADC_DATA-1:0] v_nkl = shift_reg_v8[V8_KL_PARAM];

    integer i;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 1; i <= V8_KL_PARAM; i = i + 1) begin
                shift_reg_v8[i] <= '0;
            end
            d_v8        <= '0;
            p_v8        <= '0;
            r_v8        <= '0;
            output_data <= '0;
        end else begin
            // Pipeline Shift Register: advance data along delay chain
            shift_reg_v8[1] <= v_n;
            for (i = 2; i <= V8_KL_PARAM; i = i + 1) begin
                shift_reg_v8[i] <= shift_reg_v8[i-1];
            end

            // Double difference calculation
            d_v8 <= v_n - v_nk - v_nl + v_nkl;

            // First digital integrator
            p_v8 <= p_v8 + d_v8;

            // Deconvolution
            r_v8 <= p_v8 + (V8_M_PARAM * d_v8);

            // Second digital integrator
            output_data <= output_data + r_v8;
        end
    end

endmodule