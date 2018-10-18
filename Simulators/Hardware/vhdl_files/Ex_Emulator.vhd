-----------------------------------------------------------------------------------------------------
-- Ex_Emulator:
-- i)  Cores
-- ii) Management Network
-- Description:
-- This is top level file that generates the number of cores specified in the parameters file. 
-- When all the cores are done processing instructions all the individual done signal are anded and
-- sent out to indicate that the application is done. The incoming go signal from the software is to start an application
-- execution.
-----------------------------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.parameters.all;
use work.ceillog.all;

entity Ex_Emulator is 
	port (
		clk			: in  std_logic;
		rst   		: in  std_logic;
		go 			: in  std_logic;																--- Start Application
		done			: out std_logic; 															--- Execution Complete
		stall       : in  std_logic;																--- Stall signal if output buffer is full
		data_mgmt_plane : out std_logic_vector(MGMT_PKT_SIZE-1 downto 0);							--- Output the tokens
		--num_tokens	: out std_logic_vector(N_TOKENS-1 downto 0);									--- Indicate the number of tokens
		valid_data		 : out std_logic															--- Indicating valid tokens
	);
end Ex_Emulator;

architecture STR of Ex_Emulator is

type packet_array is array (0 to N_NODE-1) of std_logic_vector(PACKET_SIZE-1 downto 0);     		--- Connections between NODEs
signal packet0, packet1, packet2, packet3 		: packet_array;

type control_signals_array is array (0 to N_NODE-1) of std_logic_vector(1 downto 0);	    		--- Connections for FIFO signals 
signal cntr0, cntr1, cntr2, cntr3               : control_signals_array;

signal done_vector                              : std_logic_vector(N_NODE-1 downto 0);				--- For individual done signals from all the cores

--- Array signals for management network
type token_array_in is array(0 to N_NODE-1) of std_logic_vector(MGMT_PKT_SIZE-1 downto 0);			--- Connections for tokens across the network
type token_array_out is array(0 to N_NODE-1) of std_logic_vector(MGMT_PKT_SIZE-1 downto 0);			--- Connections for tokens across the network
type valid_array_in is array(0 to N_NODE-1) of std_logic;											--- Connections for valid signals indicating valid tokens
type valid_array_out is array(0 to N_NODE-1) of std_logic;											--- Connections for valid signals indicating valid tokens
type mgmt_token_array is array(0 to N_NODE-1) of std_logic_vector(MGMT_PKT_SIZE-1 downto 0);		--- Connections for tokens coming from each core
type mgmt_token_avail_array is array(0 to N_NODE-1) of std_logic;									--- Connections indicating a token available from a core

signal token_out 											: token_array_out;
signal token_in 											: token_array_in;
signal valid_in : valid_array_in;
signal valid_out : valid_array_out;
signal mgmt_token : mgmt_token_array;
signal mgmt_token_avail : mgmt_token_avail_array;
signal nstall : std_logic;
signal count:std_logic_vector(N_TOKENS-1 downto 0) := "000000000";

begin

-- Counter to count total valid tokens
process(clk,rst)
  	begin 
		if rst = '1' then
			count <= (others => '0');
  		elsif (clk'event and clk= '1') then
  			if valid_out(0) = '1' then
  				count <= std_logic_vector( unsigned(count) + 1 );
  			else	
				count <= count;
  			end if;
  		end if;
  	end process;

--num_tokens <= count;	
nstall <= not stall;
done <= '1' WHEN done_vector = (done_vector'RANGE => '1') ELSE '0';
data_mgmt_plane <= token_out(0);
valid_data      <= valid_out(0);

U_NoC_y : for y in 0 to N_NODEy-1 generate
  U_NoC_x : for x in 0 to N_NODEx-1 generate

    CORNER1 : if x = 0 and y = 0 generate
      U_NODEi : entity work.Emu_Mgmt_Model
	     generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst             	=> rst,
          go              	=> go,
          packet_E_in      => packet2((x+1) + y*N_NODEx),
          packet_E_out     => packet0(x + y*N_NODEx),
          cntrE_in         => cntr2((x+1) + y*N_NODEx),
          cntrE_out        => cntr0(x + y*N_NODEx),
          packet_S_in      => packet3(x + (y+1)*N_NODEx),
          packet_S_out     => packet1(x + y*N_NODEx),
          cntrS_in         => cntr3(x + (y+1)*N_NODEx),
          cntrS_out        => cntr1(x + y*N_NODEx),
          packet_W_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_W_out     => open,
          cntrW_in         => std_logic_vector(to_unsigned(0,2)),
          cntrW_out        => open,
          packet_N_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_N_out     => open,
          cntrN_in         => std_logic_vector(to_unsigned(0,2)),
          cntrN_out        => open,
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
		  
    end generate;

    CORNER2 : if x = (N_NODEx-1) and y = 0 generate
      U_NODEi : entity work.Emu_Mgmt_Model
		  generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst              => rst,
          go               => go,
			 packet_E_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_E_out     => open,
          cntrE_in         => std_logic_vector(to_unsigned(0,2)),
          cntrE_out        => open,
          packet_S_in      => packet3(x + (y+1)*N_NODEx),
          packet_S_out     => packet1(x + y*N_NODEx),
          cntrS_in         => cntr3(x + (y+1)*N_NODEx),
          cntrS_out        => cntr1(x + y*N_NODEx),
          packet_W_in      => packet0((x-1) + y*N_NODEx),
          packet_W_out     => packet2(x + y*N_NODEx),
          cntrW_in         => cntr0((x-1) + y*N_NODEx),
          cntrW_out        => cntr2(x + y*N_NODEx),
          packet_N_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_N_out     => open,
          cntrN_in         => std_logic_vector(to_unsigned(0,2)),
          cntrN_out        => open,
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate; 

    CORNER3 : if x = 0 and y = (N_NODEy-1) generate
      U_NODEi : entity work.Emu_Mgmt_Model
		 generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst              => rst,
          go              	=> go,
			 packet_E_in      => packet2((x+1) + y*N_NODEx),
          packet_E_out     => packet0(x + y*N_NODEx),
          cntrE_in         => cntr2((x+1) + y*N_NODEx),
          cntrE_out        => cntr0(x + y*N_NODEx),
          packet_S_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_S_out     => open,
          cntrS_in         => std_logic_vector(to_unsigned(0,2)),
          cntrS_out        => open,
          packet_W_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_W_out     => open,
          cntrW_in         => std_logic_vector(to_unsigned(0,2)),
          cntrW_out        => open,
          packet_N_in      => packet1(x + (y-1)*N_NODEx),
          packet_N_out     => packet3(x + y*N_NODEx),
          cntrN_in         => cntr1(x + (y-1)*N_NODEx),
          cntrN_out        => cntr3(x + y*N_NODEx),
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate;
  
    CORNER4 : if x = (N_NODEx-1) and y = (N_NODEy-1) generate
      U_NODEi : entity work.Emu_Mgmt_Model
		 generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk             	=> clk,
          rst              => rst,
          go              	=> go,
			 packet_E_in     => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_E_out     => open,
          cntrE_in         => std_logic_vector(to_unsigned(0,2)),
          cntrE_out        => open,
          packet_S_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_S_out     => open,
          cntrS_in         => std_logic_vector(to_unsigned(0,2)),
          cntrS_out        => open,
          packet_W_in      => packet0((x-1) + y*N_NODEx),
          packet_W_out     => packet2(x + y*N_NODEx),
          cntrW_in         => cntr0((x-1) + y*N_NODEx),
          cntrW_out        => cntr2(x + y*N_NODEx),
          packet_N_in      => packet1(x + (y-1)*N_NODEx),
          packet_N_out     => packet3(x + y*N_NODEx),
          cntrN_in         => cntr1(x + (y-1)*N_NODEx),
          cntrN_out        => cntr3(x + y*N_NODEx),		
			 nbr_token			=> '0', 
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate;
  
    EDGE1 : if x /= 0 and x /= (N_NODEx-1) and y = (N_NODEy-1) generate
      U_NODEi : entity work.Emu_Mgmt_Model
		 generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst             	=> rst,
          go               => go,
	       packet_E_in      => packet2((x+1) + y*N_NODEx),
          packet_E_out     => packet0(x + y*N_NODEx),
          cntrE_in         => cntr2((x+1) + y*N_NODEx),
          cntrE_out        => cntr0(x + y*N_NODEx),
          packet_S_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_S_out     => open,
          cntrS_in         => std_logic_vector(to_unsigned(0,2)),
          cntrS_out        => open,
          packet_W_in      => packet0((x-1) + y*N_NODEx),
          packet_W_out     => packet2(x + y*N_NODEx),
          cntrW_in         => cntr0((x-1) + y*N_NODEx),
          cntrW_out        => cntr2(x + y*N_NODEx),
          packet_N_in      => packet1(x + (y-1)*N_NODEx),
          packet_N_out     => packet3(x + y*N_NODEx),
          cntrN_in         => cntr1(x + (y-1)*N_NODEx),
          cntrN_out        => cntr3(x + y*N_NODEx),
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate;
  
    EDGE2 : if x /= 0 and x /= (N_NODEx-1) and y = 0 generate
      U_NODEi : entity work.Emu_Mgmt_Model
		  generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst              => rst,
          go               => go,
          packet_E_in      => packet2((x+1) + y*N_NODEx),
          packet_E_out     => packet0(x + y*N_NODEx),
          cntrE_in         => cntr2((x+1) + y*N_NODEx),
          cntrE_out        => cntr0(x + y*N_NODEx),
          packet_S_in      => packet3(x + (y+1)*N_NODEx),
          packet_S_out     => packet1(x + y*N_NODEx),
          cntrS_in         => cntr3(x + (y+1)*N_NODEx),
          cntrS_out        => cntr1(x + y*N_NODEx),
          packet_W_in      => packet0((x-1) + y*N_NODEx),
          packet_W_out     => packet2(x + y*N_NODEx),
          cntrW_in         => cntr0((x-1) + y*N_NODEx),
          cntrW_out        => cntr2(x + y*N_NODEx),
          packet_N_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_N_out     => open,
          cntrN_in         => std_logic_vector(to_unsigned(0,2)),
          cntrN_out        => open,
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate;
  
    EDGE3 : if x = 0 and y /= 0 and y /= (N_NODEy-1) generate
      U_NODEi : entity work.Emu_Mgmt_Model
		  generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst              => rst,
          go               => go,
          packet_E_in      => packet2((x+1) + y*N_NODEx),
          packet_E_out     => packet0(x + y*N_NODEx),
          cntrE_in         => cntr2((x+1) + y*N_NODEx),
          cntrE_out        => cntr0(x + y*N_NODEx),
          packet_S_in      => packet3(x + (y+1)*N_NODEx),
          packet_S_out     => packet1(x + y*N_NODEx),
          cntrS_in         => cntr3(x + (y+1)*N_NODEx),
          cntrS_out        => cntr1(x + y*N_NODEx),
          packet_W_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_W_out     => open,
          cntrW_in         => std_logic_vector(to_unsigned(0,2)),
          cntrW_out        => open,
          packet_N_in      => packet1(x + (y-1)*N_NODEx),
          packet_N_out     => packet3(x + y*N_NODEx),
          cntrN_in         => cntr1(x + (y-1)*N_NODEx),
          cntrN_out        => cntr3(x + y*N_NODEx),
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);    
	end generate;
  
    EDGE4 : if x = (N_NODEx-1) and y /= 0 and y /= (N_NODEy-1) generate
      U_NODEi : entity work.Emu_Mgmt_Model
		  generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst              => rst,
          go               => go,
          packet_E_in      => std_logic_vector(to_unsigned(0,PACKET_SIZE)),
          packet_E_out     => open,
          cntrE_in         => std_logic_vector(to_unsigned(0,2)),
          cntrE_out        => open,
          packet_S_in      => packet3(x + (y+1)*N_NODEx),
          packet_S_out     => packet1(x + y*N_NODEx),
          cntrS_in         => cntr3(x + (y+1)*N_NODEx),
          cntrS_out        => cntr1(x + y*N_NODEx),
          packet_W_in      => packet0((x-1) + y*N_NODEx),
          packet_W_out     => packet2(x + y*N_NODEx),
          cntrW_in         => cntr0((x-1) + y*N_NODEx),
          cntrW_out        => cntr2(x + y*N_NODEx),
          packet_N_in      => packet1(x + (y-1)*N_NODEx),
          packet_N_out     => packet3(x + y*N_NODEx),
          cntrN_in         => cntr1(x + (y-1)*N_NODEx),
          cntrN_out        => cntr3(x + y*N_NODEx),
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate;
  
    INTERIOR : if x /= 0 and x /= (N_NODEx-1) and y /= 0 and y /= (N_NODEy-1) generate
      U_NODEi : entity work.Emu_Mgmt_Model
		  generic map (
			 id					=> x + y*N_NODEx)
        port map(
          clk              => clk,
          rst              => rst,
          go               => go,
          packet_E_in      => packet2((x+1) + y*N_NODEx),
          packet_E_out     => packet0(x + y*N_NODEx),
          cntrE_in         => cntr2((x+1) + y*N_NODEx),
          cntrE_out        => cntr0(x + y*N_NODEx),
          packet_S_in      => packet3(x + (y+1)*N_NODEx),
          packet_S_out     => packet1(x + y*N_NODEx),
          cntrS_in         => cntr3(x + (y+1)*N_NODEx),
          cntrS_out        => cntr1(x + y*N_NODEx),
          packet_W_in      => packet0((x-1) + y*N_NODEx),
          packet_W_out     => packet2(x + y*N_NODEx),
          cntrW_in         => cntr0((x-1) + y*N_NODEx),
          cntrW_out        => cntr2(x + y*N_NODEx),
          packet_N_in      => packet1(x + (y-1)*N_NODEx),
          packet_N_out     => packet3(x + y*N_NODEx),
          cntrN_in         => cntr1(x + (y-1)*N_NODEx),
          cntrN_out        => cntr3(x + y*N_NODEx),
			 nbr_token			=> valid_out((x+1) + y*N_NODEx),
			 mgmt_token			=> mgmt_token(x + y*N_NODEx),
			 mgmt_token_avail => mgmt_token_avail(x + y*N_NODEx),
          done             => done_vector(x + y*N_NODEx)
        );
		  
		token_in(x + y*N_NODEx) <= token_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token(x + y*N_NODEx);
		
		U_REGISTERi: entity work.reg
			generic map(
				wid  => MGMT_PKT_SIZE,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input  => token_in(x + y*N_NODEx),
				output => token_out(x + y*N_NODEx)
			);
			
		valid_in(x + y*N_NODEx) <= valid_out((x+1) + y*N_NODEx) when (valid_out((x+1) + y*N_NODEx) = '1') else mgmt_token_avail(x + y*N_NODEx);
		
		U_VALID_REGISTERi: entity work.reg
			generic map(
				wid  => 1,
				init => '0'
			)
			port map (
				clk    => clk,
				rst    => rst,
				en 	 => nstall,
				input(0)  => valid_in(x + y*N_NODEx),
				output(0) => valid_out(x + y*N_NODEx)
			);
    end generate;  

	end generate;
	
end generate;
end STR;
