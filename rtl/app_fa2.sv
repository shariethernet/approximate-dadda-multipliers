module AFA(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&cin) | b;
    assign sum = ~cout;
endmodule