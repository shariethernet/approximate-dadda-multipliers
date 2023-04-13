// Testbench template
module tb;
    parameter WIDTH = 8;
logic [WIDTH-1:0] in1, in2;
logic [2*WIDTH-1:0] product;

your_module#(.anypara(someparam))(connect ports here);
initial begin
    in1 = 8'hff; // change bitwidths
    in2 = 8'hff;
    $monitor("[%0t] in1 = %d, in2 = %d, prod = %d", $time, in1, in2, product);
    $dumpfile("test1.vcd");
    $dumpvars;
    #10
    $finish;
end
endmodule