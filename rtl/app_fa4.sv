module AFA(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&b) | (b&cin) | (cin&a);
    assign sum = ~cout;
endmodule