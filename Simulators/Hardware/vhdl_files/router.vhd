------------------------------------------------------------------------------------------------------------
-- router:
-- Description:
-- This is used for routing packets across the network links from inside the commBEO. The directions
-- are represented as East, West, North, South or Local. Depending on the destination Node_ID and the current
-- Node_ID decision to route in either one of the four directions is taken else the packet is sent to its 
-- own procBEO. The logic used is shortest route from source to destination.
--------------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;

entity router is
	generic(
		beo_id   : integer  := 1;
		left_id  : integer  := 1;
		right_id : integer  := 1
	);
	port (
		dest_id : in  std_logic_vector(N_NODE_WIDTH-1 downto 0);
		output : out std_logic_vector(nports downto 0)
	);
end router;


architecture BHV of router is 


signal rN, rS, rE, rW : boolean;


begin


rN <= unsigned(dest_id) < to_unsigned(left_id,N_NODE_WIDTH);
rS <= unsigned(dest_id) > to_unsigned(right_id,N_NODE_WIDTH);
rE <= unsigned(dest_id) > to_unsigned(beo_id,N_NODE_WIDTH);
rW <= unsigned(dest_id) < to_unsigned(beo_id,N_NODE_WIDTH);


output <= "10000" when rN else
			 "01000" when rW else
			 "00100" when rS else
			 "00010" when rE else
			 "00001";


end BHV;

