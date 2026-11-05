module mult (
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output wire [15:0] C
);

    // Умножение двух 8-разрядных чисел дает до 16 бит на выходе
    assign C = A * B;

endmodule