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
