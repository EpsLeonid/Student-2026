package package_settings_v_1;

// Параметры трапецеидального фильтра, вариант 1: k=8, l=5, M=16
parameter K         = 8;    // задержка первой линии
parameter L         = 5 ;   // задержка второй линии
parameter M         = 16 ;  // коэффициент усиления M
parameter IN_WIDTH  = 12 ;  // разрядность входного сигнала (АЦП, 12 бит)
parameter OUT_WIDTH = 16 ;  // разрядность выходной шины (без переполнения)

endpackage