module tb;
    parameter WIDTH = 4;
    logic [WIDTH-1:0] in1;
    logic [WIDTH-1:0] in2;
    logic czero;
    logic [WIDTH-1:0] sum;
    logic cout;
    if_mfa_cla#(.WIDTH(4)) if_mfa_cla_inst(.in1(in1), .in2(in2),.czero(czero), .sum(sum), .cout(cout));

    cla_4 cla_inst(.clif(if_mfa_cla_inst));
    mfa#(.WIDTH(4)) mfa_inst(.mif(if_mfa_cla_inst));

    initial begin 
        in1 = 1;
        in2 = 2;
        czero = 0;
        $monitor("[%0t] in1 = %d, in2 = %d, czero = %d, sum = %d, cout = %d ", $time, in1, in2, czero, sum, cout);

    end

endmodule