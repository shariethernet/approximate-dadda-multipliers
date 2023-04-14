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

// Based off of https://ieeexplore.ieee.org/document/8843644
module App_FA1(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&b) | cin;
    assign sum = cout;
endmodule

module App_FA2(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&cin) | b;
    assign sum = cout;
endmodule

module App_FA3(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&b) ^ cin;
    assign sum = cout;
endmodule

module App_FA4(
    input wire a, 
    input wire b, 
    input wire cin,
    output wire sum,
    output wire cout
);
    assign cout = (a&b) | (b&cin) | (cin&a);
    assign sum = cout;
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



module dadda_8#(parameter WIDTH = 8)(if_multiplier.mul_side muif);
    logic [0:WIDTH-1][WIDTH-1:0] pp_out;
    partial_product#(.WIDTH(WIDTH)) pp_inst(.in1(muif.in1),.in2(muif.in2),.out(pp_out));
    //  Instantiate given HA, FA blocks to generate different stages 
    // stage 1 sum and carry 3 FA and 3 HA adders
    HA S1_HA1(pp_out[0][5], pp_out[1][4], st1out1, st1cout1);
    FA S1_FA1(pp_out[0][6], pp_out[1][5], pp_out[2][4], st1out2, st1cout2);
    HA S1_HA2(pp_out[3][3], pp_out[4][2], st1out5, st1cout5);
    FA S1_FA2(pp_out[0][7], pp_out[1][6], pp_out[2][5], st1out3, st1cout3);
    HA S1_HA3(pp_out[3][4], pp_out[4][3], st1out6, st1cout6);
    FA S1_FA3(pp_out[1][7], pp_out[2][6], pp_out[3][5], st1out4, st1cout4);

    // Stage 2
    HA S2_HA1(pp_out[0][4], pp_out[1][3], st2out1, st2cout1);
    HA S2_HA2(pp_out[0][5], pp_out[1][4], st2out2, st2cout2);
    FA S2_FA1(st1out1, pp_out[2][4], pp_out[3][3], st2out3, st2cout3);
    FA S2_FA2(st1out2, st1cout1, st1out5, st2out4, st2cout4);
    FA S2_FA3(st1out3, st1cout2, st1out7, st2out5, st2cout5);
    FA S2_FA4(st1out4, st1cout3, pp_out[5][4], st2out6, st2cout6);
    FA S2_FA5(pp_out[3][7], pp_out[4][6], st1cout4, st2out7, st2cout7);
    FA S2_FA6(pp_out[4][7], pp_out[5][6], pp_out[6][5], st2out8, st2cout8);
    
    FA S2_FA7(pp_out[2][3], pp_out[3][2], pp_out[4][1], st2out9, st2cout9);
    FA S2_FA8(pp_out[4][2], pp_out[5][1], pp_out[6][0], st2out10, st2cout10);
    FA S2_FA9(pp_out[5][2], pp_out[6][1], pp_out[7][0], st2out11, st2cout11);
    FA S2_FA10(pp_out[6][2], pp_out[7][1], st1cout5, st2out12, st2cout12);
    FA S2_FA11(pp_out[6][3], pp_out[7][2], st1cout6, st2out13, st2cout13);
    FA S2_FA12(pp_out[5][5], pp_out[6][4], pp_out[7][3], st2out14, st2cout14);

    // Stage 3
    HA S3_HA1(pp_out[0][3], pp_out[1][2], st3out1, st3cout1);
    FA S3_FA1(st2out1, pp_out[2][2], pp_out[3][1], st3out2, st3cout2);
    FA S3_FA2(st2out2, st2cout1, st2out9, st3out3, st3cout3);
    FA S3_FA3(st2out3, st2cout2, st2out10, st3out4, st3cout4);
    FA S3_FA4(st2out4, st2cout3, st2out11, st3out5, st3cout5);
    FA S3_FA5(st2out5, st2cout4, st2out12, st3out6, st3cout6);
    FA S3_FA6(st2out6, st2cout5, st2out13, st3out7, st3cout7);
    FA S3_FA7(st2out7, st2cout6, st2out14, st3out8, st3cout8);
    FA S3_FA8(st2out8, st2cout7, pp_out[7][4], st3out9, st3cout9);
    FA S3_FA9(pp_out[5][7], st2cout8, pp_out[6][6], st3out10, st3cout10);

    // Stage 4
    HA S4_HA1(pp_out[0][2], pp_out[1][1], st4out1, st4cout1);
    FA S4_FA1(st3out1, pp_out[2][1], pp_out[1][0], st4out2, st4cout1);
    FA S4_FA2(st3out2, st3cout1, pp_out[4][0], st4out3, st4cout3);
    FA S4_FA3(st3out3, st3cout2, pp_out[5][0], st4out4, st4cout4);
    FA S4_FA4(st3out4, st3cout3, st2cout9, st4out5, st4cout5);
    FA S4_FA5(st3out5, st3cout4, st2cout10, st4out6, st4cout6);
    FA S4_FA6(st3out6, st3cout5, st2cout11, st4out7, st4cout7);
    FA S4_FA7(st3out7, st3cout6, st2cout12, st4out8, st4cout8);
    FA S4_FA8(st3out8, st3cout7, st2cout13, st4out9, st4cout9);
    FA S4_FA9(st3out9, st3cout8, st2cout14, st4out10, st4cout10);
    FA S4_FA10(st3out10, st3cout9, pp_out[7][5], st4out11, st4cout11);
    FA S4_FA10(pp_out[6][7], st3cout10, pp_out[7][6], st4out12, st4cout12);

    // 14 bit CLA
    parameter CLA_WIDTH = 16;
    logic [CLA_WIDTH-1:0] in1;
    logic [CLA_WIDTH-1:0] in2;
    logic czero;

    assign in1[CLA_WIDTH-1] = 0'b0; 
    assign in1[CLA_WIDTH-2] = 0'b0; 
    assign in1[CLA_WIDTH-3] = pp_out[7][7]; 
    assign in1[CLA_WIDTH-4] = st4out12;
    assign in1[CLA_WIDTH-5] = st4out11;
    assign in1[CLA_WIDTH-6] = st4out10;
    assign in1[CLA_WIDTH-7] = st4out9;
    assign in1[CLA_WIDTH-8] = st4out8;
    assign in1[CLA_WIDTH-9] = st4out7;
    assign in1[CLA_WIDTH-10] = st4out6;
    assign in1[CLA_WIDTH-11] = st4out5;
    assign in1[CLA_WIDTH-13] = st4out4;
    assign in1[CLA_WIDTH-13] = st4out3;
    assign in1[CLA_WIDTH-14] = st4out2;
    assign in1[CLA_WIDTH-15] = st4out1;
    assign in1[CLA_WIDTH-16] = pp_out[0][1];


    assign in2[CLA_WIDTH-1] = 0'b0; 
    assign in2[CLA_WIDTH-2] = 0'b0; 
    assign in2[CLA_WIDTH-3] = st4cout12; 
    assign in2[CLA_WIDTH-4] = st4cout11;
    assign in2[CLA_WIDTH-5] = st4cout10;
    assign in2[CLA_WIDTH-6] = st4cout9;
    assign in2[CLA_WIDTH-7] = st4cout8;
    assign in2[CLA_WIDTH-8] = st4cout7;
    assign in2[CLA_WIDTH-9] = st4cout6;
    assign in2[CLA_WIDTH-10] = st4cout5;
    assign in2[CLA_WIDTH-11] = st4cout4;
    assign in2[CLA_WIDTH-12] = st4cout3;
    assign in2[CLA_WIDTH-13] = st4cout2;
    assign in2[CLA_WIDTH-14] = st4cout1;
    assign in2[CLA_WIDTH-15] = pp_out[2][0];
    assign in2[CLA_WIDTH-16] = pp_out[1][0];

    if_cla_adder#(16) if_cla_adder_inst(.in1(in1), .in2(in2),.czero(czero), .sum(muif.out), .cout(muif.overflow));

    f_cla_16 uut(.fclif(if_cla_adder_inst));
    
endmodule