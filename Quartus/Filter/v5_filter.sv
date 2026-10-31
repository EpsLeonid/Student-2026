// Triangular filter (variant 5, formulas B).
// Implements the algorithm:
// d = v(n) - v(n-K5) - v(n-L5) + v(n-K5-L5)
// p = p_prev + d
// r = p + M5 * d
// s = s_prev + r

// Connect the global project settings file to take from it
// the bit widths of the input and output buses (SIZE_ADC_DATA and SIZE_FILTER_DATA).
import package_settings::*;

// Connect my file with filter coefficients (K5, L5, M5).
import package_v5_params::*;

module v5_filter (
    input  wire clk,           // Clock signal
    input  wire reset,         // Reset signal
    input  wire [SIZE_ADC_DATA-1:0] input_data,    // Input signal v(n)
    output wire [SIZE_FILTER_DATA-1:0] output_data    // Output signal s(n)
);

    // Array of registers to store past values of the input signal.
    // It is needed to obtain delayed signals v(n-K5), v(n-L5)
    // and v(n-K5-L5), which are used in the formula.
    // The array size equals the sum of delays (K5+L5).
    logic [SIZE_ADC_DATA-1:0] v_delay [0:(K5+L5)-1];
    integer i;

    // Variables for storing the current values of sums p and s.
    // They are needed to accumulate new values
    // to the old ones from clock to clock (cumsum in MATLAB).
    // The signed type is needed because the result of subtraction
    // in signal d can be negative.
    logic signed [SIZE_FILTER_DATA-1:0] p_reg;
    logic signed [SIZE_FILTER_DATA-1:0] s_reg;

    // Signals d and r.
    // They are needed as intermediate steps for calculations by formulas.
    // They are calculated instantly, without waiting for the clock.
    logic signed [SIZE_FILTER_DATA-1:0] d;
    logic signed [SIZE_FILTER_DATA-1:0] r;

    // Calculate d(n) by the formula using the current and delayed signals.
    // $signed() forces the program to process data as signed numbers.
    // Without this, during subtraction the result could be perceived
    // as a huge positive number instead of a negative one.
    assign d = $signed(input_data) - $signed(v_delay[K5-1]) - $signed(v_delay[L5-1]) + $signed(v_delay[K5+L5-1]);

    // Calculate r(n). By the formula r = p + M5*d.
    // Since p = p_reg + d, we can simplify: r = p_reg + (M5+1)*d.
    assign r = p_reg + (M5 + 1) * d;

    // Block that triggers on the clock edge (clk) or on reset (reset).
    // All calculations with memory happen inside.
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // If reset is pressed, clear the sum variables and
            // zero out the entire array with stored old values.
            p_reg <= '0;
            s_reg <= '0;
            for (i = 0; i < (K5+L5); i = i + 1) begin
                v_delay[i] <= '0;
            end
        end else begin
            // On each clock cycle, shift the values in the array:
            // write the new value into the zero cell,
            // and the old ones shift one step to the right.
            v_delay[0] <= input_data;
            for (i = 1; i < (K5+L5); i = i + 1) begin
                v_delay[i] <= v_delay[i-1];
            end

            // Add new values d and r to the past sums p and s.
            p_reg <= p_reg + d;
            s_reg <= s_reg + r;
        end
    end

    // Output the total sum s to the output.
    // Since the sum bit width may be larger than the output port's,
    // we take only the lower bits (those that fit into SIZE_FILTER_DATA).
    assign output_data = s_reg[SIZE_FILTER_DATA-1:0];

endmodule