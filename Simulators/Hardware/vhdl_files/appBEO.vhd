-----------------------------------------------------------------------------------------------------
-- appBEO:
-- i)  ROM 
-- ii) Program Counter
-- Description:
-- ROM is used for storing instructions while program counter is used to generate the address for the
-- next instruction. The procBEO sends a request when it is not busy to grab the next instruction and gets
-- an acknowledge on instruction fetch. If procBEO is busy the program counter is not incremented. 
-----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;

entity appBEO is
	generic(
		id          : integer := 0
	);
	port(
		clk			: in  std_logic;
		rst			: in  std_logic;
		ireq   		: in  std_logic;												--- request from procBEO
		iack  		: out std_logic;												--- acknowledge to procBEO
		instruction : out std_logic_vector(INSTRUCTION_WIDTH-1 downto 0)		    --- Instruction Output to PROC BEO
		);
end appBEO;
		
architecture STR of appBEO is

signal pc_next 		: std_logic_vector(rom_adrwidth-1 downto 0);
signal pc 	         : std_logic_vector(rom_adrwidth-1 downto 0);
signal ack 			   : std_logic;
signal count_done  	: std_logic;
	 
begin

iack			<= ireq;
pc_next 		<= std_logic_vector(unsigned(pc) + 1) when ireq = '1' else
					pc;
			
--- Program Counter		
process(clk,rst)
begin
	if rst = '1' then
		pc <= (others => '1');
	elsif rising_edge(clk) then
		pc <= pc_next;
	end if;
end process;
	
--- ROM
U_MEMORY : entity work.appBEO_iROM
generic map(
		id       => id
	)
	port map(
		address 	=> pc_next,
		clock 	=> clk,
		q       	=> instruction
	);
	
	
end STR;
