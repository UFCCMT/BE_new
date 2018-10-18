	 
	--*********************************************************************
	--*  ENTITY  user                                                     *
	--*  Created    :  Mon May 19 11:20:48 2014                           *
	--*********************************************************************
	




	LIBRARY   ieee;
	USE       ieee.std_logic_1164.all;
	USE       ieee.std_logic_unsigned.all;
	USE       ieee.std_logic_arith.all;
	use 		 IEEE.numeric_std.all;
	use 	    work.parameters.all;
	use       work.ceillog.all;



	 
	ENTITY   user   IS
	    PORT(

	               
	              --Internal Bus Connections
	              	clrn                           : IN    STD_LOGIC;                          -- 0: global reset 
	              	clk0                           : IN    STD_LOGIC;                          -- Clock
	              	go                             : IN    STD_LOGIC;
	              	done                           : OUT   STD_LOGIC;
	              	Bank_A_ready                   : IN    STD_LOGIC;                          -- 1: Memory controller is ready for use, 0: Initializing (due to reset)
	              	data_src                       : OUT   STD_LOGIC_VECTOR( 63 DOWNTO 0 );    -- Data to the port src of FIFO fifo
	              	wr_req_fifo                    : OUT   STD_LOGIC;                          -- FIFO fifo write request signal
	              	wr_ack_fifo                    : IN    STD_LOGIC;                          -- FIFO fifo write acknowledge signal
	              	fifo_eos                       : IN    STD_LOGIC;                          -- 1: fifo port End of Stream pulse
	              	fifo_flush                     : OUT   STD_LOGIC;                          -- Flush FIFO data (assert high when the transfer is over)
	              	fifo_rewind                    : OUT   STD_LOGIC                           -- 1: Start read port from the beginning of the FIFO
	    );
	END   user;
	 
	 



	ARCHITECTURE  user_arch  OF  user  IS
	signal wrreq :  std_logic;
	signal mgmt_pkt  : std_logic_vector(MGMT_PKT_SIZE-1 downto 0);
	signal sim_done : std_logic;
	signal stall_emulator : std_logic;

	BEGIN
	
	Emulator : entity work.Ex_Emulator
	port map(
		clk			=> clk0,
		rst   		=> (not clrn),
		go 			=> go,												
		done		=> sim_done,								
		stall       => stall_emulator,
		data_mgmt_plane => mgmt_pkt,
		valid_data		 => wrreq
	);

	stall_emulator			     		<=  not wr_ack_fifo;
	wr_req_fifo           		 		<=  wrreq and Bank_A_ready;
	fifo_flush            		 		<=  sim_done;
	fifo_rewind           		 		<=  '0';
	data_src(MGMT_PKT_SIZE-1 downto 0) 	<=  mgmt_pkt;
	data_src(63 downto MGMT_PKT_SIZE) 	<= (others => '0');
	done 						 		<=  sim_done;


	END  user_arch;



