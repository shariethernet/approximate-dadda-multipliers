module cla_w#(parameter WIDTH = 4)(
    input logic [WIDTH-1:0] in1, in2,
    input logic czero,
    output logic [WIDTH-1:0] sum,
    output logic cout
);
logic [WIDTH-1:0] pr,gn;
logic [WIDTH-1:0] cin;

assign pr = in1 | in2;
assign gn = in1 & in2;
assign cin[0] = czero;

genvar i;
for(i=1;i<=WIDTH-1;i=i+1) begin 
    assign cin[i] = gn[i-1] | (pr[i-1] &cin[i-1]);
end

assign sum = in1 ^ in2 ^ cin;
assign cout = cin[WIDTH-1];

endmodule

module tb();
    parameter WIDTH = 16;
    logic [WIDTH-1:0] in1;
    logic [WIDTH-1:0] in2;
    logic czero;
    logic [WIDTH-1:0] sum;
    logic cout;
    cla_w#(WIDTH) dut(.in1(in1),.in2(in2),.sum(sum),.czero(czero),.cout(cout));
    initial begin 
        in1 = 3;
        in2 = 4;
        czero = 0;
        $monitor("[%0t] in1 = %d, in2 = %d, czero = %d, sum = %d, cout = %d ", $time, in1, in2, czero, sum, cout);
    end
endmodule