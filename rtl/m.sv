interface if_mfa_cla#(parameter WIDTH = 4) (
    input logic [WIDTH-1:0] in1,
    input logic [WIDTH-1:0] in2,
    input logic czero,
    output logic [WIDTH-1:0] sum,
    output logic cout
);
    logic [WIDTH-1:0] pr;
    logic [WIDTH-1:0] gn;
    logic [WIDTH-2:0] cin;
    logic gpr;
    logic ggn;

    modport mfa_side(
        input in1, in2, czero, cin,
        output cout, sum, pr, gn
    );

    modport cla_side(
        input pr,gn,czero,
        output cin, gpr, ggn
    );
endinterface

interface if_multiplier#(parameter WIDTH = 8)();
    logic [WIDTH-1:0] in1;
    logic [WIDTH-1:0] in2;
    logic czero;
    
    logic [2*WIDTH:0] out;
    logic cout;

    modport mul_side(
        input in1, in2, czero,
        output cout, out
    );

endinterface
/*
// Partial Product Generation - CHECK THIS
module partial_product#(parameter WIDTH = 8)(
    input logic [WIDTH-1:0] in1, 
    input logic [WIDTH-1:0] in2,
    output logic [WIDTH-1:0][WIDTH-1:0] out
);

genvar i,j ;
for(i=0; i<WIDTH; i=i+1) begin 
    for(j=0; j<WIDTH; j = j+1 ) begin 
        assign out[i][j] = in1[i] & in2[j];
end
end
endmodule
*/
/*

module multiplier#(parameter WIDTH = 8)(
    if_multiplier.mul_side multif
);

endmodule
*/
// 4-Bit carry look ahead logic

module cla_4(if_mfa_cla.cla_side clif);
    assign clif.gpr = & (clif.pr) ;
    assign clif.ggn = clif.gn[3] | (clif.pr[3] & clif.gn[2]) | (clif.pr[3] & clif.pr[2] & clif.gn[1]) | (clif.pr[3] & clif.pr[2] & clif.pr[1] & clif.gn[0]); 
    assign clif.cin[0] = clif.gn[0] | ( clif.pr[0] & clif.czero);
    assign clif.cin[1] = clif.gn[1] | ( clif.pr[1] & (clif.gn[0] | ( clif.pr[0] & clif.czero)));
    assign clif.cin[2] = clif.gn[2] | ( clif.pr[2] & (clif.gn[1] | ( clif.pr[1] & (clif.gn[0] | ( clif.pr[0] & clif.czero))) ));
endmodule

// Modified WIDTH-bit Full Adder 
module mfa#(parameter WIDTH = 4)(if_mfa_cla.mfa_side mif);
genvar i;
for(i = 0; i<WIDTH; i=i+1) begin
    assign mif.pr[i] = mif.in1[i] | mif.in2[i] ;
    assign mif.gn[i] = mif.in1[i] & mif.in2[i] ;
    if(i == 0) begin 
        assign mif.sum[i] = mif.in1[i] ^ mif.in2[i] ^ mif.czero;
    end else begin 
        assign mif.sum[i] = mif.in1[i] ^ mif.in2[i] ^ mif.cin[i-1];
    end
end
endmodule

module HA(
    input wire a,
    input wire b,
    output wire sum,
    output wire cout
);
assign sum = a^b;
assign cout = a&b;
endmodule

module FA(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a^b^cin;
    assign cout = (a&b) | (b&cin) | (cin&a);
endmodule
/*
// 
module app_adder#(parameter WIDTH = 4)(input logic [WIDTH-1:0] in_array, 
                                        output logic  [WIDTH-1:0] out);

endmodule
*/