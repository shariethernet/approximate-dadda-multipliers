# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

# Compile the sources.
#vlog -sv m.sv tb.sv
vlog -sv cla_w.sv
#vlog +cover -sv tb.sv

#coverage -assert -directive -cvg -codeAll

# Simulate the design.
vsim -coverage -c tb
run -all
exit
