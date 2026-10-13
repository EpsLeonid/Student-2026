// Разрядности A, B, C и DATA_OUT берутся из файла task5_params.vh,
// поэтому при изменении WIDTH меняются все шины сразу.
// DATA_OUT шириной 2*WIDTH, потому что произведение двух WIDTH-битных
// чисел занимает до 2*WIDTH бит, а прибавление C не выходит за эти
// пределы, поэтому нет переполнения.

module task5_verilog (
    input  logic clk,                        // Тактовый сигнал
    input  logic [WIDTH-1:0]     A,          // A
    input  logic [WIDTH-1:0]     B,          // B
    input  logic [WIDTH-1:0]     C,          // C
    output logic [OUT_WIDTH-1:0] DATA_OUT    // Результат: A*B + C
);

    `include "task5_params.vh"

    // Произведение A*B: ширина PROD_WIDTH = 2*WIDTH, чтобы
    // результат умножения не обрезался. При WIDTH=8 это 16 бит.
    logic [PROD_WIDTH-1:0] product;

    // assign — комбинационная логика: product пересчитывается
    // сразу при изменении A или B, без тактового сигнала.
    assign product = A * B;

   // По положительному фронту clk выполняется DATA_OUT <= product + C.
   // Старшие биты суммы отбрасываются, а в DATA_OUT идут только младшие,
   // тк DATA_OUT шириной 2*WIDTH, а сумма product + C может
   // занимать больше разрядов.
    always_ff @(posedge clk) begin
        DATA_OUT <= product + C;
    end

endmodule