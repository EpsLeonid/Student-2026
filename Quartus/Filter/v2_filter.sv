import package_settings_v_2::*;
import package_settings::*;

module v2_filter (
    input  wire                     clk,
    input  wire                     reset,
    input  wire [SIZE_ADC_DATA-1:0] input_data,
    output logic [SIZE_ADC_DATA-1:0] output_data
);

    // Shift register for storing historical samples (up to k2 + l2 = 10 samples)
    logic [SIZE_ADC_DATA-1:0] shift_reg [0:10];

    // Internal signals with extended bit-width to prevent overflow
    logic signed [SIZE_ADC_DATA+3:0]  d_kl;
    logic signed [SIZE_ADC_DATA+11:0] p_acc;
    logic signed [SIZE_ADC_DATA+11:0] r_comp;
    logic signed [SIZE_ADC_DATA+19:0] s_acc;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i <= 10; i++) begin
                shift_reg[i] <= '0;
            end
            p_acc       <= '0;
            s_acc       <= '0;
            output_data <= '0;
        end else begin
            // Shift the data delay line
            shift_reg[0] <= input_data;
            for (int i = 1; i <= 10; i++) begin
                shift_reg[i] <= shift_reg[i-1];
            end

            // Step 1: First difference d^(k,l)(n) = v(n) - 2*v(n-5) + v(n-10)
            d_kl = signed'({1'b0, input_data}) - 
                   (signed'({1'b0, shift_reg[k2]}) <<< 1) + 
                   signed'({1'b0, shift_reg[k2 + l2]});

            // Step 2: First integrator p(n) = p(n-1) + d^(k,l)(n)
            p_acc = p_acc + d_kl;

            // Step 3: Decay compensation r(n) = p(n) + m2 * d^(k,l)(n)
            r_comp = p_acc + (d_kl * m2);

            // Step 4: Second integrator s(n) = s(n-1) + r(n)
            s_acc = s_acc + r_comp;

            // Filter output signal
            output_data <= s_acc[SIZE_ADC_DATA-1:0];
        end
    end

endmodule