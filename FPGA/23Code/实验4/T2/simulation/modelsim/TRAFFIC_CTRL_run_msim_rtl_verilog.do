transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/output/FPGA/self/shiyan4/T2 {D:/output/FPGA/self/shiyan4/T2/TRAFFIC_CTRL.v}

