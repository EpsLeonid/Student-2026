import package_settings_v_1::*;

module v1_filter (
    input wire clk,
    input wire reset,          // 
    input wire signed [IN_WIDTH-1:0] input_data, // 
    output wire signed [OUT_WIDTH-1:0] output_data // 
);

    // Линии задержки входного сигнала
    reg signed [IN_WIDTH-1:0] delay_k [0:K-1];
    reg signed [IN_WIDTH-1:0] delay_l [0:L-1];
    reg signed [IN_WIDTH-1:0] delay_kl [0:K+L-1];

    wire signed [IN_WIDTH-1:0] v_k  = delay_k[K-1];
    wire signed [IN_WIDTH-1:0] v_l  = delay_l[L-1];
    wire signed [IN_WIDTH-1:0] v_kl = delay_kl[K+L-1];

    // Вторая разность: d = input_data - input_data(K) - input_data(L) + input_data(K+L)
    wire signed [IN_WIDTH+1:0] d = input_data - v_k - v_l + v_kl;

    // Двойное интегрирование дает трапецию
    reg signed [OUT_WIDTH-1:0] p;
    reg signed [OUT_WIDTH-1:0] s;

    integer i;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            for (i = 0; i < K; i = i + 1) delay_k[i] <= 0;
            for (i = 0; i < L; i = i + 1) delay_l[i] <= 0;
            for (i = 0; i < K+L; i = i + 1) delay_kl[i] <= 0;
            p <= 0;
            s <= 0;
        end else begin
            delay_k[0] <= input_data;
            for (i = 1; i < K; i = i + 1) delay_k[i] <= delay_k[i-1];

            delay_l[0] <= input_data;
            for (i = 1; i < L; i = i + 1) delay_l[i] <= delay_l[i-1];

            delay_kl[0] <= input_data;
            for (i = 1; i < K+L; i = i + 1) delay_kl[i] <= delay_kl[i-1];

            p <= p + d;
            s <= s + p;
        end
    end

    assign output_data = s;

endmodule