// v6_filter.sv
//
// Modified cusp-like filter
//
//   dk(n) = v(n) - v(n-k)
//   d1(n) = v(n) - v(n-1)
//   p(n)  = p(n-1) + dk(n) - k * d1(n-l)
//   q(n)  = q(n-1) + m2 * p(n)
//   s(n)  = s(n-1) + q(n) + m1 * p(n)

`timescale 1 ns / 1 ps

import package_settings::*;
import package_settings_v_6::*;

module v6_filter (
    input  wire                            clk,
    input  wire                            reset,
    input  wire signed [SIZE_ADC_DATA-1:0] input_data,
    output logic signed [SIZE_FILTER_DATA-1:0] output_data
);

 
    // Input sample history (delay line):
    //   v_hist[1] = v(n-1), v_hist[2] = v(n-2), ..., v_hist[k] = v(n-k)
    logic signed [31:0] v_hist [1:k_v6];
    
    // Filter state registers 
    logic signed [31:0] p_state = 0;
    logic signed [31:0] q_state = 0;
    logic signed [31:0] s_state = 0;

    // Input difference signals
    wire signed [31:0] dk;    // dk(n)   = v(n)   - v(n-k)
    wire signed [31:0] d1_l;  // d1(n-l) = v(n-l) - v(n-l-1)

    // Combinational next-state values of the accumulators
    wire signed [31:0] p_next;
    wire signed [31:0] q_next;
    wire signed [31:0] s_next;
     
    // dk(n) = v(n) - v(n-k)
    assign dk = $signed(input_data) - $signed(v_hist[k_v6]);

    // d1(n-l) = v(n-l) - v(n-l-1) = v_hist[l] - v_hist[l+1]
    assign d1_l = $signed(v_hist[l_v6]) - $signed(v_hist[l_v6 + 1]);

    // p(n) = p(n-1) + dk(n) - k * d1(n-l)
    assign p_next = p_state + dk - ($signed(k_v6) * d1_l);

    // q(n) = q(n-1) + m2 * p(n)
    assign q_next = q_state + $signed(m2_v6) * p_next;
         
    // s(n) = s(n-1) + q(n) + m1 * p(n)
    assign s_next = s_state + q_next + $signed(m1_v6) * p_next;

     
    // Sequential logic
    always_ff @(posedge clk) begin
        if (!reset) begin
            p_state     <= 0;
            q_state     <= 0;
            s_state     <= 0;
            output_data <= 0;

            for (int i = 1; i <= k_v6; i++) begin
                v_hist[i] <= '0;
            end
        end
        else begin
            // Shift the sample history (v_hist[1] holds the previous sample).
            for (int i = k_v6; i > 1; i--) begin
                v_hist[i] <= v_hist[i-1];
            end
            v_hist[1] <= input_data;

            // Update filter state.
            p_state <= p_next;
            q_state <= q_next;
            s_state <= s_next;

            // Output without saturation: scaled by 2^-8.
            output_data <= s_next >>> 8;
        end
    end

endmodule
