module partial_product#(parameter WIDTH = 2)(
    input logic [WIDTH-1:0] in1, 
    input logic [WIDTH-1:0] in2,
    output logic [0:WIDTH-1][WIDTH-1:0] out 
);
genvar i,j ;
for(i=0; i<WIDTH; i=i+1) begin 
    for(j=0; j<WIDTH; j = j+1 ) begin 
        assign out[i][j] = in1[j] & in2[i];
end
end
endmodule