transcript on
if ![file isdirectory vhdl_libs] {
	file mkdir vhdl_libs
}

vlib vhdl_libs/altera
vmap altera ./vhdl_libs/altera
vcom -93 -work altera {c:/altera/13.1/quartus/eda/sim_lib/altera_syn_attributes.vhd}
vcom -93 -work altera {c:/altera/13.1/quartus/eda/sim_lib/altera_standard_functions.vhd}
vcom -93 -work altera {c:/altera/13.1/quartus/eda/sim_lib/alt_dspbuilder_package.vhd}
vcom -93 -work altera {c:/altera/13.1/quartus/eda/sim_lib/altera_europa_support_lib.vhd}
vcom -93 -work altera {c:/altera/13.1/quartus/eda/sim_lib/altera_primitives_components.vhd}
vcom -93 -work altera {c:/altera/13.1/quartus/eda/sim_lib/altera_primitives.vhd}

vlib vhdl_libs/lpm
vmap lpm ./vhdl_libs/lpm
vcom -93 -work lpm {c:/altera/13.1/quartus/eda/sim_lib/220pack.vhd}
vcom -93 -work lpm {c:/altera/13.1/quartus/eda/sim_lib/220model.vhd}

vlib vhdl_libs/sgate
vmap sgate ./vhdl_libs/sgate
vcom -93 -work sgate {c:/altera/13.1/quartus/eda/sim_lib/sgate_pack.vhd}
vcom -93 -work sgate {c:/altera/13.1/quartus/eda/sim_lib/sgate.vhd}

vlib vhdl_libs/altera_mf
vmap altera_mf ./vhdl_libs/altera_mf
vcom -93 -work altera_mf {c:/altera/13.1/quartus/eda/sim_lib/altera_mf_components.vhd}
vcom -93 -work altera_mf {c:/altera/13.1/quartus/eda/sim_lib/altera_mf.vhd}

vlib vhdl_libs/altera_lnsim
vmap altera_lnsim ./vhdl_libs/altera_lnsim
vlog -sv -work altera_lnsim {c:/altera/13.1/quartus/eda/sim_lib/mentor/altera_lnsim_for_vhdl.sv}
vcom -93 -work altera_lnsim {c:/altera/13.1/quartus/eda/sim_lib/altera_lnsim_components.vhd}

vlib vhdl_libs/stratixiv_hssi
vmap stratixiv_hssi ./vhdl_libs/stratixiv_hssi
vcom -93 -work stratixiv_hssi {c:/altera/13.1/quartus/eda/sim_lib/stratixiv_hssi_components.vhd}
vcom -93 -work stratixiv_hssi {c:/altera/13.1/quartus/eda/sim_lib/stratixiv_hssi_atoms.vhd}

vlib vhdl_libs/stratixiv_pcie_hip
vmap stratixiv_pcie_hip ./vhdl_libs/stratixiv_pcie_hip
vcom -93 -work stratixiv_pcie_hip {c:/altera/13.1/quartus/eda/sim_lib/stratixiv_pcie_hip_components.vhd}
vcom -93 -work stratixiv_pcie_hip {c:/altera/13.1/quartus/eda/sim_lib/stratixiv_pcie_hip_atoms.vhd}

vlib vhdl_libs/stratixiv
vmap stratixiv ./vhdl_libs/stratixiv
vcom -93 -work stratixiv {c:/altera/13.1/quartus/eda/sim_lib/stratixiv_atoms.vhd}
vcom -93 -work stratixiv {c:/altera/13.1/quartus/eda/sim_lib/stratixiv_components.vhd}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/reg.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/ceillog.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/parameters.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/router.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/fifo_buffer.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/decoder.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/datapath.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/arbiter.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/appBEO_iROM.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/proc_fsm.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/mgmtObj.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/commBEO.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/appBEO.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/procBEO.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/Emu_Mgmt_Model.vhd}
vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/vhdl_files/Ex_Emulator.vhd}

vcom -93 -work work {C:/Users/Krishna/Desktop/Research/Ex_Emulator/working/../vhdl_files/Ex_Emulator_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L stratixiv_hssi -L stratixiv_pcie_hip -L stratixiv -L rtl_work -L work -voptargs="+acc"  Ex_Emulator_tb

add wave *
view structure
view signals
run -all
