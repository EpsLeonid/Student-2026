
//A,B - bynary signal
//C = A * B

module my_multiply (
    input  logic A,
    input  logic B,
    output logic C
);

    assign C = A * B;

endmodule