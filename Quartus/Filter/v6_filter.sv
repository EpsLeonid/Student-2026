// Modified cusp-like recursive filter
//
// Implements the recursive finite-length cusp-like pulse shaper:
//   dk(n) = v(n) - v(n-k)
//   d1(n) = v(n) - v(n-1)
//   p(n)  = p(n-1) + dk(n) - k * d1(n-l)
//   q(n)  = q(n-1) + m2 * p(n)
//   s(n)  = s(n-1) + q(n) + m1 * p(n)

import package_settings::*;
import package_settings_v_6::*;

module v6_filter (
    input  wire                         clk,     // System clock
    input  wire                         reset,   // Synchronous-active-high reset 
    input  wire signed [15:0]           v,       // Raw input sample v(n)
    output reg  signed [15:0]           s        // Filtered output sample s(n)
);

    // Number of fractional bits used by fixed-point coefficients m1/m2
    localparam int FRAC = 16;

    reg signed [15:0] v_delay [1:k_v6]; // v_delay[1] = v(n-1), v_delay[2] = v(n-2), ...
    reg signed [31:0] d1_delay [1:l_v6]; // d1_delay[1] = d1(n-1), d1_delay[2] = d1(n-2), 

    // First-order and k-order input differences
    wire signed [31:0] dk;   // dk(n) = v(n) - v(n-k)
    wire signed [31:0] d1;   // d1(n) = v(n) - v(n-1)

    // Recursive accumulator registers
    reg signed [31:0] p_reg; // p(n-1)
    reg signed [31:0] q_reg; // q(n-1)
    reg signed [31:0] s_reg; // s(n-1)

    // Next-state values calculated during the current clock cycle
    reg signed [31:0] next_p;
    reg signed [31:0] next_q;
    reg signed [31:0] next_s;

    
    assign dk = $signed(v) - $signed(v_delay[k_v6]);//  dk(n) = v(n) - v(n-k)    
    assign d1 = $signed(v) - $signed(v_delay[1]);   //  d1(n) = v(n) - v(n-1)

    // Select d1(n-l):
    // - If l = 1, use the current difference d1(n).
    // - Otherwise, use the delayed value d1(n-l).
    wire signed [31:0] d1_l =
        (l_v6 == 1) ? d1 : d1_delay[l_v6];

    // p(n) = p(n-1) + dk(n) - k * d1(n-l)
    // Use a wider intermediate result to reduce overflow risk.
    wire signed [63:0] k_d1   = $signed(k_v6) * $signed(d1_l);
    wire signed [63:0] p_full = $signed(p_reg) + $signed(dk) - k_d1;

    // q(n) = q(n-1) + m2 * p(n)
    // m2 is a QFRAC fixed-point coefficient, so shift the product right.
    wire signed [63:0] q_full =
        $signed(q_reg) +
        (($signed(m2_v6) * $signed(next_p)) >>> FRAC);

    // s(n) = s(n-1) + q(n) + m1 * p(n)
    // m1 is also a QFRAC fixed-point coefficient.
    wire signed [63:0] s_full =
        $signed(s_reg) + $signed(next_q) +
        (($signed(m1_v6) * $signed(next_p)) >>> FRAC);

    // Truncate wide intermediate results back to 32-bit accumulator width.
    // For a production design, consider saturation instead of truncation.
    assign next_p = p_full[31:0];
    assign next_q = q_full[31:0];
    assign next_s = s_full[31:0];

    // Sequential logic: update delay lines and recursive accumulators
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear all filter state
            p_reg <= '0;
            q_reg <= '0;
            s_reg <= '0;
            s     <= '0;

            // Initialize the input delay line
            for (int i = 1; i <= k_v6; i++) begin
                v_delay[i] <= '0;
            end

            // Initialize the d1 delay line
            for (int j = 1; j <= l_v6; j++) begin
                d1_delay[j] <= '0;
            end
        end
        else begin
            // Shift the input delay line:
            // v_delay[i] <= v_delay[i-1]
            for (int i = k_v6; i > 1; i--) begin
                v_delay[i] <= v_delay[i-1];
            end
            v_delay[1] <= v;

            // Shift the d1 delay line:
            // d1_delay[j] <= d1_delay[j-1]
            for (int j = l_v6; j > 1; j--) begin
                d1_delay[j] <= d1_delay[j-1];
            end
            d1_delay[1] <= d1;

            // Update recursive accumulator states
            p_reg <= next_p;
            q_reg <= next_q;
            s_reg <= next_s;

            // Convert the fixed-point accumulator to the 16-bit output format.
            // Adjust this shift if the desired output scaling differs.
            s <= next_s >>> FRAC;
        end
    end

endmodule