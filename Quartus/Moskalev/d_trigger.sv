

//Synchronous D flip-flop module.  
//On the rising edge of the clock clk, the value from input d is latched to output out 
 module d_trigger (
 
    input  logic d, //input value 
    input  logic clk,//clock 
    output logic out//output value 
);
    always_ff @(posedge clk) begin //The always_ff block is used to describe the sequential logic.
        out <= d;
    end
endmodule