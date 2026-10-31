`ifndef V8_PARAMS_VH
`define V8_PARAMS_VH

parameter V8_K  = 7;            // Triangle rise time parameter (samples)
parameter V8_L  = 7;            // Triangle decay time parameter (samples)
parameter V8_KL = V8_K + V8_L;  // Total delay pipeline length (14 samples)
parameter V8_M  = 16;           // Decay compensation factor (M = 16)

`endif