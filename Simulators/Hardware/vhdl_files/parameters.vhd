-----------------------------------------------------------------------------------------------------
-- parameters:
-- Description:
-- Used as a top level file which can be used for DSE or other purposes. This gives complete control
-- over parametrization of the simulator. Once a value is changes the design is again synthesized, .rbf file
-- created and ported on FPGA.
-----------------------------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
use work.ceillog.all;

package parameters is

--- Constants
constant OPWIDTH   				: positive := 4;																				-- Op-code width
constant N_NODEx 				: positive := 4;  																				-- No. of rows
constant N_NODEy 				: positive := 4;  																				-- No. of columns
constant N_NODE 				: positive := N_NODEx*N_NODEy;																	-- No. of cores
constant INSTRUCTION_WIDTH   	: positive := 32;																				-- Instruction width	
constant N_NODE_WIDTH			: positive := 10;																				-- Bit width to represent Node_ID
constant MESSAGE_TAG    		: positive := 6;  																				-- Message tag width
constant ADTIMER_WIDTH			: positive := INSTRUCTION_WIDTH-OPWIDTH;														-- Bit width to represent the value to be added to the timer. 
constant rom_adrwidth   		: positive := 8;																				-- ROM address width
constant TIMER_WIDTH			: positive := 32;																				-- Timer width
constant NETWORK_TIME			: positive := INSTRUCTION_WIDTH-(OPWIDTH+MESSAGE_TAG+N_NODE_WIDTH); 							-- Bit width to represent network time
constant PACKET_SIZE			: positive := NETWORK_TIME + TIMER_WIDTH + N_NODE_WIDTH + MESSAGE_TAG;	               			-- Bit width for communication packets (23)
constant DATA_SIZE				: positive := TIMER_WIDTH + MESSAGE_TAG;														-- Bit width for proc <-> comm packets (17)
constant MGMT_PKT_SIZE			: positive := TIMER_WIDTH+N_NODE_WIDTH;															-- Bit width management packets (17)
constant SETUP_TIME    			: positive := 16;																				-- Bit width for setup time
constant L_FIFO_DEPTH   		: positive := 5;																				-- FIFO depth for procBEOs
constant N_FIFO_DEPTH   		: positive := 3;																				-- FIFO depth for commBEOs
constant nports			   		: positive := 4;																				-- Number of ports in commBEO
--constant nports_commBEO		: positive := 2;
constant N_TOKENS			   	: positive := clog2(512);																		-- Bit width for a max. number of tokens used to count tokens 
constant LUT_SIZE       		: positive := 3;																				-- LUT depth
constant LUT_WIDTH      		: positive := 12;																				-- LUT width



--- Array Types
type data_comm_ports is array (1 to nports) of std_logic_vector(PACKET_SIZE-1 downto 0);
type cntr_comm_ports is array (1 to nports) of std_logic;
type data_signals is array (0 to nports) of std_logic_vector(PACKET_SIZE-1 downto 0);
type cntr_signals is array (0 to nports) of std_logic;
type sel_comm_ports is array (0 to nports) of std_logic_vector((nports+1)-1 downto 0);
type mux_sel_signals is array (0 to nports) of std_logic_vector(clog2(nports+1)-1 downto 0);
type mux_input_signals is array (0 to nports) of std_logic_vector((PACKET_SIZE)*(nports+1)-1 downto 0);


end package;

