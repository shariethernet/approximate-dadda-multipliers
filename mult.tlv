\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module  
\TLV ripple_carry_adder(#_width, $_in1, $_in2, $_out, /_top)
   /slice[#_width-1:0]
      $carry_in = (#slice == 0) ? 1'b0 : /_top/slice[(#slice-1)% #_width]$carry_out;
      $out = /_top$_in1[#slice] ^ /_top$_in2[#slice] ^ $carry_in;
      //$carry_out =  (/_top$_in1[#slice] + /_top$_in2[#slice] + $carry_in) > 2'b1;
      $carry_out = (/_top$_in1[#slice] & /_top$_in2[#slice]) | (/_top$_in1[#slice]  & $carry_in) | (/_top$_in2[#slice] & $carry_in); 
   $_out[#_width-1:0] = /slice[*]$out;
\TLV carry_look_ahead_adder_v1(#_width, $_in1, $_in2, $_out, /_top)
   /slice[#_width-1:0]
      $carry_in = (#slice == 0) ? 1'b0 : /_top/slice[(#slice-1)% #_width]$carry_out;
      $propagate = /_top$_in1[#slice] ^ /_top$_in2[#slice];
      $generate = /_top$_in1[#slice] & /_top$_in2[#slice];
      $carry_out = ($propagate & $carry_in) | $generate;
      $sum = $propagate ^ $carry_in;
   $_out[#_width-1:0] = /slice[*]$sum;

\TLV mfa($_in1, $_in2, $_cin, $_out, $_pr, $_gn, /_top)
   /_top$_pr = /_top$_in1 | /_top$_in2;
   /_top$_gn = /_top$_in1 & /_top$_in2;
   /_top$_out = /_top$_in1 ^ /_top$_in2 ^ /_top$_cin;

// This is a functional model of the Look ahead logic - Will not be synthesized as intended
\TLV look_ahead_logic_w(#_width, $_co, $_pr, $_gn, $_gpr, $ggn, $_cc, /_top)
   /slice[#_width-1:0]
      $cc_in = ( #slice == 0) ? /_top$_co : /_top/slice[(#slice-1)%#_width]$cc_out;
      $cc_out = ($_pr[#slice] & $cc_in) | $_gn[#slice] ;
   $_cc[#_width-1:0] = /slice[*]$cc_out; // NO group propagate and generate
   $_gpr = & $_pr;
   /xx[#_width-1:0]
      $pand = 1'b1;
      /yy[#_width-1:#_width-#xx]
         $pand = $pand & $_pr[#yy];
      $gand = $_gn[#xx] & (&/xx[#xx]/yy[*]$pand);
   $_ggn = +(/xx[*]$gand);

// This will not be a CLA in Synthesis. DONT USE 
\TLV cla_w(#_width, $_in1, $_in2, $_co, $_out, $_gpr, $_ggn, /_top)
   //$_pr[#_width-1:0] = #_width'b0;
   //$_gn[#_width-1:0] = #_width'b0;
   /slice[#_width-1:0]
      $cinn = ( #slice == 0) ? /_top$_co : /_top/slice[(#slice-1) % #_width]$cc_out;
      $pr =  /_top$_in1[#slice] | /_top$_in2[#slice];
      $gn =  /_top$_in1[#slice] & /_top$_in2[#slice];
      $cc_out = ($pr & $cinn) | $gn ;
      $out = /_top$_in1[#slice] ^ /_top$_in2[#slice] ^ $cinn;
   $_out[#_width-1:0] = /slice[*]$out;
   $ppr[#_width-1:0] = /slice[*]$pr;
   $_gpr = & $ppr;
   $pgn[#_width-1:0] = /slice[*]$gn;
   
   \SV_plus
      bit *temp2;
      genvar i;
      for(i=0; i<= #_width-1; i=i+1) begin 
         bit *temp1;
         always_comb begin
         for(integer j=4-1; j<= 4 -i; j = j+1) begin 
            *temp1 = & $ppr[j];
         end
         *temp2 = *temp2 + (*temp1 & $pgn[i]);
       end
       end
       $_ggn = *temp2;
   ///xx[#_width-1:0]
   //   $pand = 1'b1;
   //   /yy[#_width-1:#_width-#xx]
   //      $pand = $pand & $_pr[#yy];
   //   $gand = $_gn[#xx] & (&/xx[#xx]/yy[*]$pand);
   // $_ggn = +(/xx[*]$gand);

// -------------- Actual stuff begins here ------------
// $_in1 => operand 1
// $_in2 => operand 2
//  $_czero => carry 0 from outside
// $_cin => carry 1 - #width-1 from the CLA
// $_out => sum
// $_pr and $_gn is the propagate and generate
\TLV mfa_w(#_width, $_in1, $_in2, $_czero, $_cin, $_out, $_pr, $_gn, /_top)
   /slice[#_width-1:0]
      $cinn = ( #slice == 0) ? /_top$_czero : /_top$_cin[#slice-1];
      $pr =  /_top$_in1[#slice] | /_top$_in2[#slice];
      $gn =  /_top$_in1[#slice] & /_top$_in2[#slice];
      $out = /_top$_in1[#slice] ^ /_top$_in2[#slice] ^ $cinn;
   $_out[#_width-1:0] = /slice[*]$out;
   $_pr[#_width-1:0] = /slice[*]$pr;
   $_gn[#_width-1:0] = /slice[*]$gn;

// $_in1 => operand 1
// $_in2 => operand 2
// $_out => sum output from the mfa
// $_czero => initial carry from outside
\TLV lookahead_4($_czero, $_pr4, $_gr4, $_gpr, $_ggn, $_cgen, /_top)
   $cgen_0 = /_top$_gr4[0] | (/_top$_pr4[0] & /_top$_czero);
   $cgen_1 = /_top$_gr4[1] | (/_top$_pr4[1] & (/_top$_gr4[0] | (/_top$_pr4[0] & /_top$_czero)));
   $cgen_2 = /_top$_gr4[2] | (/_top$_pr4[2] & (/_top$_gr4[1] | (/_top$_pr4[1] & (/_top$_gr4[0] | (/_top$_pr4[0] & /_top$_czero)))));
   $_cgen[2:0] = {$cgen_2 , $cgen_1, $cgen_0};
   $_ggn = /_top$_gr4[3] | (/_top$_pr4[3] & /_top$_gr4[2]) | (/_top$_pr4[3] & /_top$_pr4[2] & /_top$_gr4[1]) | (/_top$_pr4[3] & /_top$_pr4[2] & /_top$_pr4[1] & /_top$_gr4[0]); 
   $_gpr = & (/_top$_pr4);

// This has mfa and cla together in the same block
\TLV mfa_cla_4(#_width,$_in1, $_in2, $_out, $_czero, $_cout, $_ggn, $_gpr, /_top)
   /slice[#_width-1:0]
      //$cinn = ( #slice == 0) ? /_top$_czero : $cin[#slice-1];
      $pr =  /_top$_in1[#slice] | /_top$_in2[#slice];
      $gn =  /_top$_in1[#slice] & /_top$_in2[#slice];
      //$out = /_top$_in1[#slice] ^ /_top$_in2[#slice] ^ $cinn;
   //$_out[#_width-1:0] = /slice[*]$out;
   $pr4[#_width-1:0] = /slice[*]$pr;
   $gn4[#_width-1:0] = /slice[*]$gn;
   
   $cin_0 = $gn4[0] | ($pr4[0] & $_czero);
   $cin_1 = $gn4[1] | ($pr4[1] & ($gn4[0] | ($pr4[0] & /_top$_czero)));
   $cin_2 = $gn4[2] | ($pr4[2] & ($gn4[1] | ($pr4[1] & ($gn4[0] | ($pr4[0] & /_top$_czero)))));
   $cin[2:0] = {$cin_2, $cin_1, $cin_0};
   
   /_top$_ggn = $gn4[3] | ($pr4[3] & $gn4[2]) | ($pr4[3] & $pr4[2] & $gn4[1]) | ($pr4[3] & $pr4[2] & $pr4[1] & $gn4[0]); 
   /_top$_gpr = & (/_top$pr4);
   /out_slice[#_width-1:0]
      $cinn = ( #out_slice == 0) ? /_top$_czero : /_top$cin[#out_slice-1];
      $out = /_top$_in1[#out_slice] ^ /_top$_in2[#out_slice] ^ $cinn;
   $_out[#_width-1:0] = /out_slice[*]$out;

// Partial Product generation - check this
\TLV pp_generate(#_width, $_in1, $_in2, $_out,/_top)
   /xx[#_width-1:0]
      /yy[#_width-1:0]
         $out_val = /_top$_in1[xx] * /_top$_in2[yy];
      $yy_out_val[#_width-1:0] = /yy[*]$out_val;
   $_out[#_width-1:0] = /xx[*]$yy_out_val;

\TLV
   $reset = *reset;
   m4_define(['WIDTH'],4)
   $addend1[WIDTH-1:0] = *cyc_cnt[WIDTH-1:0];
   $addend2[WIDTH-1:0] = *cyc_cnt[WIDTH-1:0] + 1'b1;
   //$sum[3:0] = 0;
   //$pr[3:0] = 0;
   //$gn[3:0] = 0;
   $initialcarry = 0;
   //m4+pp_generate(4, $addend1, $addend2, $out, /top)
   m4+mfa_cla_4(4,$addend1, $addend2, $out, $initialcarry, $cout, $ggn, $gpr, /top)
   //m4+mfa_w(4,$addend1, $addend2, $initialcarry, $cin_from_la,$sum, $pr, $gn, /top)
   //m4+lookahead_4($initialcarry,$pr, $gr,$gpr, $ggn, $cin_from_la , /top)
   
   //m4+ripple_carry_adder(WIDTH, $addend1, $addend2, $sum, /top)
   //m4+carry_look_ahead_adder_v1(WIDTH, $addend1, $addend2, $sum_cla_1, /top)
   //m4+cla_4(4'b1101, 4'b0011, 1'b0, $cout, $cout, /top)
   //$co = 1'b0;
   //m4+cla_w(WIDTH, $addend1, $addend2, $co, $out, $gpr, $ggn, /top)
   //...

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
