// =================================================================
// ГЛАВНЫЙ МОДУЛЬ (ОБЩАЯ КОРОБКА) - Объединяет пункты 2, 3, 4 и 5
// =================================================================
`include "params.svh" // Подключаем параметры для пункта 5

module task_2 (
    input  logic clk, // Общие часы для всех заданий

    // Провода для Пункта 2 (Умножение)
    input  logic [7:0]  p2_A,
    input  logic [7:0]  p2_B,
    output logic [15:0] p2_C,

    // Провода для Пункта 3 (D-триггер)
    input  logic        p3_d,
    output logic        p3_out,

    // Провода для Пункта 4 (8-битный регистр)
    input  logic [7:0]  p4_A,
    input  logic [7:0]  p4_B,
    input  logic [7:0]  p4_C,
    output logic [7:0]  p4_DATA_OUT,

    // Провода для Пункта 5 (Параметризованный регистр)
    input  logic [INPUT_WIDTH-1:0]  p5_A,
    input  logic [INPUT_WIDTH-1:0]  p5_B,
    input  logic [INPUT_WIDTH-1:0]  p5_C,
    output logic [OUTPUT_WIDTH-1:0] p5_DATA_OUT
);

    // Подключаем внутренний модуль из пункта 2
    multiplier inst_p2 (
        .A(p2_A), .B(p2_B), .C(p2_C)
    );

    // Подключаем внутренний D-триггер из пункта 3
    d_flop inst_p3 (
        .clk(clk), .d(p3_d), .out(p3_out)
    );

    // Подключаем внутренний регистр из пункта 4
    reg_calc_8bit inst_p4 (
        .clk(clk), .A(p4_A), .B(p4_B), .C(p4_C), .DATA_OUT(p4_DATA_OUT)
    );

    // Подключаем параметризованный регистр из пункта 5
    reg_calc_param inst_p5 (
        .clk(clk), .A(p5_A), .B(p5_B), .C(p5_C), .DATA_OUT(p5_DATA_OUT)
    );

endmodule


// ==========================================
// Пункт 2: Модуль умножения
// ==========================================
module multiplier (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [15:0] C 
);
    assign C = A * B;
endmodule


// ==========================================
// Пункт 3: D-триггер
// ==========================================
module d_flop (
    input  logic clk,
    input  logic d,
    output logic out
);
    always_ff @(posedge clk) begin
        out <= d; 
    end
endmodule


// ==========================================
// Пункт 4: 8-разрядный регистр с вычислением
// ==========================================
module reg_calc_8bit (
    input  logic       clk,
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [7:0] C,
    output logic [7:0] DATA_OUT
);
    always_ff @(posedge clk) begin
        DATA_OUT <= A * B + C;
    end
endmodule


// ==========================================
// Пункт 5: Параметризованный модуль регистра
// ==========================================
module reg_calc_param (
    input  logic                    clk,
    input  logic [INPUT_WIDTH-1:0]  A,
    input  logic [INPUT_WIDTH-1:0]  B,
    input  logic [INPUT_WIDTH-1:0]  C,
    output logic [OUTPUT_WIDTH-1:0] DATA_OUT
);
    always_ff @(posedge clk) begin
        DATA_OUT <= A * B + C;
    end
endmodule


