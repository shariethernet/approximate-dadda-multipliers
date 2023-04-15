
module dadda_6#(parameter WIDTH = 6)(if_multiplier.mul_side muif);
    logic [0:WIDTH-1][WIDTH-1:0] pp_out;
    partial_product#(.WIDTH(WIDTH)) pp_inst(.in1(muif.in1),.in2(muif.in2),.out(pp_out));
    //  Instantiate given HA, FA blocks to generate different stages 
    // stage 1 sum and carry 2 HA adders
    HA S1_HA1(pp_out[0][4], pp_out[1][3], st1out1, st1cout1);
    FA S1_FA1(pp_out[0][5], pp_out[1][4], pp_out[2][3], st1out2, st1cout2);
    FA S1_FA2(pp_out[1][5], pp_out[2][4], pp_out[3][3], st1out3, st1cout3);
    FA S1_FA3(pp_out[2][5], pp_out[3][4], pp_out[4][3], st1out4, st1cout4);

    HA S1_HA2(pp_out[3][2], pp_out[4][1], st1out5, st1cout5);
    HA S1_HA3(pp_out[4][2], pp_out[3][1], st1out6, st1cout6);

    // Stage 2
    HA S2_HA1(pp_out[0][3], pp_out[1][2], st2out1, st2cout1);
    FA S2_FA1(st1out1, pp_out[2][2], pp_out[3][1], st2out2, st2cout2);
    FA S2_FA2(st1out2, st2cout1, st1out5, st2out3, st2cout3);
    FA S2_FA3(st1out3, st2cout2, st1out6, st2out4, st2cout4);
    FA S2_FA4(st1out4, st2cout3, pp_out[5][2], st2out5, st2cout5);
    FA S2_FA5(pp_out[4][5], st2cout4, pp_out[5][4], st2out6, st2cout6);

    // Stage 3
    HA S3_HA1(pp_out[0][2], pp_out[1][1], st3out1, st3cout1);
    FA S3_FA1(st1out1, pp_out[2][1], pp_out[3][0], st3out2, st3cout2);
    FA S3_FA2(st1out2, st1cout1, pp_out[4][0], st3out3, st3cout3);
    FA S3_FA3(st1out3, st1cout2, pp_out[5][0], st3out4, st3cout4);
    FA S3_FA4(st1out4, st1cout3, st1cout5, st3out5, st3cout5);
    FA S3_FA5(st1out5, st1cout4, st1cout6, st3out6, st3cout6);
    FA S3_FA6(st1out6, st1cout5, pp_out[5][3], st3out7, st3cout7);
    FA S3_FA7(pp_out[4][5], st1cout6, pp_out[5][4], st3out8, st3cout8);
    
    parameter CLA_WIDTH = 11;
    wire [CLA_WIDTH-1:0] in1;
    wire [CLA_WIDTH-1:0] in2;
    wire czero = 0;
    wire [CLA_WIDTH-1:0] out;
    wire cout1;

    assign in1[CLA_WIDTH-1] = pp_out[7][7]
    assign in1[CLA_WIDTH-2] = st3out1;
    assign in1[CLA_WIDTH-3] = st3out2;
    assign in1[CLA_WIDTH-4] = st3out3;
    assign in1[CLA_WIDTH-5] = st3out4;
    assign in1[CLA_WIDTH-6] = st3out5;
    assign in1[CLA_WIDTH-7] = st3out6;
    assign in1[CLA_WIDTH-8] = st3out7;
    assign in1[CLA_WIDTH-9] = st3out8;
    assign in1[CLA_WIDTH-10] = pp_out[0][1];
    assign in1[CLA_WIDTH-11] = pp_out[0][0];

    assign in2[CLA_WIDTH-1] = st3cout8; 
    assign in2[CLA_WIDTH-2] = st3cout7; 
    assign in2[CLA_WIDTH-3] = st3cout6;
    assign in2[CLA_WIDTH-4] = st3cout5;
    assign in2[CLA_WIDTH-5] = st3cout4;
    assign in2[CLA_WIDTH-6] = st3cout3;
    assign in2[CLA_WIDTH-7] = st3cout2;
    assign in2[CLA_WIDTH-8] = st3cout1;
    assign in2[CLA_WIDTH-9] = pp_out[2][0];
    assign in2[CLA_WIDTH-10] = pp_out[1][0];
    assign in2[CLA_WIDTH-11] = 1'b0;

    wire zero;
    assign zero = 1'b0;
    cla_w#(.WIDTH(7)) cla_dut(.in1(in1),.in2(in2),.sum(muif.out),.czero(zero),.cout(zero));
    assign muif.overflow = zero;
    
endmodule