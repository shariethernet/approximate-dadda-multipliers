// Testbench template
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

module tb;
    parameter WIDTH = 16;
logic [WIDTH-1:0] in1, in2;
logic [2*WIDTH-1:0] product;

if_multiplier#(.WIDTH(16)) mul_if();
dadda_16#(.WIDTH(16)) dadda16_inst(mul_if);

initial begin
    mul_if.in1 = 16'hffff; // change bitwidths
    mul_if.in2 = 16'hffff;
    $monitor("[%0t] in1 = %d, in2 = %d, prod = %d", $time, mul_if.in1, mul_if.in2, mul_if.out);
    $dumpfile("test1.vcd");
    $dumpvars;
    #10
    $finish;
end
endmodule