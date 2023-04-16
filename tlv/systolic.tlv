\m4_TLV_version 1d: tl-x.org
\SV
   // Based on the design from: http://surf-vhdl.com/how-to-implement-pipeline-multiplier-vhdl/?utm_source=mult-pipe&utm_medium=LK2&utm_campaign=ACLEAD
   // Converted to TL-Verilog with validity added, as well as inline stimulus and checking.
   
   // The logic diagram for this example, from Surf VHDL is (originally) here:
   //   http://surf-vhdl.com/wp/wp-content/uploads/2016/12/Mult-35x35_break_PIPE2.jpg

   m4_makerchip_module
 
\TLV
   |sa
      ?$valid
         
         // Random stimulus
         @0
            m4_rand($aa, 34, 0)
            m4_rand($bb, 34, 0)
         
         
         // 1. A.lower * B.lower (green rectangle in surf-vhdl diagram)
         @1
            <<1$Mac[63:0] = $reset? 0: $Mac + $aa*$bb;
         
            // Sticky error flag.
            
            
            
            // Assert these to end simulation (before Makerchip cycle limit).
            *passed = *cyc_cnt > 40;
            *failed = 1'b0;

\SV
   endmodule
