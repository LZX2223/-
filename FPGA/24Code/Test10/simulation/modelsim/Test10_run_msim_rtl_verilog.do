transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test10 {D:/intelFPGA/18.0/Test10/elevator_controller.v}

vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test10 {D:/intelFPGA/18.0/Test10/tb_elevator_controller.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  elevator_controller

add wave *
view structure
view signals
run -all
