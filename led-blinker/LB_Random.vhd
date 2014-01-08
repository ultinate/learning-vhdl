--------------------------------------
-- LED Blinker: Random module
-- 
-- Display pseudo-random sequence of LED pattern
-- 
-- author:  Nathanael Wettstein
-- updated: 2013-12-19
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.math_real.all;

--------------------------------------

entity LB_Random is
	generic ( width : integer :=  8 );
port(
	clk : in std_logic;
	sys_reset : in std_logic;
	led : out std_logic_vector (width-1 downto 0)
);
end LB_Random;

----

architecture LB_Random_arch of LB_Random is

	signal random_num : std_logic_vector (width-1 downto 0);
	constant enable : std_logic := '1';
	constant reset : std_logic := '0';

	component lfsr is
		port (
			enable : in  std_logic;                    			-- Enable counting
			clk    : in  std_logic;                    			-- Input clock
			reset  : in  std_logic;                    			-- Input reset
			cout   : out std_logic_vector (width-1 downto 0) 	-- Output of the counter
		);
	end component;
	
begin
	
	U1: lfsr port map (enable => enable, clk => clk, reset => reset, cout => random_num);
	
	-- LED update process
	process(clk, sys_reset, random_num)
	begin
		-- reset: all LEDs off
		if sys_reset = '0' then
			led <= (others => '0');
		-- display random number
		elsif rising_edge(clk) then
			led <= random_num;
		end if;
	end process;
	
end LB_Random_arch;