-----------------------------------------------------------------------------------------------------
-- proc_fsm:
-- i) Decoder
-- Description:
-- This is the main state machine handling the sequencing of events for different instructions, 
-- generating the necessary control signals and instruction fetch for procBEO. 
-----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.parameters.all;
use work.ceillog.all;

entity proc_fsm is
	port (
		clk			: in  std_logic;
		rst 			: in  std_logic;
		go 			: in  std_logic;							-- start
		done_exe 	: in  boolean;								-- instruction execution complete
		ireq 	      : out std_logic;							-- instruction request
		iack 	      : in  std_logic;							-- instruction acknowledge
		Opcode      : in  std_logic_vector(OPWIDTH-1 downto 0); -- op-code
		noop		 	: out boolean;							-- signal for no-op
		adv_timer 	: out boolean;								-- signal for advancing timer
		b_recv	 	: out boolean;								-- signal for receive
		nb_send1	 	: out boolean;							-- signal for send (1st part of send)
		nb_send2	 	: out boolean;							-- signal for send (2nd part of send)
		done_app   	: out std_logic								-- application complete
	
	);
end proc_fsm;

architecture BHV of proc_fsm is

TYPE state_type IS (S_START, S_FETCH, S_SEND2_FETCH, S_DECODE, S_DONE, S_RECV2, S_SEND2);
	SIGNAL state : state_type;
	 
signal nb_send     : boolean;
signal done        : boolean;
signal s_b_recv    : boolean;
signal s_adv_timer : boolean;
signal s_noop      : boolean;


BEGIN
	
U_DECODER : entity work.decoder
	port map	(
		Opcode   	=> Opcode,
		noop		   => s_noop,
		adv_timer 	=> s_adv_timer,
		b_recv	 	=> s_b_recv,
		nb_send 	 	=> nb_send,
		done     	=> done
	);

done_app	 <= '1' when state = S_DONE else '0';
nb_send1  <= nb_send and state = S_DECODE;
nb_send2  <= state = S_SEND2;
b_recv    <= s_b_recv;
ireq      <= '1' when state = S_FETCH or state = S_SEND2_FETCH else '0';
adv_timer <= s_adv_timer and state = S_DECODE;
noop      <= s_noop;

PROCESS(clk, rst)
	BEGIN
		IF(rst = '1')THEN
			state <= S_START;
		ELSIF(RISING_EDGE(clk))THEN
			CASE state IS
				WHEN S_START =>
					if (go = '1') then
						state <= S_FETCH;
					else
						state <= S_START;
					end if;
			
				WHEN S_FETCH =>
					if iack = '0' then 
					 state <= S_FETCH;
					else
					 state <= S_DECODE;
					end if;
				
				WHEN S_DECODE => 
					if done then
						state <= S_DONE;
					elsif s_b_recv and (not done_exe) then
						state <= S_RECV2;
					elsif nb_send then
						state <= S_SEND2_FETCH;
					else
						state <= S_FETCH;
					end if;
		      
				WHEN S_SEND2_FETCH => 
					if iack = '0' then 
					 state <= S_SEND2_FETCH;
					else
					 state <= S_SEND2;
					end if;

				WHEN S_RECV2 =>
					if done_exe then 
						state <= S_FETCH;
					else
						state <= S_RECV2;
					end if;
					
				WHEN S_SEND2 =>
					if done_exe then 
						state <= S_FETCH;
					else
						state <= S_SEND2;
					end if;
					
				WHEN S_DONE =>
					state	<= S_DONE;
					
				when others => null;
			
			END CASE;
		END IF;
	END PROCESS;

END BHV;