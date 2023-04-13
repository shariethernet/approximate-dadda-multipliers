
module tb;

    parameter WIDTH = 16;
    logic [WIDTH-1:0] in1;
    logic [WIDTH-1:0] in2;
    logic czero;
    logic [WIDTH-1:0] sum;
    logic cout;
    /*
    if_mfa_cla#(.WIDTH(4)) if_mfa_cla_inst(.in1(in1), .in2(in2),.czero(czero), .sum(sum), .cout(cout));

    cla_4 cla_inst(.clif(if_mfa_cla_inst));
    mfa#(.WIDTH(4)) mfa_inst(.mif(if_mfa_cla_inst));
*/

    if_cla_adder#(16) if_cla_adder_inst();

    f_cla_16 uut(.fclif(if_cla_adder_inst));

    initial begin 
        if_cla_adder_inst.in1 = 16'hffff;
        if_cla_adder_inst.in2 = 16'hffff;
        if_cla_adder_inst.czero = 0;
        $monitor("[%0t] in1 = %d, in2 = %d, czero = %d, sum = %d, cout = %d ", $time, if_cla_adder_inst.in1, if_cla_adder_inst.in2, if_cla_adder_inst.czero, if_cla_adder_inst.sum, if_cla_adder_inst.cout);
        /*
        #10
        if((if_cla_adder_inst.in1+if_cla_adder_inst.in2) == {if_cla_adder_inst.cout,if_cla_adder_inst.sum}) begin 
            $display("%d+%d =%d : Test Passed",if_cla_adder_inst.in1, if_cla_adder_inst.in2,{if_cla_adder_inst.cout,if_cla_adder_inst.sum} );
        end else begin 
            $display("%d+%d =%d : Test Failed",if_cla_adder_inst.in1, if_cla_adder_inst.in2,{if_cla_adder_inst.cout,if_cla_adder_inst.sum} );
        end
            */
    end

    always begin 
        #10
        assert ((if_cla_adder_inst.in1+if_cla_adder_inst.in2) == {if_cla_adder_inst.cout,if_cla_adder_inst.sum} ) $display ("Test passed");
        else $error("Test Failed\n Expected = %b, Obtained = %b",(if_cla_adder_inst.in1+if_cla_adder_inst.in2),{if_cla_adder_inst.cout,if_cla_adder_inst.sum});
        #100
        $finish;
    end

endmodule
