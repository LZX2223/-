transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/output/FPGA/self/shiyan\ 2/t2 {D:/output/FPGA/self/shiyan 2/t2/coder.v}

