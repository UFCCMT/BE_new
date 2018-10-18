-----------------------------------------------------------------------------------------------------
-- datapath:
-- i)  	Tag register
-- ii) 	Destination ID register
-- iii) Network time register
-- iv)  Timekeeper register
-- v) 	Linear Interpolator
-- Description:
-- Datapath is mainly used for processing the different instructions and accordingly generating packets
-- packets to send across and/or increment the internal timer. For computation times that are not available
-- a linear interpolator is used with a look up table.
-----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity datapath is
	port(
		clk			  : in  std_logic;
		rst 			  : in  std_logic;
		instruction	  : in  std_logic_vector(INSTRUCTION_WIDTH-OPWIDTH-1 downto 0);
		packet_in     : in  std_logic_vector(DATA_SIZE-1 downto 0);
		adv_timer 	  : in  boolean;
		ack 			  : in  boolean;
		send			  : out boolean;
		proc_rdack    : in  std_logic;
		proc_wrack    : in  std_logic;
		b_recv	 	  : in  boolean;
		noop          : in  boolean;
		nb_send1	 	  : in  boolean;
		nb_send2	 	  : in  boolean;
		wr_bk_sel     : in  boolean;
		proc_rdreq	  : out std_logic;
		proc_wrreq	  : out std_logic;
		done_exe      : out boolean;
		wr_bk_en      : out boolean;
		wr_bk_data    : out std_logic_vector(DATA_SIZE-1 downto 0);
		packet_out    : out std_logic_vector((N_NODE_WIDTH + MESSAGE_TAG + NETWORK_TIME + TIMER_WIDTH) - 1 downto 0);
		mgmt_pkt		  : out std_logic_vector(TIMER_WIDTH-1 downto 0)
		);
end datapath;
	
architecture STR of datapath is

signal reg_en           : std_logic;
--- signals
signal s_adtimer        : std_logic_vector(ADTIMER_WIDTH-1 downto 0);
signal s_nw_time, r_nw_time        : std_logic_vector(NETWORK_TIME-1 downto 0);
signal s_set_time			: std_logic_vector(SETUP_TIME-1 downto 0);
signal s_tag            : std_logic_vector(MESSAGE_TAG-1 downto 0);
signal r_tag				: std_logic_vector(MESSAGE_TAG-1 downto 0);
signal s_DID    			: std_logic_vector(N_NODE_WIDTH-1 downto 0);
signal r_DID    			: std_logic_vector(N_NODE_WIDTH-1 downto 0);

--- timekeeping signals
signal timer_en 			: std_logic;
signal s_time				: std_logic_vector(TIMER_WIDTH-1 downto 0);	
signal r_time				: std_logic_vector(TIMER_WIDTH-1 downto 0);	

signal mux1_op				: std_logic_vector(ADTIMER_WIDTH-1 downto 0);
signal mux2_op				: std_logic_vector(TIMER_WIDTH-1 downto 0);

signal s_done_exe    : boolean;
signal tag_match        : boolean;
signal recv_done        : boolean;
signal send_done        : boolean;

-- LUT Signals
-- signal rw_sel           : integer;
-- signal int_en           : std_logic;
-- signal lut_out          : std_logic_vector(LUT_WIDTH-1 downto 0);
-- signal r_adv_timer		: boolean;
-- signal r_done_exe 		: boolean;


begin

-- Change r_adv_timer to adv_timer if not using LUT

--- INSTRUCTION DONE SIGNAL 
recv_done  <= proc_rdack = '1' and b_recv and tag_match;
send_done  <= nb_send2 and proc_wrack = '1';
done_exe   <= ack and s_done_exe;
s_done_exe <= adv_timer or recv_done or send_done;
send       <= s_done_exe; -- use r_done_exe for LUT

-- process(clk, rst)
  -- begin
    -- if rst = '1' then
      -- r_done_exe   <= FALSE;
    -- elsif (clk = '1' and clk'event) then
      --if (en = '1') then
        -- r_done_exe <= s_done_exe;
      --end if;
    -- end if;
-- end process;

s_adtimer  <= instruction(s_adtimer'range);
s_nw_time  <= instruction(s_nw_time'range);
s_set_time <= instruction(s_set_time'range);
s_tag      <= instruction(INSTRUCTION_WIDTH-OPWIDTH-1 downto INSTRUCTION_WIDTH-OPWIDTH-MESSAGE_TAG); 
s_DID      <= instruction(INSTRUCTION_WIDTH-OPWIDTH-MESSAGE_TAG-1 downto INSTRUCTION_WIDTH-OPWIDTH-MESSAGE_TAG-N_NODE_WIDTH);

reg_en <= '1' when nb_send1 else '0';

U_TAG_REGISTER :	entity work.reg
	generic map (
		wid	 => MESSAGE_TAG
	)
	port map (
		clk	 	 => clk,
		rst	 	 => rst,
		en		 	 => reg_en,
		input     => s_tag,
		output	 => r_tag
	);				
				
U_DID_REGISTER :	entity work.reg
	generic map (
		wid	 => N_NODE_WIDTH
	)
	port map (
		clk	 	 => clk,
		rst	 	 => rst,
		en		 	 => reg_en,
		input  	 => s_DID,
		output	 => r_DID
	);			

U_NETWORK_TIME_REGISTER :	entity work.reg
	generic map (
		wid	 => NETWORK_TIME
	)
	port map (
		clk	 	 => clk,
		rst	 	 => rst,
		en		 	 => reg_en,
		input  	 => s_nw_time,
		output	 => r_nw_time
	);		
	
---- For LUT. Please comment out if not using LUT
  -- process(clk)
  -- begin
   -- if (clk = '1' and clk'event) then
    -- if (adv_timer) then
      -- r_adv_timer <= adv_timer;
	 -- else 
		-- r_adv_timer <= not adv_timer;
    -- end if;
   -- end if;
  -- end process;

	
--- PACKET		
packet_out <= r_DID & r_TAG & r_nw_time & r_time;	
mgmt_pkt   <= r_time;		
		
--- TAG MATCH 
tag_match   <= unsigned(s_tag) = unsigned(packet_in(DATA_SIZE-1 downto DATA_SIZE-MESSAGE_TAG));


--- WRITE BACK
wr_bk_en   <= proc_rdack = '1' and b_recv and (not tag_match);
wr_bk_data <= packet_in;

--- FIFO REQUEST SIGNALS
proc_rdreq <= '1' when recv_done or wr_bk_sel else '0';
proc_wrreq <= '1' when send_done else '0';


---------------------------------------------------------------------------- TIMEKEEPING -----------------------------------------------------------------------------------------
mux1_op  <= (std_logic_vector(to_unsigned(0,ADTIMER_WIDTH-SETUP_TIME)) & s_set_time) when nb_send2 else 
			   s_adtimer when (adv_timer) else --std_logic_vector(resize(unsigned(lut_out), ADTIMER_WIDTH)) when (r_adv_timer) else -- For LUT
		     (others => '0');
		
mux2_op  <= packet_in(DATA_SIZE-MESSAGE_TAG-1 downto 0) when (recv_done and unsigned(packet_in(DATA_SIZE-MESSAGE_TAG-1 downto 0)) >= unsigned(r_time)) else r_time;

s_time   <= std_logic_vector(unsigned(mux2_op) + unsigned(mux1_op));

timer_en <= '1' when adv_timer or (recv_done) or (nb_send2) else '0';
		
U_TIMEKEEPER_REG : entity work.reg
	generic map (
		wid		=>	 TIMER_WIDTH
	)
	port map (
		clk 		=> clk,
		rst		=> rst,
		en 		=> timer_en,
		input 	=> s_time,
		output 	=> r_time
	);				
	
---------------------------------------------------------------------------- TIMEKEEPING -----------------------------------------------------------------------------------------

---------------------------------------------------------------------------- LUT -------------------------------------------------------------------------------------------------
	-- with to_integer(unsigned(s_adtimer)) select
	-- rw_sel <= 0 when 4,
				-- 1 when 8,
				-- 2 when 16,  
				-- 3 when 32,
				-- 4 when 64,
				-- 5 when 128,
				-- 6 when 256,
				-- 7 when 512,
				-- 8 when 1024,
				-- 9 when others;
				
	-- int_en <= '1' when rw_sel = 9 else '0';
	
	-- U_LINEAR_INTERPOLATOR : entity work.Lin_Int
	-- port map(
		-- clk	=> clk,
		-- rst	=> rst,
		-- en    => int_en,
		-- din	=> std_logic_vector(to_unsigned(rw_sel, LUT_SIZE)),
		-- dout	=> lut_out
	-- );

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


end STR;


