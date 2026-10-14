// =================================================================
// MAIN MODULE - combines items 2, 3, 4 and 5
// =================================================================
`include "params.svh" // Configuring the parameters for item 5

module task_2 (
    input  logic clk, // Common clock signal for all tasks

    // Wires for item 2 (multiplication)
    input  logic p2_A,
    input  logic p2_B,
    output logic p2_C,

    // Wires for item 3 (D flip-flop)
    input  logic p3_d,
    output logic p3_out,

    // Wires for item 4 (8-bit register)
    input  logic [7:0]  p4_A,
    input  logic [7:0]  p4_B,
    input  logic [7:0]  p4_C,
    output logic [7:0]  p4_DATA_OUT,

    // Wires for item 5 (parameterized register)
    input  logic [INPUT_WIDTH-1:0]  p5_A,
    input  logic [INPUT_WIDTH-1:0]  p5_B,
    input  logic [INPUT_WIDTH-1:0]  p5_C,
    output logic [OUTPUT_WIDTH-1:0] p5_DATA_OUT
);

    // Connect the internal module from step 2
    multiplier inst_p2 (
        .A(p2_A), .B(p2_B), .C(p2_C)
    );

    // Connect the internal D flip-flop from step 3
    d_flop inst_p3 (
        .clk(clk), .d(p3_d), .out(p3_out)
    );

    // Connect the internal register from step 4
    reg_calc_8bit inst_p4 (
        .clk(clk), .A(p4_A), .B(p4_B), .C(p4_C), .DATA_OUT(p4_DATA_OUT)
    );

    // Connect the internal parameterized register from step 5
    reg_calc_param inst_p5 (
        .clk(clk), .A(p5_A), .B(p5_B), .C(p5_C), .DATA_OUT(p5_DATA_OUT)
    );

endmodule


// ==========================================
// Item 2: Multiplication module
// ==========================================
module multiplier (
    input  logic A,
    input  logic B,
    output logic C 
);
    assign C = A * B;
endmodule


// ==========================================
// Item 3: D flip-flop
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
// Item 4: 8-bit register
// ==========================================
module reg_calc_8bit (
    input  logic       clk,
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [7:0] C,
    output logic [7:0] DATA_OUT
);

	logic [7:0] C_delayed; // Wire to delay sign C by 1 clock cycle
	
    always_ff @(posedge clk) begin
		C_delayed <= C; // Delaying sign C
		
        DATA_OUT <= A * B + C_delayed;
    end
endmodule


// ==========================================
// Item 5: Parameterized register module
// ==========================================
module reg_calc_param (
    input  logic clk,
    input  logic [INPUT_WIDTH-1:0]  A,
    input  logic [INPUT_WIDTH-1:0]  B,
    input  logic [INPUT_WIDTH-1:0]  C,
    output logic [OUTPUT_WIDTH-1:0] DATA_OUT
);

	logic [INPUT_WIDTH-1:0] C_delayed;
    always_ff @(posedge clk) begin
		C_delayed <= C;
		
        DATA_OUT <= A * B + C_delayed;
    end
endmodule


