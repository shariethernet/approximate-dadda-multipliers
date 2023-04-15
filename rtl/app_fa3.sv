module FA(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&b) ^ cin;
    assign sum = ~cout;
endmodule
