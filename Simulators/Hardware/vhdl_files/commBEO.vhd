LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity commBEO is
generic(
		id             : integer 	:= 0;
		nports         : positive 	:= 4
	);
	port (
		clk                   : in  std_logic;
		rst                   : in  std_logic;
		
		local_port_data_in    : in  std_logic_vector(PACKET_SIZE-1 downto 0);
		local_port_data_out   : out std_logic_vector(DATA_SIZE-1 downto 0);
		local_port_empty_in   : in  std_logic;																	
		local_port_rdreq      : out std_logic;
		local_port_rdy      	 : in  std_logic;
		local_port_wrreq      : out std_logic;

		comm_port_data_in     : in  data_comm_ports;
		comm_port_data_out    : out data_comm_ports;
		comm_port_full_in     : in  cntr_comm_ports;
		comm_port_full_out    : out cntr_comm_ports;
		comm_port_wrreq_in    : in  cntr_comm_ports;
		comm_port_wrreq_out   : out cntr_comm_ports
		
		);
end commBEO;

architecture STR of commBEO is

--- Arbiter Signals
signal requests       		: sel_comm_ports;
signal grants         		: sel_comm_ports;

--- Routing Signals
signal route_decision 		: sel_comm_ports;
signal route_data     		: data_signals;

--- FIFO Signals
signal buffer_empty	 		: cntr_signals;
signal buffer_rdreq   		: cntr_signals;
signal buffer_data	 		: data_signals;

signal grant_rdreq    		: sel_comm_ports;
signal grant_wrreq    		: sel_comm_ports;

signal wrack          		: std_logic_vector((nports+1)-1 downto 0);


begin

COMM_FIFOs : for i in 1 to nports generate

	RD_BUFFER_i : entity work.fifo_buffer
	GENERIC MAP (
		BITWIDTH   => PACKET_SIZE,
		WORDDEPTH  => N_FIFO_DEPTH
	)
	PORT MAP (
		clock		=> clk,
		data		=> comm_port_data_in(i),
		rdreq		=> buffer_rdreq(i),
		wrreq		=> comm_port_wrreq_in(i),
		sclr		=> rst,
		empty		=> buffer_empty(i),
		full		=> comm_port_full_out(i),
		q			=> buffer_data(i)
	);

	wrack(i) <= not comm_port_full_in(i);
	comm_port_data_out(i) <= route_data(i)(PACKET_SIZE-1 downto PACKET_SIZE-(N_NODE_WIDTH + MESSAGE_TAG + NETWORK_TIME)) 
							& std_logic_vector(unsigned(route_data(i)(TIMER_WIDTH-1 downto 0)) + unsigned(route_data(i)(PACKET_SIZE-N_NODE_WIDTH-MESSAGE_TAG-1 downto PACKET_SIZE-N_NODE_WIDTH-MESSAGE_TAG-NETWORK_TIME)));

	comm_port_wrreq_out(i) <= '0' when grant_wrreq(i) = std_logic_vector(to_unsigned(0,nports+1)) else '1';
		
end generate;

buffer_data(0) <= local_port_data_in;
buffer_empty(0) <= local_port_empty_in;
local_port_rdreq <= buffer_rdreq(0);
wrack(0) <= local_port_rdy;
local_port_wrreq <= '0' when grant_wrreq(0) = std_logic_vector(to_unsigned(0,nports+1)) else '1';
local_port_data_out <= route_data(0)(PACKET_SIZE-N_NODE_WIDTH-1 downto PACKET_SIZE-N_NODE_WIDTH-MESSAGE_TAG) & route_data(0)(TIMER_WIDTH-1 downto 0);

U_ARBITER_ROUTER_i : for i in 0 to nports generate
	U_ARBITER_i : entity work.arbiter 
		generic map (
			g_width  => 5
		)
		port map(
			clk_i		=> clk,
			rst_i 	=> rst,
			req_i 	=> requests(i),
			gnt_o 	=> grants(i)
		);
	
	U_ROUTER_i : entity work.router
		generic map(
			beo_id   => id,
			left_id  => (id/N_NODEx)*N_NODEx,
			right_id => (((id/N_NODEx) + 1)*N_NODEx) - 1 
		)
		port map(
			dest_id => buffer_data(i)(PACKET_SIZE-1 downto PACKET_SIZE-N_NODE_WIDTH),
			output  => route_decision(i)
		);
	

U_GRANTS_i :	for j in 0 to nports generate	
		grant_rdreq(i)(j) <= grants(j)(i);
		grant_wrreq(i)(j) <= grants(i)(j);
		
	end generate;

	buffer_rdreq(i)   <= '0' when grant_rdreq(i) = std_logic_vector(to_unsigned(0,nports+1)) else '1';
	
U_REQUESTS_i : for j in 0 to nports generate	
		requests(i)(j)  <= (not buffer_empty(j)) and wrack(i) and route_decision(j)(i); 
		route_data(i)   <= buffer_data(j) when grants(i)(j) = '1' else (others => 'Z');
	end generate;

	
	route_data(i) <= (others => '0') when grants(i) = std_logic_vector(to_unsigned(0,nports+1)) else (others => 'Z');

end generate;

end STR;
