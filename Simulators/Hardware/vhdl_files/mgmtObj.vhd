-------------------------------------------------------------------------------------
-- mgmtObj:
-- i) Token Buffer
-- Description:
-- The tokens are generated in the procBEO ans stored in a small buffer using the send & acknowledge
-- signals. The management objects of each core then sends out the tokens from the buffer using 
-- the management network when there is no congestion.
-----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity mgmtObj is
	--generic(
		
	--)
	port (
		clk  			: in  std_logic;
		rst  			: in  std_logic;
		send  		: in  boolean;											-- Request from procBEO
		ack   		: out boolean;											-- Acknowledge to procBEO
		token_avail : out std_logic;										-- Token available signal
		nbr_token    : in  std_logic;										-- Don't broadcast signal (network busy)
		pkt 			: in  std_logic_vector(MGMT_PKT_SIZE-1 downto 0);
		token			: out std_logic_vector(MGMT_PKT_SIZE-1 downto 0)
	);
end mgmtObj;	

architecture STR of mgmtObj is

signal token_gen : std_logic_vector(MGMT_PKT_SIZE-1 downto 0);
 signal buf_rdreq : std_logic;
 signal buf_wrreq : std_logic;
 signal buf_empty : std_logic;
 signal buf_full  : std_logic;
 signal count:std_logic_vector(7 downto 0) := "00000000";

begin
-- No token buffer used to reduce the number of M9K, M144K, MLABs used overall
--token <= pkt when send and nbr_token = '0' else (others => '0');
--token_avail <= '1' when send and nbr_token = '0' else '0';
--ack <= send and nbr_token = '0';

-- Commented out 
 buf_wrreq <= '1' when send and buf_full = '0' else '0';            
 ack 		 <= buf_full = '0'; --send and

 buf_rdreq <= (not buf_empty) and (not nbr_token);
 token_avail <= not buf_empty; --buf_rdreq;
 token <= token_gen when buf_rdreq = '1' else (others => '0');

 U_TOKEN_BUFFER : entity work.fifo_buffer
	 GENERIC MAP (
		 BITWIDTH   => MGMT_PKT_SIZE,
		 WORDDEPTH  => 8
	 )
	 PORT MAP (
		 clock		=> clk,
		 data		=> pkt,
		 rdreq		=> buf_rdreq,
		 sclr     => rst,
		 wrreq		=> buf_wrreq,
		 empty		=> buf_empty,
		 full		=> buf_full,
		 q			=> token_gen
	 );

-- Counter counting number of tokens for verification purpose
 process(clk,rst)
  	 begin 
		 if rst = '1' then
			 count <= (others => '0');
  		 elsif (clk'event and clk= '1') then
  			 if buf_wrreq = '1' then
  				 count <= std_logic_vector( unsigned(count) + 1 );
  			 else	
				 count <= count;
  			 end if;
  		 end if;
  	 end process;
	

end STR;