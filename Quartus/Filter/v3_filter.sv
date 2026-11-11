//----------------------------------------------------------------------------- 
// Description : Modified cusp-like filter (Variant 3) 
// Implements the algorithm: 
// dk = v(n) - v(n-K) 
// d1 = v(n) - v(n-1) 
// p = p_prev + dk - K * d1(n-L) 
// q = q_prev + M2 * p 
// s = s_prev + q + M1 * p 
//----------------------------------------------------------------------------- 

import package_settings::*; // Include global settings
import package_settings_v_3::*; // Include variant 3 parameters (PARAM_L3, PARAM_K3, PARAM_M13, PARAM_M23)

module v3_filter (
    input wire clk,                           // Clock signal
    input wire reset,                         // Reset signal
    input wire [SIZE_ADC_DATA-1:0] input_data,      // Input signal v(n) from the generator
    output logic [SIZE_FILTER_DATA-1:0] output_data // Filtered registered output s(n)
);

    // Delay line for input signal v. Array size is PARAM_K3.
    logic signed [SIZE_ADC_DATA-1:0] v_delay [0:PARAM_K3-1]; 
    
    // Delay line for difference d1. Array size is PARAM_L3.
    logic signed [SIZE_FILTER_DATA-1:0] d1_delay [0:PARAM_L3-1]; 
    
    integer i, j;

    // Accumulator registers to store sums (filter memory between clock cycles)
    logic signed [SIZE_FILTER_DATA-1:0] p_reg;
    logic signed [SIZE_FILTER_DATA-1:0] q_reg;
    logic signed [SIZE_FILTER_DATA-1:0] s_reg;

    // Intermediate combinatorial signals for instant formula evaluation
    logic signed [SIZE_FILTER_DATA-1:0] dk;
    logic signed [SIZE_FILTER_DATA-1:0] d1;
    logic signed [SIZE_FILTER_DATA-1:0] p_comb;
    logic signed [SIZE_FILTER_DATA-1:0] q_comb;
    logic signed [SIZE_FILTER_DATA-1:0] s_comb;

    // 1. Calculate differences for the current cycle (in SystemVerilog v_delay[0] represents v(n-1))
    assign dk = $signed(input_data) - $signed(v_delay[PARAM_K3-1]);
    assign d1 = $signed(input_data) - $signed(v_delay[0]);

    // 2. Calculate p(n) = p_prev + dk - k * d1(n-l)
    assign p_comb = p_reg + dk - (PARAM_K3 * $signed(d1_delay[PARAM_L3-1]));

    // 3. Calculate q(n) = q_prev + m2 * p(n)
    assign q_comb = q_reg + (PARAM_M23 * p_comb);

    // 4. Calculate s(n) = s_prev + q(n) + m1 * p(n)
    assign s_comb = s_reg + q_comb + (PARAM_M13 * p_comb);

    // Flip-flop block: memory update and shifting on the rising edge of clk
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Asynchronous reset of all registers to 0
            p_reg <= '0;
            q_reg <= '0;
            s_reg <= '0;
            output_data <= '0;
            for (i = 0; i < PARAM_K3; i = i + 1)   v_delay[i]  <= '0;
            for (j = 0; j < PARAM_L3; j = j + 1)   d1_delay[j] <= '0;
        end else begin
            // Shift the v_delay line (moving from the end of the array to the beginning)
            for (i = PARAM_K3 - 1; i > 0; i = i - 1) begin
                v_delay[i] <= v_delay[i-1];
            end
            v_delay[0] <= $signed(input_data);

            // Shift the d1_delay line (moving from the end of the array to the beginning)
            for (j = PARAM_L3 - 1; j > 0; j = j - 1) begin
                d1_delay[j] <= d1_delay[j-1];
            end
            d1_delay[0] <= d1;

            // Update accumulator registers with the calculated values
            p_reg <= p_comb;
            q_reg <= q_comb;
            s_reg <= s_comb;

            // Registered output, latched simultaneously with s_reg
            output_data <= s_comb[SIZE_FILTER_DATA-1:0];
        end
    end

endmodule
