
// File Name:   params.vh
// Description: Global parameter definition header file for bus widths

`ifndef PARAMS_VH
`define PARAMS_VH

// Width of the input operands (A, B, C)
parameter IN_WIDTH = 8;

// Correct output width to eliminate overflow: 2 * IN_WIDTH = 16 bits
// Max value: (255 * 255) + 255 = 65280 <= 65535 (fits strictly in 16 bits)
parameter OUT_WIDTH = 2 * IN_WIDTH;

`endif