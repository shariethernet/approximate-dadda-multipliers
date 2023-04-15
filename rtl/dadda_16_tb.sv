// Testbench template

module tb(if_multiplier.tb_side tbif);
parameter WIDTH = 16;
initial begin 
    tbif.in1 = 16'hf;
    tbif.in2 = 16'hf;
    $monitor("[%0t] in1 = %d, in2 = %d, prod = %b, overflow = %d", $time,  tbif.in1, 
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
if_multiplier#(16) if_multiplier_inst();
dadda_16 dadda_16_dut(.muif(if_multiplier_inst));
tb tb_inst(.tbif(if_multiplier_inst));


endmodule