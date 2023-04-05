// Code your design here
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

module cla_4(if_mfa_cla.cla_side clif);
    assign clif.gpr = & (clif.pr) ;
    assign clif.ggn = clif.gn[3] | (clif.pr[3] & clif.gn[2]) | (clif.pr[3] & clif.pr[2] & clif.gn[1]) | (clif.pr[3] & clif.pr[2] & clif.pr[1] & clif.gn[0]); 
    assign clif.cin[0] = clif.gn[0] | ( clif.pr[0] & clif.czero);
    assign clif.cin[1] = clif.gn[1] | ( clif.pr[1] & (clif.gn[0] | ( clif.pr[0] & clif.czero)));
    assign clif.cin[2] = clif.gn[2] | ( clif.pr[2] & (clif.gn[1] | ( clif.pr[1] & (clif.gn[0] | ( clif.pr[0] & clif.czero))) ));
endmodule

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