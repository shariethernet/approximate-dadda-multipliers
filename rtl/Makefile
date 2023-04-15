TOP = tb_top
DADDA_8 = dadda_8.sv dadda_8_tb.sv
DADDA_16 = dadda_16.sv dadda_16_tb.sv
DADDA_6 = dadda_6.sv dadda_6_tb.sv
DADDA_4 = dadda_4.sv dadda_4_tb.sv
LIBRARIES = m.sv cla_w.sv

FA = fa.sv
APP_FA1 = app_fa1.sv
APP_FA2 = app_fa2.sv
APP_FA3 = app_fa3.sv
APP_FA4 = app_fa4.sv

ADDER_SELECT = $(FA)
FILESET = $(DADDA_6)

LIB = work

all: lib comp run
all-gui: lib comp run-gui

lib:
	if exist $(LIB) (rmdir /s /q $(LIB))
	vlib $(LIB)

comp: lib
	@echo "Compiling"
	vlog +cover -sv $(LIBRARIES) $(ADDER_SELECT) $(FILESET) 

run-gui: comp
	@echo "Simulating"
	vsim $(TOP) -do "run -all;" 
	exit

run: comp
	@echo "Simulating"
	vsim -c $(TOP) -do "run -all; " 
	exit