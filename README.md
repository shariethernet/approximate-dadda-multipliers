# Dadda Multipliers and Approximate Dadda Multipliers

This repository contains 4, 6, 8, 16-bit Dadda Multipliers and various configurations of Approximate Dadda Multipliers.

The approcimate dadda multiplers are constructed by replacing the reduction stage with various approximate full adder blocks in various configurations geared towards area, power and delay. The details can be found in this paper.

## Running the designs

This repository uses FuseSoC for IP management and my custom version of Edalize (which will be released soon !!) with Synopsys DC support. 

You can run synthesis using the makefile provided, and you can also run simulation using the makefile provided in the `rtl/` directory

## Note

- Simulation and synthesis can be performed only with simulators that are sypport IEEE 1800-2017 System Verilog.  
- We use Mentor QuestaSim for simulation and Synopsys Design Compiler for synthesis
- It is easy to port to your choice of open source simulators by slight modifications to inferface related constructs
- Makefile in `rtl/` uses some powershell specific commands, make sure to modify them to bash/zsh/csh/your choice of shell before running




