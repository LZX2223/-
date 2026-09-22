transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test1 {D:/intelFPGA/18.0/Test1/full_adder.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test1 {D:/intelFPGA/18.0/Test1/adder_16bit.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test1 {D:/intelFPGA/18.0/Test1/adder_4bit.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test1 {D:/intelFPGA/18.0/Test1/half_adder.v}
vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test1 {D:/intelFPGA/18.0/Test1/or_gate.v}

vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test1 {D:/intelFPGA/18.0/Test1/adder_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  adder_tb

add wave *
view structure
view signals
run -all
