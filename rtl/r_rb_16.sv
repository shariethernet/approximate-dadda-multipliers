class RandomInputs#(int WIDTH = 8, int limit = 214738);
  rand logic [WIDTH-1:0] in1;
  rand logic [WIDTH-1:0] in2;

  constraint c_limit { in1 * in2 < limit; }
  constraint c_in1 { in1 >= 0; }
  constraint c_in2 { in2 >= 0; }

  function void post_randomize();
    $display("Applying inputs: in1=%d, in2=%d", in1, in2);
  endfunction
endclass


module tb_top;
if_multiplier#(16) if_multiplier_inst();
dadda_16 dadda_16_dut(.muif(if_multiplier_inst));
tb tb_inst(.tbif(if_multiplier_inst));
endmodule





module tb #(parameter WIDTH = 16)(if_multiplier.tb_side tbif);
  // Parameters
  parameter limit = 100; // Set the limit for in1*in2
  parameter int seed = 12345; // Set the seed for randomization
  parameter int NUM_TESTS = 10; // Number of test iterations to run
  integer fd;
  RandomInputs random_inputs;
  real total_relative_error = 0;
  real relative_error;
  real actual;
  logic [WIDTH-1:0] in1=0;
  logic [WIDTH-1:0] in2=0;
  logic [2*WIDTH-1:0] in1_32;
  logic [2*WIDTH-1:0] in2_32;
  logic [2*WIDTH-1:0] design_out;
  initial begin
    random_inputs = new();
    random_inputs.srandom(seed);
    for (int i = 0; i < NUM_TESTS; i++) begin // repeat the test multiple times
      random_inputs.randomize();
      in1 = random_inputs.in1;
      in2 = random_inputs.in2;
      tbif.in1 = in1;
      tbif.in2 = in2;

      in1_32 = {16'b0,in1};
      in2_32 = {16'b0,in2};

      #1
      design_out = tbif.out;  
      // Apply inputs
      //#1 wait for one time unit before applying inputs
      //$display("Applying inputs: in1=%d, in2=%d", tbif.in1,tbif.in2);

      // Evaluate output
      //1 // wait for one more time unit before evaluating output
      
      actual = in1_32*in2_32;
      $strobe("Design Output: out=%d", design_out);
      $strobe("Actual Output: out =%d",actual);

      if ((( in1*in2) - design_out) < 0) begin
      relative_error = (design_out - ( in1*in2))  / actual;
      $strobe("here");
      end else if ((( in1*in2) - design_out) >0) begin
      relative_error = (( in1*in2) - design_out) / actual;
      $strobe("hereee");
      end else begin 
          relative_error = 0;
      end
      total_relative_error = total_relative_error + relative_error;

      // Report relative error
     // $strobe("Actual value of in1*in2: %d", actual);
      $strobe("Relative error: %f", relative_error * 100);
      $strobe("________________________________");
      #1;
    end
    $display("Testbench finished");
    $display("Average relative error over %0d tests: %.2f%%", NUM_TESTS, (total_relative_error / NUM_TESTS) * 100);
    // Write the average relative error to a file
    fd = $fopen("results_16.txt","w");
    $fwrite(fd, "Average relative error over %0d tests: %.2f%%", NUM_TESTS, (total_relative_error / NUM_TESTS) * 100);
    $fclose(fd);
    $finish;
  end

endmodule