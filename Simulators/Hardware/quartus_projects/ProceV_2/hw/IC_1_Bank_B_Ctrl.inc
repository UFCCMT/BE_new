



  FUNCTION  IC_1_Bank_B_Ctrl

 (
	clrn,
	ref_clk,
	pll_mem_clk,
	pll_write_clk,
	pll_write_clk_pre_phy_clk,
	pll_addr_cmd_clk,
	pll_hr_clk,
	pll_p2c_read_clk,
	pll_c2p_write_clk,
	pll_avl_clk,
	pll_config_clk,
	pll_locked,
	afi_clk,
	afi_half_clk,
	g_reserved_control[99..0],
	oct_rzqin,
	event_in,
	clk_src,
	data_src[63..0],
	singlea_flush,
	clk_dst,
	reset_singlea,
	lclk,
	sel_singlea,
	wr_req_singlea,
	singlea_rewind 
 )


  RETURNS

 (
	ready,
	data[63..0],
	addr[15..0],
	dqm[7..0],
	dqs[7..0],
	dqsn[7..0],
	ba[2..0],
	cs_bus[1..0],
	ce[1..0],
	ras,
	cas,
	we,
	odt[1..0],
	ck[1..0],
	ckn[1..0],
	mem_reset_n,
	data_dst[255..0],
	singlea_almost_full_dst,
	wr_ack_singlea,
	almost_full_singlea,
	almost_empty_singlea,
	half_full_singlea,
	g_dreq_singlea,
	singlea_eos 
 );


