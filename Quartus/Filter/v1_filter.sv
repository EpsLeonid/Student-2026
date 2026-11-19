import package_settings_v_1::*;

module v1_filter (
    input  wire                       clk,         // тактовый сигнал
    input  wire                       reset,       // асинхронный сброс (активный низкий)
    input  wire [IN_WIDTH-1:0]        input_data,  // отсчёты с АЦП
    output wire [OUT_WIDTH-1:0]       output_data  // выход фильтра
);

    localparam DELAY_LEN = K + L;                  // длина линии задержки = 13

    // Линия задержки: история отсчётов входа
    reg [IN_WIDTH-1:0] v_delay [0:DELAY_LEN-1];
    integer i;

    // Аккумуляторы двойного интегрирования
    reg signed [ACC_WIDTH-1:0] p_reg;
    reg signed [ACC_WIDTH-1:0] s_reg;

    wire signed [ACC_WIDTH-1:0] d;
    wire signed [ACC_WIDTH-1:0] r;

    // d(n) = v(n) - v(n-k) - v(n-l) + v(n-k-l)
    assign d = $signed({1'b0, input_data})
             - $signed({1'b0, v_delay[K-1]})
             - $signed({1'b0, v_delay[L-1]})
             + $signed({1'b0, v_delay[DELAY_LEN-1]});

    // r(n) = p(n) + M*d(n):
    // в этот момент p_reg ещё хранит p(n-1), а p(n) = p(n-1) + d(n),
    // поэтому p_reg + (M+1)*d — это ровно формула из методички
    assign r = p_reg + (M + 1) * d;

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            p_reg <= {ACC_WIDTH{1'b0}};
            s_reg <= {ACC_WIDTH{1'b0}};
            for (i = 0; i < DELAY_LEN; i = i + 1)
                v_delay[i] <= {IN_WIDTH{1'b0}};
        end else begin
            // Сдвиг истории и запись нового отсчёта
            v_delay[0] <= input_data;
            for (i = 1; i < DELAY_LEN; i = i + 1)
                v_delay[i] <= v_delay[i-1];

            // Двойное интегрирование
            p_reg <= p_reg + d;
            s_reg <= s_reg + r;
        end
    end

    // На выход — старшие OUT_WIDTH бит аккумулятора (деление на 256)
    assign output_data = s_reg[OUT_WIDTH+7:8];

endmodule