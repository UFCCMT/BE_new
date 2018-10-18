-----------------------------------------------------------------------------------------------------
-- muxblock:
-- Description:
-- Implements a generic mux for odd/even number of inputs. Recommended to use multi-stage mux if 
-- odd/even number of inputs present.
-----------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.parameters.all;
use ieee.numeric_std.all;
use work.ceillog.all;

entity mux_block is
	generic( 
		nbits   : natural := 15;
		mwords  : natural := 4;
		selbits : natural := 2
	);
	port (
		input : in  std_logic_vector(nbits*mwords-1 downto 0);
		sel   : in  std_logic_vector(clog2(mwords)-1 downto 0);
		output: out std_logic_vector(nbits-1 downto 0)
	);
end mux_block;

architecture BHV of mux_block is

begin

	process(sel,input)
		type input_array is array(mwords-1 downto 0) of std_logic_vector(nbits-1 downto 0);
		variable input_temp: input_array;
		variable temp : std_logic_vector(nbits-1 downto 0);
		
		begin
			
			for i in 0 to mwords-1 loop
				for j in 0 to nbits-1 loop
					temp(j) := input(j + (nbits*i));
				end loop;
				
				input_temp(i) := temp;
			end loop;
			
		output <= input_temp(to_integer(unsigned(sel)));
		
		end process;
end BHV;

