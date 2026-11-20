//-----------------------------------------------------------------------------
// Title       : Trapezoidal Shaping Filter - Variant 4
// File        : v4_filter.sv
// Description : Implements trapezoidal pulse shaping filter (Formulas B):
//               Parameters: K_V4 = 9, L_V4 = 5, M_V4 = 16
//-----------------------------------------------------------------------------
import package_settings::*;
import package_settings_v_4::*;

module v4_filter (
    input  wire                             clk,         // System clock
    input  wire                             reset,       // Active-low reset (!reset)
    input  wire        [IN_WIDTH_V4-1:0]    input_data,  // 14-bit unsigned ADC input
    output reg  signed [OUT_WIDTH_V4-1:0]   output_data  // 16-bit signed filtered output
);

    localparam DELAY_LEN_V4 = K_V4 + L_V4; // Total delay length: 14 clock cycles

    // Shift register delay line storing input samples v(n-1) ... v(n-k-l)
    reg [IN_WIDTH_V4-1:0] v_delay [1:DELAY_LEN_V4];

    // 32-bit signed accumulators to prevent internal overflow
    reg signed [31:0] p_reg;
    reg signed [31:0] s_reg;

    // Sign-safe extension from unsigned input to 32-bit signed math
    wire signed [31:0] v_curr = $signed({1'b0, input_data});
    wire signed [31:0] v_k    = $signed({1'b0, v_delay[K_V4]});
    wire signed [31:0] v_l    = $signed({1'b0, v_delay[L_V4]});
    wire signed [31:0] v_kl   = $signed({1'b0, v_delay[DELAY_LEN_V4]});

    // Combinational evaluation of trapezoidal filter equations (Formulas B)
    wire signed [31:0] d_n = v_curr - v_k - v_l + v_kl;
    wire signed [31:0] p_n = p_reg + d_n;
    wire signed [31:0] r_n = p_n + (M_V4 * d_n);
    wire signed [31:0] s_n = s_reg + r_n;

    integer i;

    // Sequential stage with asynchronous active-low reset (!reset)
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 1; i <= DELAY_LEN_V4; i = i + 1) begin
                v_delay[i] <= {IN_WIDTH_V4{1'b0}};
            end
            p_reg       <= 32'sd0;
            s_reg       <= 32'sd0;
            output_data <= {OUT_WIDTH_V4{1'b0}};
        end else begin
            // Advance delay pipeline
            v_delay[1] <= input_data;
            for (i = 2; i <= DELAY_LEN_V4; i = i + 1) begin
                v_delay[i] <= v_delay[i-1];
            end

            // Update accumulators
            p_reg       <= p_n;
            s_reg       <= s_n;

            // Output scaled signal (divide by 256: peak ~1673).
            // Note: s_n[19:4] (divide by 16: peak ~26777) can be used for larger scale.
            output_data <= s_n[23:8];
        end
    end

endmodule