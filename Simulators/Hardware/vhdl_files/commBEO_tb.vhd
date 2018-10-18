LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.parameters.all;
use work.ceillog.all;
                     
ENTITY commBEO_tb IS
END commBEO_tb;
ARCHITECTURE BHV OF commBEO_tb IS

-- Constants 
	constant TEST_WIDTH 		: positive := 8;
	constant TIMEOUT    		: time     := TEST_WIDTH*100000000 ns;
                                      
-- I/O Signals                                                   
	SIGNAL clk 							: STD_LOGIC := '0';
	SIGNAL rst  						: STD_LOGIC := '0';
	SIGNAL local_port_data_in    	: std_logic_vector(PACKET_SIZE-1 downto 0) := (others => '0');
	SIGNAL local_port_data_out   	: std_logic_vector(DATA_SIZE-1 downto 0);
	SIGNAL local_port_empty_in  	: std_logic := '0';																	
	SIGNAL local_port_rdreq      	: std_logic;
	SIGNAL local_port_rdy        	: std_logic := '0';
	SIGNAL local_port_wrreq      	: std_logic;

	SIGNAL comm_port_data_in     	: data_comm_ports := (others => (others => '0'));
	SIGNAL comm_port_data_out    	: data_comm_ports ;
	SIGNAL comm_port_full_in     	: cntr_comm_ports := (others => '0');
	SIGNAL comm_port_full_out    	: cntr_comm_ports ;
	SIGNAL comm_port_wrreq_in    	: cntr_comm_ports := (others => '0');
	SIGNAL comm_port_wrreq_out   	: cntr_comm_ports;
	
BEGIN
	UUT_COMM_BEO : entity work.commBEO
	generic map(
		id             => 8,
		nports         => nports
	)
	port map(
		clk                   => clk,
		rst                   => rst,
		
		local_port_data_in    => local_port_data_in,
		local_port_data_out   => local_port_data_out,
		local_port_empty_in   => local_port_empty_in,											
		local_port_rdreq      => local_port_rdreq,
		local_port_rdy      	 => local_port_rdy,
		local_port_wrreq      => local_port_wrreq,

		comm_port_data_in     => comm_port_data_in,
		comm_port_data_out    => comm_port_data_out,
		comm_port_full_in     => comm_port_full_in,
		comm_port_full_out    => comm_port_full_out,
		comm_port_wrreq_in    => comm_port_wrreq_in,
		comm_port_wrreq_out   => comm_port_wrreq_out
		
		);
	
	clk <= not clk after 5 ns ;
	
---  Test Bench Statements
	tb : PROCESS   
	
	BEGIN 

		rst   <= '1';

		--- LOCAL SIGNALS
--		local_port_data_in  <= std_logic_vector(to_unsigned(30,BEO_WIDTH)) & std_logic_vector(to_unsigned(0, MESSAGE_TAG)) & std_logic_vector(to_unsigned(5,NETWORK_TIME)) & std_logic_vector(to_unsigned(0,TIMER_WIDTH));
		local_port_data_in  <= (others => '0');
		local_port_empty_in <= '1';
		local_port_rdy 	  <= '0';

		--- COMM SIGNALS
		comm_port_data_in(1)  <= (others => '0');
		comm_port_full_in(1)  <= '0';
		comm_port_wrreq_in(1) <= '0';

		comm_port_data_in(2)  <= (others => '0');
		comm_port_full_in(2)  <= '0';
		comm_port_wrreq_in(2) <= '0';

		comm_port_data_in(3)  <= (others => '0');
		comm_port_full_in(3)  <= '0';
		comm_port_wrreq_in(3) <= '0';

		comm_port_data_in(4)  <= (others => '0');
		comm_port_full_in(4)  <= '0';
		comm_port_wrreq_in(4) <= '0';

		WAIT UNTIL (clk'event and clk = '1');
		WAIT UNTIL (clk'event and clk = '1');
		
		rst   <= '0';
			
---   Start 
		WAIT UNTIL (clk'event and clk = '1');
		WAIT UNTIL (clk'event and clk = '1');
		
		--- LOCAL SIGNALS
--		local_port_data_in  <= std_logic_vector(to_unsigned(30,BEO_WIDTH)) & std_logic_vector(to_unsigned(0, MESSAGE_TAG)) & std_logic_vector(to_unsigned(5,NETWORK_TIME)) & std_logic_vector(to_unsigned(0,TIMER_WIDTH));
		local_port_data_in  <= (others => '0');
		local_port_empty_in <= '0';
		local_port_rdy 	  <= '1';

		--- COMM SIGNALS
--		comm_port_data_in(1)  <= std_logic_vector(to_unsigned(7,BEO_WIDTH)) & std_logic_vector(to_unsigned(1, MESSAGE_TAG)) & std_logic_vector(to_unsigned(5,NETWORK_TIME)) & std_logic_vector(to_unsigned(1,TIMER_WIDTH));
		comm_port_data_in(1)  <= (others => '0');
		comm_port_full_in(1)  <= '0';
		comm_port_wrreq_in(1) <= '0';

--		comm_port_data_in(2)  <= std_logic_vector(to_unsigned(2,BEO_WIDTH)) & std_logic_vector(to_unsigned(2, MESSAGE_TAG)) & std_logic_vector(to_unsigned(5,NETWORK_TIME)) & std_logic_vector(to_unsigned(2,TIMER_WIDTH));
		comm_port_data_in(2)  <= (others => '0');
		comm_port_full_in(2)  <= '0';
		comm_port_wrreq_in(2) <= '0';

--		comm_port_data_in(3)  <= std_logic_vector(to_unsigned(9,BEO_WIDTH)) & std_logic_vector(to_unsigned(3, MESSAGE_TAG)) & std_logic_vector(to_unsigned(5,NETWORK_TIME)) & std_logic_vector(to_unsigned(3,TIMER_WIDTH));
		comm_port_data_in(3)  <= (others => '0');
		comm_port_full_in(3)  <= '0';
		comm_port_wrreq_in(3) <= '0';

--		comm_port_data_in(4)  <= std_logic_vector(to_unsigned(14,BEO_WIDTH)) & std_logic_vector(to_unsigned(4, MESSAGE_TAG)) & std_logic_vector(to_unsigned(5,NETWORK_TIME)) & std_logic_vector(to_unsigned(4,TIMER_WIDTH));
		comm_port_data_in(4)  <= (others => '0');
		comm_port_full_in(4)  <= '0';
		comm_port_wrreq_in(4) <= '0';
		
		WAIT UNTIL (clk'event and clk = '1');
		WAIT UNTIL (clk'event and clk = '1');
		WAIT UNTIL (clk'event and clk = '1');

		local_port_empty_in   <= '1';
		comm_port_wrreq_in(1) <= '0';
		comm_port_wrreq_in(2) <= '0';
		comm_port_wrreq_in(3) <= '0';
		comm_port_wrreq_in(4) <= '0';
		
--		WAIT UNTIL (clk'event and clk = '1');
--		WAIT UNTIL (clk'event and clk = '1');
--		
--		local_port_empty_in   <= '1';
--		comm_port_wrreq_in(1) <= '0';
--		comm_port_wrreq_in(2) <= '0';
--		comm_port_wrreq_in(3) <= '0';
--		comm_port_wrreq_in(4) <= '0';
		
	wait;                                                      
	END PROCESS tb;
                                          
END BHV;
