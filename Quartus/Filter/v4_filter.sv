`include "package_settings_v_4.sv"

module v4_filter (
    input  wire                        clk,
    input  wire                        reset,
    input  wire [IN_WIDTH_V4-1:0]      input_data,
    output reg  [OUT_WIDTH_V4-1:0]     output_data
);

    localparam DELAY_LEN_V4 = K_V4 + L_V4; // 14 тактов

    // Линия задержки для хранения отсчетов v(n-1) ... v(n-k-l)
    reg [IN_WIDTH_V4-1:0] v_delay [1:DELAY_LEN_V4];

    // Аккумуляторы рекурсивного фильтра
    reg signed [31:0] p_reg;
    reg signed [31:0] s_reg;

  
    wire signed [31:0] v_curr = $signed({1'b0, input_data});
    wire signed [31:0] v_k    = $signed({1'b0, v_delay[K_V4]});
    wire signed [31:0] v_l    = $signed({1'b0, v_delay[L_V4]});
    wire signed [31:0] v_kl   = $signed({1'b0, v_delay[DELAY_LEN_V4]});

    wire signed [31:0] d_n = v_curr - v_k - v_l + v_kl;
    wire signed [31:0] p_n = p_reg + d_n;
    wire signed [31:0] r_n = p_n + (M_V4 * d_n);
    wire signed [31:0] s_n = s_reg + r_n;

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 1; i <= DELAY_LEN_V4; i = i + 1) begin
                v_delay[i] <= {IN_WIDTH_V4{1'b0}};
            end
            p_reg       <= 32'sd0;
            s_reg       <= 32'sd0;
            output_data <= {OUT_WIDTH_V4{1'b0}};
        end else begin
            v_delay[1] <= input_data;
            for (i = 2; i <= DELAY_LEN_V4; i = i + 1) begin
                v_delay[i] <= v_delay[i-1];
            end
            p_reg       <= p_n;
            s_reg       <= s_n;
            output_data <= s_n[OUT_WIDTH_V4-1:0];
        end
    end

endmodule