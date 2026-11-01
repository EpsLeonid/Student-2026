//-----------------------------------------------------------------------------
// File        : v3_filter.sv
// Description : Modified cusp-like filter (Variant 3)
//-----------------------------------------------------------------------------
import package_settings_v_3::*;

module v3_filter (
    input  wire                         clk,
    input  wire                         reset,
    input  wire signed [15:0]           v_in,   // Input signal from exponential generator
    output reg  signed [15:0]           s_out   // Filtered output signal s(n)
);

    // Internal delay lines 
    reg signed [15:0] v_delay [1:PARAM_K3];
    reg signed [31:0] d1_delay [1:PARAM_L3];

    // Internal difference signals
    wire signed [31:0] dk;
    wire signed [31:0] d1;
    
    // Accumulator registers p, q, s
    reg signed [31:0] p_reg;
    reg signed [31:0] q_reg;
    reg signed [31:0] s_reg;
    
    // Variables for calculations
    reg signed [31:0] next_p;
    reg signed [31:0] next_q;


    // Calc of differences (dk = v(n)-v(n-k), d1 = v(n)-v(n-1))
    assign dk = $signed(v_in) - $signed(v_delay[PARAM_K3]);
    assign d1 = $signed(v_in) - $signed(v_delay[1]);

    // Synchron processing of each clock cycle
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            p_reg <= '0;
            q_reg <= '0;
            s_reg <= '0;
            s_out <= '0;
            for (int i = 1; i <= PARAM_K3; i++) v_delay[i]  <= '0;
            for (int j = 1; j <= PARAM_L3; j++) d1_delay[j] <= '0;
        end else begin
            // Input signal delay line shift
            for (int i = PARAM_K3; i > 1; i--) begin
                v_delay[i] <= v_delay[i-1];
            end
            v_delay[1] <= v_in;
            
            // Delay line shift for the difference d1
            for (int j = PARAM_L3; j > 1; j--) begin
                d1_delay[j] <= d1_delay[j-1];
            end
            d1_delay[1] <= d1; 

            // Intermediate signals for the current clock cycle
            next_p = p_reg + dk - (PARAM_K3 * d1_delay[PARAM_L3]);
            next_q = q_reg + (PARAM_M23 * next_p);

            // Updating accumulator registers
            p_reg <= next_p;
            q_reg <= next_q;
            s_reg <= s_reg + next_q + (PARAM_M13 * next_p);

            // Filter result
            s_out <= s_reg + next_q + (PARAM_M13 * next_p) >>> 16;

        end
    end

endmodule
