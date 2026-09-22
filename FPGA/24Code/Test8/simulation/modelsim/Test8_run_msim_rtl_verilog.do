transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test8 {D:/intelFPGA/18.0/Test8/m_sequence_31.v}

vlog -vlog01compat -work work +incdir+D:/intelFPGA/18.0/Test8 {D:/intelFPGA/18.0/Test8/m_sequence_31_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  m_sequence_31

add wave *
view structure
view signals
run -all
