
// 8-bit register module that computes DATA_OUT = A * B + C on the rising edge of the clock.
 
module bit_8_register_true (
    input  logic        clk, // clock
    input  logic [IN_WIDTH-1:0]  A, //input value
    input  logic [IN_WIDTH-1:0]  B, //input value
    input  logic [IN_WIDTH-1:0]  C, //input value
    output logic [OUT_WIDTH-1:0]  DATA_OUT //output value
);
	
	`include "params.v"
	// IN_WIDTH = 8
	// OUT_WIDTH = 16, because max output value: 255*255+255= 65280 < 65536 = 2^16
    
    logic [OUT_WIDTH-1:0] tmp;
    assign tmp = A * B;
    
    always_ff @(posedge clk) begin  //synchronous block triggered on the rising edge of the clk signal         
        DATA_OUT <= tmp + C ;  
    end
endmodule