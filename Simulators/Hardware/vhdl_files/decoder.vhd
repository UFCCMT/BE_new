-----------------------------------------------------------------------------------------------------
-- decoder:
-- Description:
-- Implements a decoder to decode the instruction op-code and enable the necessary signals to initiate an action. 
-- The current instructions which can be decoded are:
-- i)   Non-Blocking Send
-- ii)  Blocking Receive
-- iii) Advance Timer (for computation purposes when the timer just has to be increased by a certain amount)
-- iv)  No-operation (Idle)
-- v)   Done (Used as a last instruction in a list of instructions given to a particular processor)
-----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.parameters.all;

entity decoder is
	port	(
		Opcode      : in  std_logic_vector(OPWIDTH-1 downto 0);
		noop		 	: out boolean;
		adv_timer 	: out boolean;
		b_recv	 	: out boolean;
		nb_send 	 	: out boolean;
		done     	: out boolean
	); 
end decoder;

architecture BHV of decoder is

begin

	noop		 <= Opcode = std_logic_vector(to_unsigned(0,OPWIDTH));
	adv_timer <= Opcode = std_logic_vector(to_unsigned(1,OPWIDTH));	--- Advance Timer
	b_recv	 <= Opcode = std_logic_vector(to_unsigned(4,OPWIDTH));		--- Blocking Recv
	nb_send 	 <= Opcode = std_logic_vector(to_unsigned(8,OPWIDTH));	--- Non-Blocking Send
	done      <= Opcode = std_logic_vector(to_signed(-1,OPWIDTH));
	
	
end BHV;
