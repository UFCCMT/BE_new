-----------------------------------------------------------------------------------------------------
-- arbiter:
-- Description:
-- This arbiter uses bit twiddling logic which takes up wire resources. It is a round robin arbiter which
-- is parametrized. 
-- Alternate implementations: 
-- i)  State machine based
-- ii) Shift Register based
-----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity arbiter is
   generic (
        g_width          : natural := 4
	);
   port (
        clk_i    	:in  std_logic;
		  rst_i  	:in  std_logic;
        req_i    	:in  std_logic_vector(g_width - 1 downto 0); -- request vector
        gnt_o    	:out std_logic_vector(g_width - 1 downto 0)  -- grant vector
        
   );
end entity;

architecture BHV of arbiter is

    ----------------Internal Registers------------------------
    signal s_reqs      :std_logic_vector(g_width - 1 downto 0);
    signal s_gnts      :std_logic_vector(g_width - 1 downto 0);
    signal s_gnt       :std_logic_vector(g_width - 1 downto 0);
    signal s_gntM      :std_logic_vector(g_width - 1 downto 0);
    signal s_pre_gnt   :std_logic_vector(g_width - 1 downto 0);
    signal s_zeros     :std_logic_vector(g_width - 1 downto 0);
    
begin

    s_zeros <= (others => '0');
    
    main: process (clk_i, rst_i) 
		begin
			if (rst_i = '1') then     
				 --gnt_o         <= (others => '0');
				 s_pre_gnt     <= (others => '0');
			elsif (rising_edge(clk_i)) then  
				 s_pre_gnt     <= s_gntM; -- remember current grant vector, for the next operation
			end if;
    end process main;

    -- bit twiddling :
    s_gnt  <= req_i  and std_logic_vector(unsigned(not req_i) + 1);
    s_reqs <= req_i  and not (std_logic_vector(unsigned(s_pre_gnt ) - 1) or s_pre_gnt);
    s_gnts <= s_reqs and std_logic_vector(unsigned(not s_reqs)+1);
    s_gntM <= s_gnt  when s_reqs = s_zeros else s_gnts;

	 -- output
	 gnt_o  <= s_gntM;
	 
end BHV; 
