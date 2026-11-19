package package_settings_v_1;

    // Вариант 1: трапецеидальный фильтр (формулы Б)
    localparam int K         = 8;    // параметр k
    localparam int L         = 5;    // параметер l
    localparam int M         = 16;   // параметр M

    localparam int IN_WIDTH  = 12;   // разрядность входа (АЦП)
    localparam int OUT_WIDTH = 16;   // разрядность выхода
    localparam int ACC_WIDTH = 24;   // разрядность аккумуляторов

endpackage
