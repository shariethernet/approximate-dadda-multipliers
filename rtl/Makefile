TOP = tb_top
DADDA_8 = dadda_8.sv dadda_8_tb.sv
DADDA_16 = dadda_16.sv dadda_16_tb.sv
DADDA_6 = dadda_6.sv dadda_6_tb.sv
DADDA_4 = dadda_4.sv dadda_4_tb.sv

LIBRARIES = m.sv cla_w.sv

R_DADDA_6 = dadda_6.sv r_tb_6.sv
R_DADDA_8 = dadda_8.sv r_tb_8.sv
R_DADDA_16 = dadda_16.sv r_tb_16.sv

DADDA_8_LFA = dadda_8_LFA.sv r_tb_8.sv 
DADDA_8_LS = dadda_8_LS.sv r_tb_8.sv
DADDA_8_LSB = dadda_8_LSB.sv r_tb_8.sv
DADDA_8_MFA = dadda_8_MFA.sv r_tb_8.sv

DADDA_16_LFA = dadda_16_LFA.sv r_tb_16.sv
DADDA_16_LS = dadda_16_LS.sv r_tb_16.sv
DADDA_16_LSB = dadda_16_LSB.sv r_tb_16.sv
DADDA_16_MFA = dadda_16_MFA.sv r_tb_16.sv



APP_FA1 = app_fa1.sv
APP_FA2 = app_fa2.sv
APP_FA3 = app_fa3.sv
APP_FA4 = app_fa4.sv


ADDER_SELECT = $(APP_FA2)

FILESET = $(R_DADDA_6)

LIB = work

all: lib comp run
all-gui: lib comp run-gui

lib:
	if exist $(LIB) (rmdir /s /q $(LIB))
	vlib $(LIB)

comp: lib
	@echo "Compiling"
	vlog +cover -sv -mfcu $(LIBRARIES) $(ADDER_SELECT) $(FILESET) 

run-gui: comp
	@echo "Simulating"
	vsim $(TOP) -do "run -all;" 
	exit

run: comp
	@echo "Simulating"
	vsim -c $(TOP) -do "run -all; " 
	exit