interface if_mfa_cla#(parameter WIDTH = 4) (
    input logic [WIDTH-1:0] in1,
    input logic [WIDTH-1:0] in2,
    input logic czero,
    output logic [WIDTH-1:0] sum,
    output logic gpr,
    output logic ggn
);
    logic [WIDTH-1:0] pr;
    logic [WIDTH-1:0] gn;
    logic [WIDTH-2:0] cin;


    modport mfa_side(
        input in1, in2, czero, cin,
        output sum, pr, gn
    );

    modport cla_side(
        input pr,gn,czero,
        output cin, gpr, ggn
    );
endinterface

interface if_multiplier#(parameter WIDTH = 8)();
    logic [WIDTH-1:0] in1;
    logic [WIDTH-1:0] in2;
    
    logic [2*WIDTH:0] out;
    logic overflow;

    modport mul_side(
        input in1, in2,
        output overflow, out
    );

endinterface

interface if_cla_adder#(parameter WIDTH = 16)();
    logic [WIDTH-1:0] in1, in2;
    logic czero;
    logic [WIDTH-1:0] sum;
    logic cout;

    modport dut_side(
        input in1, in2, czero,
        output sum, cout
    );

    modport tb_side(
        input in1, in2, czero,
        input sum, cout
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


module f_cla_4(
    input logic [3:0]gn,pr,
    input logic czero,
    output logic [2:0] cin, 
    output gpr, ggn
);
        assign gpr = & (pr) ;
        assign ggn = gn[3] | (pr[3] & gn[2]) | (pr[3] & pr[2] & gn[1]) | (pr[3] & pr[2] & pr[1] & gn[0]); 
        assign cin[0] = gn[0] | ( pr[0] & czero);
        assign cin[1] = gn[1] | ( pr[1] & (gn[0] | ( pr[0] & czero)));
        assign cin[2] = gn[2] | ( pr[2] & (gn[1] | ( pr[1] & (gn[0] | ( pr[0] & czero))) ));
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


module f_cla_16#(parameter WIDTH=16)(if_cla_adder.dut_side fclif);
    logic [(WIDTH/4)-1:0] gpr, ggn;
    logic [(WIDTH/4)-2:0] icout;
    logic fgpr, fggn;

    if_mfa_cla#(.WIDTH(4)) if_mfa_cla_inst1(.in1(fclif.in1[3:0]), .in2(fclif.in2[3:0]),.czero(fclif.czero), .sum(fclif.sum[3:0]),.gpr(gpr[0]),.ggn(ggn[0]) );
    //$display("\n sum[3:0] = %b",fclif.sum[3:0]);
    cla_4 cla_inst1(.clif(if_mfa_cla_inst1));
    mfa#(.WIDTH(4)) mfa_inst1(.mif(if_mfa_cla_inst1));

    if_mfa_cla#(.WIDTH(4)) if_mfa_cla_inst2(.in1(fclif.in1[7:4]), .in2(fclif.in2[7:4]),.czero(icout[0]), .sum(fclif.sum[7:4]),.gpr(gpr[1]),.ggn(ggn[1]) );
    cla_4 cla_inst2(.clif(if_mfa_cla_inst2));
    mfa#(.WIDTH(4)) mfa_inst2(.mif(if_mfa_cla_inst2));

    if_mfa_cla#(.WIDTH(4)) if_mfa_cla_inst3(.in1(fclif.in1[11:8]), .in2(fclif.in2[11:8]),.czero(icout[1]), .sum(fclif.sum[11:8]),.gpr(gpr[2]),.ggn(ggn[2]) );
    cla_4 cla_inst3(.clif(if_mfa_cla_inst3));
    mfa#(.WIDTH(4)) mfa_inst3(.mif(if_mfa_cla_inst3));

    if_mfa_cla#(.WIDTH(4)) if_mfa_cla_inst4(.in1(fclif.in1[15:12]), .in2(fclif.in2[15:12]),.czero(icout[2]), .sum(fclif.sum[15:12]),.gpr(gpr[3]),.ggn(ggn[3]) );
    cla_4 cla_inst4(.clif(if_mfa_cla_inst4));
    mfa#(.WIDTH(4)) mfa_inst4(.mif(if_mfa_cla_inst4));

    
    f_cla_4 cla_inst_f( .gn(ggn),.pr(gpr),.czero(fclif.czero),.cin(icout),.gpr(fgpr),.ggn(fggn));

    //mfa#(.WIDTH(4)) mfa_inst_f(.mif(if_mfa_cla_inst_f));
    assign fclif.cout = (fclif.czero & fgpr) | fggn;
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

// create module for Approximate Full Adder
// What type of approximate FA -> We have to decide

module dadda_8#(parameter WIDTH = 8)(if_multiplier.mul_side muif);
    logic [0:WIDTH-1][WIDTH-1:0] pp_out;
    partial_product#(.WIDTH(WIDTH)) pp_inst(.in1(muif.in1),.in2(muif.in2),.out(pp_out));
    //  Instantiate given HA, FA blocks to generate different stages 
    // 
endmodule


// module dadda_16

// module dadda_32

// module dadda#(parameter WIDTH=8)

module approx1_dadda_8#(parameter WIDTH = 8)(if_multiplier.mul_side muif);
    logic [0:WIDTH-1][WIDTH-1:0] pp_out;
    partial_product#(.WIDTH(WIDTH)) pp_inst(.in1(muif.in1),.in2(muif.in2),.out(pp_out));
    //  Instantiate given HA, FA blocks to generate different stages 
    // 
endmodule

// Each approximate dadda will have different config of approx FA for different stages and also
// vary in span of the LSB

/*
// 
module app_adder#(parameter WIDTH = 4)(input logic [WIDTH-1:0] in_array, 
                                        output logic  [WIDTH-1:0] out);

endmodule
*/