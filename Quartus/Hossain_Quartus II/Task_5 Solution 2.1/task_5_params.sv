// task_5_params.sv - Header file for bus width parameters
`ifndef TASK_5_PARAMS_SV
`define TASK_5_PARAMS_SV

parameter int INPUT_WIDTH  = 8;
// Correct output bus width to prevent overflow: 16 bits
parameter int OUTPUT_WIDTH = 16; 

`endif // TASK_5_PARAMS_SV
