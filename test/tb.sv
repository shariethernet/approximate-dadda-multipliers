module tb;
parameter WIDTH = 8;
logic [WIDTH-1:0] in1, in2;
logic out[WIDTH-1:0][WIDTH-1:0];

partial_product#(.WIDTH(WIDTH)) dut(.in1(in1), .in2(in2), .out(out));

initial begin 
    in1 = 8'hff;
    in2 = 8'hff;
    $monitor("\n in1 = %b , in2 = %b, out = %p",in1, in2, out);
    $display("\n");
    for(int i= 0; i<WIDTH; i=i+1) begin 
        for(int j=0; j<WIDTH; j=j+1) begin 
            $strobe("\t %b",out[i][j]);
        end
        $display("\n");
    end
    #100 $finish;
end


endmodule