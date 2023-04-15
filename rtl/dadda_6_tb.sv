// Testbench template
module tb(if_multiplier.tb_side tbif);
parameter WIDTH = 6;
initial begin 
    tbif.in1 = 6'h3f;
    tbif.in2 = 6'h1;
    $monitor("[%0t] in1 = %d, in2 = %d, prod = %d, overflow = %d", $time,  tbif.in1, 
                                                    tbif.in2, tbif.out, tbif.overflow);
    $dumpfile("test1.vcd");
    $dumpvars;
    #10
    assert(tbif.in1*tbif.in2 == {tbif.overflow,tbif.out}) $display("Test Passed");
    else
    $error("Test failed");
    #10
    $finish;
end

endmodule

module tb_top;
if_multiplier#(6) if_multiplier_inst();
dadda_6 dadda_6_dut(.muif(if_multiplier_inst));
tb tb_inst(.tbif(if_multiplier_inst));
endmodule