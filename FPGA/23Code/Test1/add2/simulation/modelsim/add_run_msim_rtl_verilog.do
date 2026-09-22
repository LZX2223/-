transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/output/FPGA/self/add2 {D:/output/FPGA/self/add2/Verilog2.v}

vlog -vlog01compat -work work +incdir+D:/output/FPGA/self/add2/../add16 {D:/output/FPGA/self/add2/../add16/ADD10.v}
vlog -vlog01compat -work work +incdir+D:/output/FPGA/self/add2/../add16 {D:/output/FPGA/self/add2/../add16/ADD16.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  add

add wave *
view structure
view signals
run 1 us
