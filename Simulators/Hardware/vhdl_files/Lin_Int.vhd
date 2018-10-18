-----------------------------------------------------------------------------------------------------
-- Lin_Int:
-- i) LUT (Look Up Table) 
-- Description:
-- This module is for linear interpolation. It generates the unknown values using the LUTs.
-----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;

entity Lin_Int is
	port( 
			clk	:in  std_logic;
			rst	:in  std_logic;
			en    :in  std_logic;
			din	:in  std_logic_vector(LUT_SIZE-1 downto 0);
			dout	:out std_logic_vector(LUT_WIDTH-1 downto 0) 
	);
end Lin_Int;

architecture STR of Lin_Int is

signal out_a : std_logic_vector(LUT_WIDTH-1 downto 0);
signal out_b : std_logic_vector(LUT_WIDTH-1 downto 0);
	
	function interpolate(s1,s2: unsigned (LUT_WIDTH-1 downto 0))
		return unsigned is
		variable temp : unsigned (LUT_WIDTH-1 downto 0);
		begin
			temp := (s1-s2) srl 1;
		return (s1 + temp);
	end interpolate;
	
begin 

U_LUT : entity work.LUT
	port map(
		aclr			=> rst,
		address_a	=> din,
		address_b	=> std_logic_vector(unsigned(din) + 1),
		clock			=> clk,
		q_a			=> out_a,
		q_b			=> out_b
	);

dout <= out_a when en = '0' else std_logic_vector(interpolate(unsigned(out_a), unsigned(out_b)));

end STR;