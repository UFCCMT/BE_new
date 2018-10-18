-------------------------------------------------------------------------------------------------------
-- Emu_Mgmt_Model:
-- i)   Management Buffer
-- ii)  appBEO
-- ii)  procBEO
-- iii) commBEO
-- Description:
-- This is the top level module connecting the various BEOs and the management buffer 
-- (management plane). The I/O to this module consists of signals for flow control implementation 
-- of packets across the network in East, West, North and South direction. 
-- It has also has the start (go) and finish (done) signal for starting and ending execution.
-------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity Emu_Mgmt_Model is
	generic	(
		id           	: integer := 0
	);
	port (
		clk			 		: in  std_logic;
		rst   		 		: in  std_logic;
		go 			 		: in  std_logic;
		packet_E_in			: in  std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrE_in				: in 	std_logic_vector(1 downto 0);
		packet_E_out		: out std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrE_out			: out std_logic_vector(1 downto 0);
		packet_S_in			: in  std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrS_in				: in 	std_logic_vector(1 downto 0);
		packet_S_out		: out std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrS_out   		: out std_logic_vector(1 downto 0);
		packet_W_in			: in  std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrW_in				: in 	std_logic_vector(1 downto 0);
		packet_W_out		: out std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrW_out			: out std_logic_vector(1 downto 0);
		packet_N_in			: in  std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrN_in				: in 	std_logic_vector(1 downto 0);
		packet_N_out		: out std_logic_vector(PACKET_SIZE-1 downto 0);
		cntrN_out			: out std_logic_vector(1 downto 0);
		mgmt_token			: out std_logic_vector(MGMT_PKT_SIZE-1 downto 0);
		mgmt_token_avail 	: out std_logic;
		nbr_token				: in  std_logic;
		done			 		: out std_logic
	);
end Emu_Mgmt_Model;

architecture STR of Emu_Mgmt_Model is

--- APP <-> PROC SIGNALS
signal ireq 				: std_logic;
signal iack 				: std_logic;
signal instruction		: std_logic_vector(INSTRUCTION_WIDTH-1 downto 0);

--- PROC <-> COMM SIGNALS
signal local_buff_empty	: std_logic;
signal comm_rdreq 		: std_logic;
signal local_buff_rdy	: std_logic;
signal comm_wrreq 		: std_logic;
signal comm_proc_packet : std_logic_vector(DATA_SIZE-1 downto 0);
signal proc_comm_packet : std_logic_vector(PACKET_SIZE-1 downto 0);

--- MGMT <-> PROC SIGNALS
signal pktsend				: boolean;
signal pktack 				: boolean;
signal proc2mo				: std_logic_vector(MGMT_PKT_SIZE-1 downto 0);

begin

U_MANAGEMENT_BUFFER : entity work.mgmtObj
	--generic map (
			
	--);
	port map(
		clk 			=> clk,
		rst 			=> rst,
		send			=> pktsend,
		ack 			=> pktack,
		pkt			=> proc2mo,
		nbr_token    => nbr_token,
		token_avail => mgmt_token_avail,
		token			=> mgmt_token
	);

U_APP_BEO : entity work.appBEO 
	generic map(
		id          => id
	)
	port map(
		clk 			=> clk,
		rst 			=> rst,
		ireq        => ireq,
		iack        => iack,
		instruction	=> instruction
	);
	
U_PROC_BEO : entity work.procBEO
	generic map(
		id 				=> id
	)
	port map(
		clk 					=> clk,
		rst 					=> rst,
		go						=> go,
		instruction 		=> instruction,
		ireq   				=> ireq,
		iack					=> iack,
		done					=> done,																			
		local_buff_empty	=> local_buff_empty,
		comm_rdreq			=> comm_rdreq,
		local_buff_rdy		=> local_buff_rdy,
		comm_wrreq			=> comm_wrreq,
		packet_in			=> comm_proc_packet,
		packet_out			=> proc_comm_packet,
		send 					=> pktsend,
		ack					=> pktack,
		pkt					=> proc2mo
	);

U_COMM_BEO : entity work.commBEO
	generic map(
		id 				=> id
	)
	port map(
		clk 						  => clk,
		rst 						  => rst,
		local_port_data_in 	  => proc_comm_packet,
		local_port_data_out	  => comm_proc_packet,
		local_port_empty_in	  => local_buff_empty,													
		local_port_rdreq   	  => comm_rdreq,
		local_port_rdy      	  => local_buff_rdy,
		local_port_wrreq       => comm_wrreq,
		comm_port_data_in(1)   => packet_E_in,
		comm_port_data_in(2)   => packet_S_in,
		comm_port_data_in(3)   => packet_W_in,
		comm_port_data_in(4)   => packet_N_in,
		comm_port_data_out(1)  => packet_E_out,
		comm_port_data_out(2)  => packet_S_out,
		comm_port_data_out(3)  => packet_W_out,
		comm_port_data_out(4)  => packet_N_out,
		comm_port_full_in(1)   => cntrE_in(0),
		comm_port_full_in(2)   => cntrS_in(0),
		comm_port_full_in(3)   => cntrW_in(0),
		comm_port_full_in(4)   => cntrN_in(0),
		comm_port_full_out(1)  => cntrE_out(0),
		comm_port_full_out(2)  => cntrS_out(0),
		comm_port_full_out(3)  => cntrW_out(0),
		comm_port_full_out(4)  => cntrN_out(0),
		comm_port_wrreq_in(1)  => cntrE_in(1),
		comm_port_wrreq_in(2)  => cntrS_in(1),
		comm_port_wrreq_in(3)  => cntrW_in(1),
		comm_port_wrreq_in(4)  => cntrN_in(1),
		comm_port_wrreq_out(1) => cntrE_out(1),
		comm_port_wrreq_out(2) => cntrS_out(1),
		comm_port_wrreq_out(3) => cntrW_out(1),
		comm_port_wrreq_out(4) => cntrN_out(1)
	);

end STR;