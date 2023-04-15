
module dadda_4#(parameter WIDTH = 4)(if_multiplier.mul_side muif);
    logic [0:WIDTH-1][WIDTH-1:0] pp_out;
    partial_product#(.WIDTH(WIDTH)) pp_inst(.in1(muif.in1),.in2(muif.in2),.out(pp_out));
    //  Instantiate given HA, FA blocks to generate different stages 
    // stage 1 sum and carry 2 HA adders
    HA S1_HA1(pp_out[0][3], pp_out[1][2], st1out1, st1cout1);
    HA S1_HA2(pp_out[1][3], pp_out[2][2], st1out2, st1cout2);


    // Stage 2
    HA S2_HA1(pp_out[0][2], pp_out[1][1], st2out1, st2cout1);
    FA S2_FA1(st1out1, pp_out[2][1], pp_out[3][0], st2out2, st2cout2);
    FA S2_FA2(st1out2, st2cout1, pp_out[3][1], st2out3, st2cout3);
    FA S2_FA3(pp_out[2][3], st2cout2, pp_out[3][2], st2out4, st2cout4);


    parameter CLA_WIDTH = 7;
    wire [CLA_WIDTH-1:0] in1;
    wire [CLA_WIDTH-1:0] in2;
    wire czero = 0;
    wire [CLA_WIDTH-1:0] out;
    wire cout1;

    assign in1[CLA_WIDTH-1] = pp_out[7][7];
    assign in1[CLA_WIDTH-2] = st2out1;
    assign in1[CLA_WIDTH-3] = st2out2;
    assign in1[CLA_WIDTH-4] = st2out3;
    assign in1[CLA_WIDTH-5] = st2out4;
    assign in1[CLA_WIDTH-6] = pp_out[0][1];
    assign in1[CLA_WIDTH-7] = pp_out[0][0];

    assign in2[CLA_WIDTH-1] = st2cout4; 
    assign in2[CLA_WIDTH-2] = st2cout3; 
    assign in2[CLA_WIDTH-3] = st2cout2;
    assign in2[CLA_WIDTH-4] = st2cout1;
    assign in2[CLA_WIDTH-5] = pp_out[2][0];
    assign in2[CLA_WIDTH-6] = pp_out[1][0];
    assign in2[CLA_WIDTH-7] = 1'b0;


    wire zero;
    assign zero = 1'b0;
    cla_w#(.WIDTH(7)) cla_dut(.in1(in1),.in2(in2),.sum(muif.out),.czero(zero),.cout(zero));
    assign muif.overflow = zero;
    
endmodule