//-----------------------------------------------------------------------------
// Title       : Package Settings for Variant 4 (Trapezoidal Shaping Filter)
// File        : package_settings_v_4.sv
// Description : Parameter package for trapezoidal filter: k=9, l=5, M=16
//-----------------------------------------------------------------------------
package package_settings_v_4;

    // Trapezoidal filter parameters (Variant 4)
    parameter K_V4 = 9;
    parameter L_V4 = 5;
    parameter M_V4 = 16;

    // Input and output bus widths
    parameter IN_WIDTH_V4  = 14;
    parameter OUT_WIDTH_V4 = 16;

endpackage