LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity procBEO is
	generic(
		id             : integer 	:= 0;
		nports         : positive 	:= 4
	);
	port(
		clk 					: in  std_logic;
		rst					: in  std_logic;
		instruction 		: in  std_logic_vector(INSTRUCTION_WIDTH-1 downto 0);						--- Instruction
		ireq   				: out	std_logic;																	--- Instruction request
		iack					: in  std_logic;																	--- Instruction acknowledge
		done					: out std_logic;																	--- Application done									
		go 					: in 	std_logic;																	--- Start application																	
		local_buff_empty	: out std_logic;																	--- Valid Signal for COMM BEO for new packet
		comm_rdreq			: in  std_logic;
		local_buff_rdy		: out std_logic;
		comm_wrreq			: in  std_logic;
		packet_in			: in  std_logic_vector(DATA_SIZE-1 downto 0);							--- Input Packet from COMM BEO
		packet_out			: out std_logic_vector(PACKET_SIZE-1 downto 0);							--- Output Packet to COMM BEO
		send 					: out	boolean;
		ack					: in 	boolean;
		pkt					: out std_logic_vector(MGMT_PKT_SIZE-1 downto 0)
	);
end procBEO;
	
architecture STR of procBEO is

signal proc_rdack 		: std_logic;
signal proc_wrack 		: std_logic;
signal proc_wrreq 		: std_logic;
signal proc_rdreq 		: std_logic;
signal s_buf_full 		: std_logic;
signal r_buf_empty 		: std_logic;
signal r_buf_full 		: std_logic;
signal s_buf_empty 		: std_logic;
signal proc_packet_out 	: std_logic_vector(PACKET_SIZE-1 downto 0);
signal proc_packet_in 	: std_logic_vector(DATA_SIZE-1 downto 0);
signal r_buf_data 		: std_logic_vector(DATA_SIZE-1 downto 0);
signal r_buf_wrreq 		: std_logic;

signal wr_bk_data 		: std_logic_vector(DATA_SIZE-1 downto 0);
signal wr_bk_en   		: boolean;
signal wr_bk_sel  		: boolean;

signal noop		 			:  boolean;
signal adv_timer 			:  boolean;
signal b_recv	 			:  boolean;
signal nb_send1			:  boolean;
signal nb_send2			:  boolean;

signal done_inst  		: boolean;

--signal ack              : boolean;
signal mgmt_pkt		   : std_logic_vector(TIMER_WIDTH-1 downto 0);

begin

pkt <=  std_logic_vector (to_unsigned(id, N_NODE_WIDTH)) & mgmt_pkt; 
------------------------- FSM + D ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
proc_rdack <= not r_buf_empty;
proc_wrack <= not s_buf_full;

U_DATAPATH : entity work.datapath
	port map(
		clk			=> clk,
		rst 			=> rst,
		instruction	=> instruction(INSTRUCTION_WIDTH-OPWIDTH-1 downto 0),
		packet_in   => proc_packet_in,
		done_exe    => done_inst,
		adv_timer 	=> adv_timer,
		proc_rdack  => proc_rdack, 
		proc_wrack  => proc_wrack,
		b_recv	   => b_recv, 
		noop        => noop,
		send 			=> send,
		ack 			=> ack,
		nb_send1	 	=> nb_send1,
		nb_send2	 	=> nb_send2,  
		wr_bk_sel   => wr_bk_sel, 
		proc_rdreq	=> proc_rdreq,
		proc_wrreq	=> proc_wrreq,
    	wr_bk_en    => wr_bk_en, 
		wr_bk_data  => wr_bk_data,
		packet_out  => proc_packet_out,
		mgmt_pkt    => mgmt_pkt
		);


U_CONTROLLER : entity work.proc_fsm
	port map (
		clk			=> clk,
		rst 			=> rst,
		go 			=> go,
		done_exe		=> done_inst,
		ireq 	      => ireq,
		iack 	      => iack,
		Opcode   	=> instruction(INSTRUCTION_WIDTH-1 downto INSTRUCTION_WIDTH-OPWIDTH),
		noop		   => noop,
		adv_timer 	=> adv_timer,
		b_recv	 	=> b_recv,
		nb_send1 	=> nb_send1,
	   nb_send2 	=> nb_send2,
		done_app   	=> done
		);
		
------------------------- FSM + D ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------- PROC <-> COMM FIFO ---------------------------------------------------------------------------------------------------------
local_buff_empty <= s_buf_empty;

U_SEND_BUFFER : entity work.fifo_buffer
	GENERIC MAP (
		BITWIDTH   => PACKET_SIZE,
		WORDDEPTH  => L_FIFO_DEPTH
	)
	PORT MAP (
		clock		=> clk,
		data		=> proc_packet_out,
		rdreq		=> comm_rdreq,
		sclr     => rst,
		wrreq		=> proc_wrreq,
		empty		=> s_buf_empty,
		full		=> s_buf_full,
		q			=> packet_out
	);

local_buff_rdy <= not r_buf_full; --'1' when (r_buf_full = '0') and (not wr_bk_sel) else '0'; 

U_RECV_BUFFER : entity work.fifo_buffer
	GENERIC MAP (
		BITWIDTH   => DATA_SIZE,
		WORDDEPTH  => L_FIFO_DEPTH
	)
	PORT MAP (
		clock		=> clk,
		data		=> r_buf_data,
		rdreq		=> proc_rdreq,
		sclr     => rst,
		wrreq		=> r_buf_wrreq,
		empty		=> r_buf_empty,
		full		=> r_buf_full,
		q			=> proc_packet_in
	);

r_buf_wrreq <= '1' when wr_bk_sel or (comm_wrreq = '1') else '0'; 
wr_bk_sel   <= comm_wrreq = '0' and wr_bk_en and r_buf_full = '0';	
r_buf_data  <= wr_bk_data when wr_bk_sel else packet_in;
	
----------------------------------------------------------------- PROC <-> COMM FIFO ---------------------------------------------------------------------------------------------------------

end STR;
