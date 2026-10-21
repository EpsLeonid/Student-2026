

// 8-bit register module that computes DATA_OUT = A * B + C on the rising edge of the clock.

    
module bit_8_register (
    input  logic        clk, //clock
    input  logic [7:0]  A, //input value
    input  logic [7:0]  B, //input value
    input  logic [7:0]  C, //input value
    output logic [7:0]  DATA_OUT //output value 
);

    logic [15:0] tmp;
    assign tmp = A * B;
    
    always_ff @(posedge clk) begin  //synchronous block triggered on the rising edge of the clk signal           
        DATA_OUT <= tmp + C ;  
    end
endmodule

//Since the result of the multiplication (up to 16 bits) and addition is assigned to the 8-bit DATA_OUT, 
//the upper bits will be truncated.