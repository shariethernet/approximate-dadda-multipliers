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

module dadda_16#(parameter WIDTH = 16)(if_multiplier.mul_side muif);
    logic [WIDTH-1:0][WIDTH-1:0] pp;
    //  Instantiate given HA, FA blocks to generate different stages 
    
    genvar i,j ;
    for(i=0; i<WIDTH; i=i+1) begin 
        for(j=0; j<WIDTH; j = j+1 ) begin 
            assign pp[j][i] = in1[j] & in2[i];
        end
    end

    //stage 1 : 16 -> 13
    wire [11:0] s1;
    wire [11:0] c1;

    //13
    HA h1_0(.a(pp[13][0]), .b(pp[12][1]), .sum(s1[0]), .cout(c1[0]));

    //14
    HA h1_1(.a(pp[14][0]), .b(pp[13][1]), .sum(s1[1]), .cout(c1[1]));
    FA f1_2(.a(pp[12][2]), .b(pp[11][3]), .cin(pp[10][4]), .sum(s1[2]), .cout(c1[2]));

    //15
    HA h1_3(.a(pp[15][0]), .b(pp[14][1]), .sum(s1[3]), .cout(c1[3]));
    FA f1_4(.a(pp[13][2]), .b(pp[12][3]), .cin(pp[11][4]), .sum(s1[4]), .cout(c1[4]));
    FA f1_5(.a(pp[10][5]), .b(pp[9][6]), .cin(pp[8][7]), .sum(s1[5]), .cout(c1[5]));

    //16
    HA h1_6(.a(pp[15][1]), .b(pp[14][2]), .sum(s1[6]), .cout(c1[6]));
    FA f1_7(.a(pp[13][3]), .b(pp[12][4]), .cin(pp[11][5]), .sum(s1[7]), .cout(c1[7]));
    FA f1_8(.a(pp[10][6]), .b(pp[9][7]), .cin(pp[8][8]), .sum(s1[8]), .cout(c1[8]));

    //17
    FA f1_9(.a(pp[15][2]), .b(pp[14][3]), .cin(pp[13][4]), .sum(s1[9]), .cout(c1[9]));
    FA f1_10(.a(pp[12][5]), .b(pp[11][6]), .cin(pp[10][7]), .sum(s1[10]), .cout(c1[10]));

    //18
    FA f1_11(.a(pp[15][3]), .b(pp[14][4]), .cin(pp[13][5]), .sum(s1[11]), .cout(c1[11]));

    //stage 2 : 9
    wire [43:0] s2;
    wire [43:0] c2;

    //cloumn  9
    HA ha2_0(.a(pp[9][0]), .b(pp[8][1]), .sum(s2[0]), .cout(c2[0]));

    //10
    HA ha2_1(.a(pp[10][0]), .b(pp[9][1]), .sum(s2[1]), .cout(c2[1]));
    FA fa2_2(.a(pp[8][2]), .b(pp[7][3]), .cin(pp[6][4]), .sum(s2[2]), .cout(c2[2]));

    //11
    HA ha2_3(.a(pp[11][0]), .b(pp[10][1]), .sum(s2[3]), .cout(c2[3]));
    FA fa2_4(.a(pp[9][2]), .b(pp[8][3]), .cin(pp[7][4]), .sum(s2[4]), .cout(c2[4]));
    FA fa2_5(.a(pp[6][5]), .b(pp[5][6]), .cin(pp[4][7]), .sum(s2[5]), .cout(c2[5]));
    
    //12
    HA ha2_6(.a(pp[12][0]), .b(pp[11][1]), .sum(s2[6]), .cout(c2[6]));
    FA fa2_7(.a(pp[10][2]), .b(pp[9][3]), .cin(pp[8][4]), .sum(s2[7]), .cout(c2[7]));
    FA fa2_8(.a(pp[7][5]), .b(pp[6][6]), .cin(pp[5][7]), .sum(s2[8]), .cout(c2[8]));
    FA fa2_9(.a(pp[4][8]), .b(pp[3][9]), .cin(pp[2][10]), .sum(s2[9]), .cout(c2[9]));

    //13
    FA fa2_10(.a(s1[0]), .b(pp[11][2]), .cin(pp[10][3]), .sum(s2[10]), .cout(c2[10]));
    FA fa2_11(.a(pp[9][4]), .b(pp[8][5]), .cin(pp[7][6]), .sum(s2[11]), .cout(c2[11]));
    FA fa2_12(.a(pp[6][7]), .b(pp[5][8]), .cin(pp[4][9]), .sum(s2[12]), .cout(c2[12]));
    FA fa2_13(.a(pp[3][10]), .b(pp[2][11]), .cin(pp[1][12]), .sum(s2[13]), .cout(c2[13]));

    //14
    FA fa2_14(.a(s1[1]), .b(s1[2]), .cin(c1[0]), .sum(s2[14]), .cout(c2[14]));
    FA fa2_15(.a(pp[9][5]), .b(pp[8][6]), .cin(pp[7][7]), .sum(s2[15]), .cout(c2[15]));
    FA fa2_16(.a(pp[6][8]), .b(pp[5][9]), .cin(pp[4][10]), .sum(s2[16]), .cout(c2[16]));
    FA fa2_17(.a(pp[3][11]), .b(pp[2][12]), .cin(pp[1][13]), .sum(s2[17]), .cout(c2[17]));  

    //15
    FA fa2_18(.a(s1[3]), .b(s1[4]), .cin(c1[1]), .sum(s2[18]), .cout(c2[18]));
    FA fa2_19(.a(c1[2]), .b(s1[5]), .cin(pp[7][8]), .sum(s2[19]), .cout(c2[19]));
    FA fa2_20(.a(pp[6][9]), .b(pp[5][10]), .cin(pp[4][11]), .sum(s2[20]), .cout(c2[20]));
    FA fa2_21(.a(pp[3][12]), .b(pp[2][13]), .cin(pp[1][14]), .sum(s2[21]), .cout(c2[21]));

    //16
    FA fa2_22(.a(s1[6]), .b(s1[7]), .cin(c1[3]), .sum(s2[22]), .cout(c2[22]));
    FA fa2_23(.a(s1[8]), .b(c1[4]), .cin(c1[5]), .sum(s2[23]), .cout(c2[23]));
    FA fa2_24(.a(pp[7][9]), .b(pp[6][10]), .cin(pp[5][11]), .sum(s2[24]), .cout(c2[24]));
    FA fa2_25(.a(pp[4][12]), .b(pp[3][13]), .cin(pp[2][14]), .sum(s2[25]), .cout(c2[25]));

    //17
    FA fa2_26(.a(s1[9]), .b(s1[10]), .cin(c1[6]), .sum(s2[26]), .cout(c2[26]));
    FA fa2_27(.a(c1[7]), .b(pp[9][10]), .cin(c1[8]), .sum(s2[27]), .cout(c2[27]));
    FA fa2_28(.a(pp[8][11]), .b(pp[7][12]), .cin(pp[6][13]), .sum(s2[28]), .cout(c2[28]));
    FA fa2_29(.a(pp[5][14]), .b(pp[4][15]), .cin(pp[3][16]), .sum(s2[29]), .cout(c2[29]));

    //18
    FA fa2_30(.a(s1[11]), .b(c1[9]), .cin(c1[10]), .sum(s2[30]), .cout(c2[30]));
    FA fa2_31(.a(pp[12][6]), .b(pp[11][7]), .cin(pp[10][8]), .sum(s2[31]), .cout(c2[31]));
    FA fa2_32(.a(pp[9][9]), .b(pp[8][10]), .cin(pp[7][11]), .sum(s2[32]), .cout(c2[32]));
    FA fa2_33(.a(pp[6][12]), .b(pp[5][13]), .cin(pp[4][14]), .sum(s2[33]), .cout(c2[33]));

    //19
    FA fa2_34(.a(c1[11]), .b(pp[15][4]), .cin(pp[14][5]), .sum(s2[34]), .cout(c2[34]));
    FA fa2_35(.a(pp[13][6]), .b(pp[12][7]), .cin(pp[11][8]), .sum(s2[35]), .cout(c2[35]));
    FA fa2_36(.a(pp[10][9]), .b(pp[9][10]), .cin(pp[8][11]), .sum(s2[36]), .cout(c2[36]));
    FA fa2_37(.a(pp[7][12]), .b(pp[6][13]), .cin(pp[5][14]), .sum(s2[37]), .cout(c2[37]));

    //20
    FA fa2_38(.a(pp[15][5]), .b(pp[14][6]), .cin(pp[13][7]), .sum(s2[38]), .cout(c2[38]));
    FA fa2_39(.a(pp[12][8]), .b(pp[11][9]), .cin(pp[10][10]), .sum(s2[39]), .cout(c2[39]));
    FA fa2_40(.a(pp[9][11]), .b(pp[8][12]), .cin(pp[7][13]), .sum(s2[40]), .cout(c2[40]));

    //21
    FA fa2_41(.a(pp[15][6]), .b(pp[14][7]), .cin(pp[13][8]), .sum(s2[41]), .cout(c2[41]));
    FA fa2_42(.a(pp[12][9]), .b(pp[11][10]), .cin(pp[10][11]), .sum(s2[42]), .cout(c2[42]));

    //22
    FA fa2_43(.a(pp[15][7]), .b(pp[14][8]), .cin(pp[13][9]), .sum(s2[43]), .cout(c2[43]));

    //stage 3 : 6
    wire [53:0] s3;
    wire [53:0] c3;

    //cloumn 6
    HA ha3_0(.a(pp[6][0]), .b(pp[5][1]), .sum(s3[0]), .cout(c3[0]));

    //cloumn 7
    HA ha3_1(.a(pp[7][0]), .b(pp[6][1]), .sum(s3[1]), .cout(c3[1]));
    FA fa3_2(.a(pp[5][2]), .b(pp[4][3]), .cin(pp[3][4]), .sum(s3[2]), .cout(c3[2]));

    //cloumn 8
    HA ha3_3(.a(pp[8][0]), .b(pp[7][1]), .sum(s3[3]), .cout(c3[3]));
    FA fa3_4(.a(pp[6][2]), .b(pp[5][3]), .cin(pp[4][4]), .sum(s3[4]), .cout(c3[4]));
    FA fa3_5(.a(pp[3][5]), .b(pp[2][6]), .cin(pp[1][7]), .sum(s3[5]), .cout(c3[5]));

    //cloumn 9
    FA fa3_6(.a(s2[0]), .b(pp[7][2]), .cin(pp[6][3]), .sum(s3[6]), .cout(c3[6]));
    FA fa3_7(.a(pp[5][4]), .b(pp[4][5]), .cin(pp[3][6]), .sum(s3[7]), .cout(c3[7]));
    FA fa3_8(.a(pp[2][7]), .b(pp[1][8]), .cin(pp[0][9]), .sum(s3[8]), .cout(c3[8]));

    //cloumn 10
    FA fa3_9(.a(s2[1]), .b(c2[0]), .cin(s2[2]) , .sum(s3[9]), .cout(c3[9]));
    FA fa3_10(.a(pp[5][5]), .b(pp[4][6]), .cin(pp[3][7]), .sum(s3[10]), .cout(c3[10]));
    FA fa3_11(.a(pp[2][8]), .b(pp[1][9]), .cin(pp[0][10]), .sum(s3[11]), .cout(c3[11]));

    // cloumn 11
    FA fa3_12(.a(s2[3]), .b(c2[1]), .cin(s2[4]), .sum(s3[12]), .cout(c3[12]));
    FA fa3_13(.a(c2[2]), .b(s2[5]), .cin(pp[3][8]), .sum(s3[13]), .cout(c3[13]));
    FA fa3_14(.a(pp[2][9]), .b(pp[1][10]), .cin(pp[0][11]), .sum(s3[14]), .cout(c3[14]));

    //cloumn 12
    FA fa3_15(.a(s2[6]), .b(c2[3]), .cin(s2[7]), .sum(s3[15]), .cout(c3[15]));
    FA fa3_16(.a(c2[4]), .b(s2[8]), .cin(c2[5]), .sum(s3[16]), .cout(c3[16]));
    FA fa3_17(.a(s2[9]), .b(pp[1][11]), .cin(pp[0][12]), .sum(s3[17]), .cout(c3[17]));

    //cloumn 13
    FA fa3_18(.a(s2[10]), .b(c2[6]), .cin(s2[11]), .sum(s3[18]), .cout(c3[18]));
    FA fa3_19(.a(c2[7]), .b(s2[12]), .cin(c2[8]), .sum(s3[19]), .cout(c3[19]));
    FA fa3_20(.a(s2[13]), .b(c2[9]), .cin(pp[0][13]), .sum(s3[20]), .cout(c3[20]));

    //cloumn 14
    FA fa3_21(.a(s2[14]), .b(c2[10]), .cin(s2[15]), .sum(s3[21]), .cout(c3[21]));
    FA fa3_22(.a(c2[11]), .b(s2[16]), .cin(c2[12]), .sum(s3[22]), .cout(c3[22]));
    FA fa3_23(.a(s2[17]), .b(c2[13]), .cin(pp[0][14]), .sum(s3[23]), .cout(c3[23]));

    //cloumn 15
    FA fa3_24(.a(s2[18]), .b(c2[14]), .cin(s2[19]), .sum(s3[24]), .cout(c3[24]));
    FA fa3_25(.a(c2[15]), .b(s2[20]), .cin(c2[16]), .sum(s3[25]), .cout(c3[25]));
    FA fa3_26(.a(s2[21]), .b(c2[17]), .cin(pp[0][15]), .sum(s3[26]), .cout(c3[26]));

    //cloumn 16
    FA fa3_27(.a(s2[22]), .b(c2[18]), .cin(s2[23]), .sum(s3[27]), .cout(c3[27]));
    FA fa3_28(.a(c2[19]), .b(s2[24]), .cin(c2[20]), .sum(s3[28]), .cout(c3[28]));
    FA fa3_29(.a(s2[25]), .b(c2[21]), .cin(pp[1][15]), .sum(s3[29]), .cout(c3[29]));

    //cloumn 17
    FA fa3_30(.a(s2[26]), .b(c2[22]), .cin(s2[27]), .sum(s3[30]), .cout(c3[30]));
    FA fa3_31(.a(c2[23]), .b(s2[28]), .cin(c2[24]), .sum(s3[31]), .cout(c3[31]));
    FA fa3_32(.a(s2[29]), .b(c2[25]), .cin(pp[2][15]), .sum(s3[32]), .cout(c3[32]));

    //cloumn 18
    FA fa3_33(.a(s2[30]), .b(c2[26]), .cin(s2[31]), .sum(s3[33]), .cout(c3[33]));
    FA fa3_34(.a(c2[27]), .b(s2[32]), .cin(c2[28]), .sum(s3[34]), .cout(c3[34]));
    FA fa3_35(.a(s2[33]), .b(c2[29]), .cin(pp[3][15]), .sum(s3[35]), .cout(c3[35]));

    //cloumn 19
    FA fa3_36(.a(s2[34]), .b(c2[30]), .cin(s2[35]), .sum(s3[36]), .cout(c3[36]));
    FA fa3_37(.a(c2[31]), .b(s2[36]), .cin(c2[32]), .sum(s3[37]), .cout(c3[37]));
    FA fa3_38(.a(s2[37]), .b(c2[33]), .cin(pp[4][15]), .sum(s3[38]), .cout(c3[38]));

    //cloumn 20
    FA fa3_39(.a(s2[38]), .b(c2[34]), .cin(s2[39]), .sum(s3[39]), .cout(c3[39]));
    FA fa3_40(.a(c2[35]), .b(s2[40]), .cin(c2[36]), .sum(s3[40]), .cout(c3[40]));
    FA fa3_41(.a(pp[6][14]), .b(c2[37]), .cin(pp[5][15]), .sum(s3[41]), .cout(c3[41]));

    //cloumn 21
    FA fa3_42(.a(s2[41]), .b(c2[38]), .cin(s2[42]), .sum(s3[42]), .cout(c3[42]));
    FA fa3_43(.a(c2[39]), .b(pp[9][12]), .cin(c2[40]), .sum(s3[43]), .cout(c3[43]));
    FA fa3_44(.a(pp[8][13]), .b(pp[7][14]), .cin(pp[6][15]), .sum(s3[44]), .cout(c3[44]));

    //cloumn 22
    FA fa3_45(.a(s2[43]), .b(c2[41]), .cin(pp[12][10]), .sum(s3[45]), .cout(c3[45]));
    FA fa3_46(.a(c2[42]), .b(pp[11][11]), .cin(pp[10][12]), .sum(s3[46]), .cout(c3[46]));
    FA fa3_47(.a(pp[9][13]), .b(pp[8][14]), .cin(pp[7][15]), .sum(s3[47]), .cout(c3[47]));

    //cloumn 23
    FA fa3_48(.a(pp[15][8]), .b(c2[43]), .cin(pp[14][9]), .sum(s3[48]), .cout(c3[48]));
    FA fa3_49(.a(pp[13][10]), .b(pp[12][11]), .cin(pp[11][12]), .sum(s3[49]), .cout(c3[49]));
    FA fa3_50(.a(pp[10][13]), .b(pp[9][14]), .cin(pp[8][15]), .sum(s3[50]), .cout(c3[50]));

    //cloumn 24
    FA fa3_51(.a(pp[15][9]), .b(pp[14][10]), .cin(pp[13][11]), .sum(s3[51]), .cout(c3[51]));
    FA fa3_52(.a(pp[12][12]), .b(pp[11][13]), .cin(pp[10][14]), .sum(s3[52]), .cout(c3[52]));

    //cloumn 25
    FA fa3_53(.a(pp[15][10]), .b(pp[14][11]), .cin(pp[13][12]), .sum(s3[53]), .cout(c3[53]));

    //stage 4 : 4
    wire [45 :0] s4;
    wire [45 :0] c4;

    //column 4
    HA ha4_0(.a(pp[4][0]), .b(pp[3][1]), .sum(s4[0]), .cout(c4[0]));

    //column 5
    HA ha4_1(.a(pp[5][0]), .b(pp[4][1]), .sum(s4[1]), .cout(c4[1]));
    FA fa4_2(.a(pp[3][2]), .b(pp[2][3]), .cin(pp[1][4]), .sum(s4[2]), .cout(c4[2]));

    //column 6
    FA fa4_3(.a(s3[0]), .b(pp[4][2]), .cin(pp[3][3]), .sum(s4[3]), .cout(c4[3]));
    FA fa4_4(.a(pp[2][4]), .b(pp[1][5]), .cin(pp[0][6]), .sum(s4[4]), .cout(c4[4]));

    //column 7
    FA fa4_5(.a(s3[1]), .b(c3[0]), .cin(s3[2]), .sum(s4[5]), .cout(c4[5]));
    FA fa4_6(.a(pp[2][5]), .b(pp[1][6]), .cin(pp[0][7]), .sum(s4[6]), .cout(c4[6]));

    //column 8
    FA fa4_7(.a(s3[3]), .b(c3[1]), .cin(s3[4]), .sum(s4[7]), .cout(c4[7]));
    FA fa4_8(.a(c3[2]), .b(s3[5]), .cin(pp[8][0]), .sum(s4[8]), .cout(c4[8]));

    //column 9
    FA fa4_9(.a(s3[6]), .b(c3[3]), .cin(s3[7]), .sum(s4[9]), .cout(c4[9]));
    FA fa4_10(.a(c3[4]), .b(s3[8]), .cin(c3[5]), .sum(s4[10]), .cout(c4[10]));

    //column 10
    FA fa4_11(.a(s3[9]), .b(c3[6]), .cin(s3[10]), .sum(s4[11]), .cout(c4[11]));
    FA fa4_12(.a(c3[7]), .b(s3[11]), .cin(c3[8]), .sum(s4[12]), .cout(c4[12]));

    //column 11
    FA fa4_13(.a(s3[12]), .b(c3[9]), .cin(s3[13]), .sum(s4[13]), .cout(c4[13]));
    FA fa4_14(.a(c3[10]), .b(s3[14]), .cin(c3[11]), .sum(s4[14]), .cout(c4[14]));

    //column 12
    FA fa4_15(.a(s3[15]), .b(c3[12]), .cin(s3[16]), .sum(s4[15]), .cout(c4[15]));
    FA fa4_16(.a(c3[13]), .b(s3[17]), .cin(c3[14]), .sum(s4[16]), .cout(c4[16]));

    //column 13
    FA fa4_17(.a(s3[18]), .b(c3[15]), .cin(s3[19]), .sum(s4[17]), .cout(c4[17]));
    FA fa4_18(.a(c3[16]), .b(s3[20]), .cin(c3[17]), .sum(s4[18]), .cout(c4[18]));

    //column 14
    FA fa4_19(.a(s3[21]), .b(c3[18]), .cin(s3[22]), .sum(s4[19]), .cout(c4[19]));
    FA fa4_20(.a(c3[19]), .b(s3[23]), .cin(c3[20]), .sum(s4[20]), .cout(c4[20]));

    //column 15
    FA fa4_21(.a(s3[24]), .b(c3[21]), .cin(s3[25]), .sum(s4[21]), .cout(c4[21]));
    FA fa4_22(.a(c3[22]), .b(s3[26]), .cin(c3[23]), .sum(s4[22]), .cout(c4[22]));

    //column 16
    FA fa4_23(.a(s3[27]), .b(c3[24]), .cin(s3[28]), .sum(s4[23]), .cout(c4[23]));
    FA fa4_24(.a(c3[25]), .b(s3[29]), .cin(c3[26]), .sum(s4[24]), .cout(c4[24]));

    //column 17
    FA fa4_25(.a(s3[30]), .b(c3[27]), .cin(s3[31]), .sum(s4[25]), .cout(c4[25]));
    FA fa4_26(.a(c3[28]), .b(s3[32]), .cin(c3[29]), .sum(s4[26]), .cout(c4[26]));

    //column 18
    FA fa4_27(.a(s3[33]), .b(c3[30]), .cin(s3[34]), .sum(s4[27]), .cout(c4[27]));
    FA fa4_28(.a(c3[31]), .b(s3[35]), .cin(c3[32]), .sum(s4[28]), .cout(c4[28]));

    //19
    FA fa4_29(.a(s3[36]), .b(c3[33]), .cin(s3[37]), .sum(s4[29]), .cout(c4[29]));
    FA fa4_30(.a(c3[34]), .b(s3[38]), .cin(c3[35]), .sum(s4[30]), .cout(c4[30]));

    //20
    FA fa4_31(.a(s3[39]), .b(c3[36]), .cin(s3[40]), .sum(s4[31]), .cout(c4[31]));
    FA fa4_32(.a(c3[37]), .b(s3[41]), .cin(c3[38]), .sum(s4[32]), .cout(c4[32]));

    //21
    FA fa4_33(.a(s3[42]), .b(c3[39]), .cin(s3[43]), .sum(s4[33]), .cout(c4[33]));
    FA fa4_34(.a(c3[40]), .b(s3[44]), .cin(c3[41]), .sum(s4[34]), .cout(c4[34]));

    //22
    FA fa4_35(.a(s3[45]), .b(c3[42]), .cin(s3[46]), .sum(s4[35]), .cout(c4[35]));
    FA fa4_36(.a(c3[43]), .b(s3[47]), .cin(c3[44]), .sum(s4[36]), .cout(c4[36]));

    //23
    FA fa4_37(.a(s3[48]), .b(c3[45]), .cin(s3[49]), .sum(s4[37]), .cout(c4[37]));
    FA fa4_38(.a(c3[46]), .b(s3[50]), .cin(c3[47]), .sum(s4[38]), .cout(c4[38]));

    //24
    FA fa4_39(.a(s3[51]), .b(c3[48]), .cin(s3[52]), .sum(s4[39]), .cout(c4[39]));
    FA fa4_40(.a(c3[49]), .b(pp[9][15]), .cin(c3[50]), .sum(s4[40]), .cout(c4[40]));

    //25
    FA fa4_41(.a(s3[53]), .b(c3[51]), .cin(pp[12][13]), .sum(s4[41]), .cout(c4[41]));
    FA fa4_42(.a(c3[52]), .b(pp[11][14]), .cin(pp[10][15]), .sum(s4[42]), .cout(c4[42]));

    //26
    FA fa4_43(.a(pp[15][11]), .b(c3[53]), .cin(pp[14][12]), .sum(s4[43]), .cout(c4[43]));
    FA fa4_44(.a(pp[13][13]), .b(pp[12][14]), .cin(pp[11][15]), .sum(s4[44]), .cout(c4[44]));

    //27
    FA fa4_45(.a(pp[15][12]), .b(pp[14][13]), .cin(pp[13][14]), .sum(s4[45]), .cout(c4[45]));

    //stage 5 : 3

    wire [25:0] s5;
    wire [25:0] c5;

    //column 3
    HA ha5_0(.a(pp[3][0]), .b(pp[2][1]), .sum(s5[0]), .cout(c5[0]));
    //4
    FA fa3_1(.a(s4[0]), .b(pp[2][2]), .cin(pp[1][3]), .sum(s5[1]), .cout(c5[1]));
    //5
    FA fa3_2(.a(s4[1]), .b(c4[0]), .cin(s4[2]), .sum(s5[2]), .cout(c5[2]));
    //6
    FA fa3_3(.a(s4[3]), .b(c4[1]), .cin(s4[4]), .sum(s5[3]), .cout(c5[3]));
    //7
    FA fa3_4(.a(s4[5]), .b(c4[2]), .cin(s4[6]), .sum(s5[4]), .cout(c5[4]));
    //8
    FA fa3_5(.a(s4[7]), .b(c4[3]), .cin(s4[8]), .sum(s5[5]), .cout(c5[5]));
    //9
    FA fa3_6(.a(s4[9]), .b(c4[4]), .cin(s4[10]), .sum(s5[6]), .cout(c5[6]));
    //10
    FA fa3_7(.a(s4[11]), .b(c4[5]), .cin(s4[12]), .sum(s5[7]), .cout(c5[7]));
    //11
    FA fa3_8(.a(s4[13]), .b(c4[6]), .cin(s4[14]), .sum(s5[8]), .cout(c5[8]));
    //12
    FA fa3_9(.a(s4[15]), .b(c4[7]), .cin(s4[16]), .sum(s5[9]), .cout(c5[9]));
    //13
    FA fa3_10(.a(s4[17]), .b(c4[8]), .cin(s4[18]), .sum(s5[10]), .cout(c5[10]));
    //14
    FA fa3_11(.a(s4[19]), .b(c4[9]), .cin(s4[20]), .sum(s5[11]), .cout(c5[11]));
    //15
    FA fa3_12(.a(s4[21]), .b(c4[10]), .cin(s4[22]), .sum(s5[12]), .cout(c5[12]));
    //16
    FA fa3_13(.a(s4[23]), .b(c4[11]), .cin(s4[24]), .sum(s5[13]), .cout(c5[13]));
    //17
    FA fa3_14(.a(s4[25]), .b(c4[12]), .cin(s4[26]), .sum(s5[14]), .cout(c5[14]));
    //18
    FA fa3_15(.a(s4[27]), .b(c4[13]), .cin(s4[28]), .sum(s5[15]), .cout(c5[15]));
    //19
    FA fa3_16(.a(s4[29]), .b(c4[14]), .cin(s4[30]), .sum(s5[16]), .cout(c5[16]));
    //20
    FA fa3_17(.a(s4[31]), .b(c4[15]), .cin(s4[32]), .sum(s5[17]), .cout(c5[17]));
    //21
    FA fa3_18(.a(s4[33]), .b(c4[16]), .cin(s4[34]), .sum(s5[18]), .cout(c5[18]));
    //22
    FA fa3_19(.a(s4[35]), .b(c4[17]), .cin(s4[36]), .sum(s5[19]), .cout(c5[19]));
    //23
    FA fa3_20(.a(s4[37]), .b(c4[18]), .cin(s4[38]), .sum(s5[20]), .cout(c5[20]));
    //24
    FA fa3_21(.a(s4[39]), .b(c4[19]), .cin(s4[40]), .sum(s5[21]), .cout(c5[21]));
    //25
    FA fa3_22(.a(s4[41]), .b(c4[20]), .cin(s4[42]), .sum(s5[22]), .cout(c5[22]));
    //26
    FA fa3_23(.a(s4[43]), .b(c4[21]), .cin(s4[44]), .sum(s5[23]), .cout(c5[23]));
    //27
    FA fa3_24(.a(s4[45]), .b(c4[22]), .cin(pp[12][15]), .sum(s5[24]), .cout(c5[24]));
    //28
    FA fa3_25(.a(pp[15][13]), .b(c4[45]), .cin(pp[14][14]), .sum(s5[25]), .cout(c5[25]));

    //stage 6 : 2
    wire [27:0] s6;
    wire [27:0] c6;

    //column 2
    HA ha6_0 (.a(pp[2][0]), .b(pp[1][1]), .sum(s6[0]), .cout(c6[0]));
    //3
    FA fa2_1 (.a(s5[0]), .b(pp[1][2]), .cin(pp[0][3]), .sum(s6[1]), .cout(c6[1]));
    //4
    FA fa2_2 (.a(s5[1]), .b(c5[0]), .cin(pp[0][4]), .sum(s6[2]), .cout(c6[2]));
    //5
    FA fa2_3 (.a(s5[2]), .b(c5[1]), .cin(pp[0][5]), .sum(s6[3]), .cout(c6[3]));
    //6
    FA fa2_4 (.a(s5[3]), .b(c5[2]), .cin(c4[2]), .sum(s6[4]), .cout(c6[4]));
    //7
    FA fa2_5 (.a(s5[4]), .b(c5[3]), .cin(c4[4]), .sum(s6[5]), .cout(c6[5]));
    //8
    FA fa2_6 (.a(s5[5]), .b(c5[4]), .cin(c4[6]), .sum(s6[6]), .cout(c6[6]));
    //9
    FA fa2_7 (.a(s5[6]), .b(c5[5]), .cin(c4[8]), .sum(s6[7]), .cout(c6[7]));
    //10
    FA fa2_8 (.a(s5[7]), .b(c5[6]), .cin(c4[10]), .sum(s6[8]), .cout(c6[8]));
    //11
    FA fa2_9 (.a(s5[8]), .b(c5[7]), .cin(c4[12]), .sum(s6[9]), .cout(c6[9]));
    //12
    FA fa2_10 (.a(s5[9]), .b(c5[8]), .cin(c4[14]), .sum(s6[10]), .cout(c6[10]));
    //13
    FA fa2_11 (.a(s5[10]), .b(c5[9]), .cin(c4[16]), .sum(s6[11]), .cout(c6[11]));
    //14
    FA fa2_12 (.a(s5[11]), .b(c5[10]), .cin(c4[18]), .sum(s6[12]), .cout(c6[12]));
    //15
    FA fa2_13 (.a(s5[12]), .b(c5[11]), .cin(c4[20]), .sum(s6[13]), .cout(c6[13]));
    //16
    FA fa2_14 (.a(s5[13]), .b(c5[12]), .cin(c4[22]), .sum(s6[14]), .cout(c6[14]));
    //17
    FA fa2_15 (.a(s5[14]), .b(c5[13]), .cin(c4[24]), .sum(s6[15]), .cout(c6[15]));
    //18
    FA fa2_16 (.a(s5[15]), .b(c5[14]), .cin(c4[26]), .sum(s6[16]), .cout(c6[16]));
    //19
    FA fa2_17 (.a(s5[16]), .b(c5[15]), .cin(c4[28]), .sum(s6[17]), .cout(c6[17]));
    //20
    FA fa2_18 (.a(s5[17]), .b(c5[16]), .cin(c4[30]), .sum(s6[18]), .cout(c6[18]));
    //21
    FA fa2_19 (.a(s5[18]), .b(c5[17]), .cin(c4[32]), .sum(s6[19]), .cout(c6[19]));
    //22
    FA fa2_20 (.a(s5[19]), .b(c5[18]), .cin(c4[34]), .sum(s6[20]), .cout(c6[20]));
    //23
    FA fa2_21 (.a(s5[20]), .b(c5[19]), .cin(c4[36]), .sum(s6[21]), .cout(c6[21]));
    //24
    FA fa2_22 (.a(s5[21]), .b(c5[20]), .cin(c4[38]), .sum(s6[22]), .cout(c6[22]));
    //25
    FA fa2_23 (.a(s5[22]), .b(c5[21]), .cin(c4[40]), .sum(s6[23]), .cout(c6[23]));
    //26
    FA fa2_24 (.a(s5[23]), .b(c5[22]), .cin(c4[42]), .sum(s6[24]), .cout(c6[24]));
    //27
    FA fa2_25 (.a(s5[24]), .b(c5[23]), .cin(c4[44]), .sum(s6[25]), .cout(c6[25]));
    //28
    FA fa2_26 (.a(s5[25]), .b(c5[24]), .cin(pp[13][15]), .sum(s6[26]), .cout(c6[26]));
    //29
    FA fa2_27 (.a(pp[15][14]), .b(c5[25]), .cin(pp[14][15]), .sum(s6[27]), .cout(c6[27]));

    wire [31:0] cla_in1, cla_in2;
    wire [31:0] add_result;

    assign cla_in1 = {1'b0, pp[15][15], s6[27], s6[26], s6[25], s6[24], s6[23], s6[22], 
                s6[21], s6[20], s6[19], s6[18], s6[17], s6[16], s6[15], s6[14], 
                s6[13], s6[12], s6[11], s6[10], s6[9], s6[8], s6[7], s6[6], 
                s6[5], s6[4], s6[3], s6[2], s6[1], s6[0], pp[1][0], pp[0][0]};

    assign cla_in2 = {1'b0, c6[27], c6[26], c6[25], c6[24], c6[23], c6[22], c6[21], 
                c6[20], c6[19], c6[18], c6[17], c6[16], c6[15], c6[14], c6[13], 
                c6[12], c6[11], c6[10], c6[9], c6[8], c6[7], c6[6], c6[5], 
                c6[4], c6[3], c6[2], c6[1], c6[0], pp[0][2], pp[0][1], 1'b0};

//32 bit cla adder


    assign muif.out = add_result;


endmodule