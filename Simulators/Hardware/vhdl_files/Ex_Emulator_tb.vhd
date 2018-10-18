LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.parameters.all;
use work.ceillog.all;
                     
ENTITY Ex_Emulator_tb IS
END Ex_Emulator_tb;
ARCHITECTURE BHV OF Ex_Emulator_tb IS

-- Constants 
	constant TEST_WIDTH 		: positive := 8;
	constant TIMEOUT    		: time     := TEST_WIDTH*100000000 ns;
                                      
-- I/O Signals                                                   
	SIGNAL clk 		: STD_LOGIC := '0';
	SIGNAL rst  	: STD_LOGIC := '0';
	SIGNAL done 	: STD_LOGIC;
	SIGNAL go 		: STD_LOGIC := '0';
	SIGNAL stall   : STD_LOGIC := '0';
	SIGNAL data_mgmt_plane : std_logic_vector(MGMT_PKT_SIZE-1 downto 0);
	SIGNAL valid_data : std_logic;
	
BEGIN
	UUT_N_NODE_EMULATOR : entity work.Ex_Emulator
	PORT MAP (
		rst      => rst,
		clk 		=> clk,
		go 		=> go,
	   done		=> done,
		stall 	=> stall,
		data_mgmt_plane => data_mgmt_plane,
		valid_data      => valid_data
	);
	
	clk <= not clk after 5 ns ;
	
---  Test Bench Statements
	tb : PROCESS   
	
	BEGIN 

		rst   <= '1';
		go 	<= '0';
		WAIT UNTIL (clk'event and clk = '1');
		WAIT UNTIL (clk'event and clk = '1');
		rst   <= '0';

---   Start 
		WAIT UNTIL (clk'event and clk = '1');
		go 	<= '1';
		
		
	wait;                                                      
	END PROCESS tb;
                                          
END BHV;
