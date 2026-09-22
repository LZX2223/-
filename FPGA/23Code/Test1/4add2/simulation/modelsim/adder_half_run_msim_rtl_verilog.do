transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Epan/Study/FPGA/23Code/Test1/4add2 {D:/Epan/Study/FPGA/23Code/Test1/4add2/adder_half.v}

